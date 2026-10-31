import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import sys
import time


ROOT = Path(__file__).resolve().parents[1]
RUN = ROOT / 'results/final_run'
FIELDS = ['job', 'phase', 'design', 'clock_model', 'task', 'status', 'expected', 'engine', 'address_width', 'data_width', 'depth', 'scope', 'seconds', 'source_sha256', 'config_sha256', 'log', 'failure_summary']
ROWS = []


def digest(data):
    return hashlib.sha256(data).hexdigest()


def normalized(text, width):
    for parameter, value in [('ADDR_WIDTH', str(width)), ('DATA_WIDTH', '8')]:
        pattern = r'(\bparameter\s+(?:(?:int|integer)\s+)?' + parameter + r'\s*=\s*)\d+'
        text = re.sub(pattern, lambda match: match[1] + value, text)
    return text


def outcome(log, code):
    if code == 124:
        return 'TIMEOUT'
    matches = re.findall(r'DONE \((PASS|FAIL|UNKNOWN|ERROR|TIMEOUT), rc=(\d+)\)', log)
    if not matches:
        return 'ERROR'
    status, recorded_code = matches[-1]
    expected_codes = {'PASS': 0, 'FAIL': 2, 'UNKNOWN': 4, 'ERROR': 16, 'TIMEOUT': 8}
    return status if code == int(recorded_code) == expected_codes[status] else 'ERROR'


def verify_sources():
    manifest = json.loads((ROOT / 'SOURCE_MANIFEST.json').read_text())
    for relative, expected in manifest.items():
        source = (ROOT / relative).resolve()
        assert source.is_relative_to(ROOT) and source.is_file(), relative
        assert digest(source.read_bytes()) == expected, relative
    return digest((ROOT / 'SOURCE_MANIFEST.json').read_bytes())


def source_digest(folder, names):
    return digest(json.dumps({name: digest((folder / name).read_bytes()) for name in names}, sort_keys=True).encode())


def save(state='RUNNING', detail=''):
    RUN.mkdir(parents=True, exist_ok=True)
    with (RUN / 'results.csv').open('w', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(ROWS)
    temporary = RUN / 'progress.tmp'
    temporary.write_text(json.dumps({'state': state, 'detail': detail, 'completed': len(ROWS), 'last': ROWS[-1] if ROWS else None}, indent=2) + '\n')
    temporary.replace(RUN / 'progress.json')


def record(row):
    ROWS.append(row)
    save()
    print(row['job'] + ': ' + row['status'], flush=True)
    if row['status'] != row['expected']:
        raise RuntimeError('Core gate unresolved: ' + row['job'] + ' expected ' + row['expected'] + ', observed ' + row['status'])


def versions():
    commands = {'yosys': ['yosys', '-V'], 'sby': ['sby', '--version'], 'z3': ['z3', '--version'], 'abc': ['yosys-abc', '-c', 'version'], 'python': [sys.executable, '--version']}
    result = {}
    for name, command in commands.items():
        process = subprocess.run(command, capture_output=True, text=True, timeout=20)
        result[name] = {'command': command, 'returncode': process.returncode, 'output': (process.stdout + process.stderr).strip()}
        assert process.returncode == 0, name
    plugin = Path('/usr/local/share/yosys/plugins/slang.so')
    result['yosys_slang'] = {'version': 'NOT REPORTED', 'path': str(plugin), 'sha256': digest(plugin.read_bytes()) if plugin.exists() else 'NOT FOUND'}
    (RUN / 'versions.json').write_text(json.dumps(result, indent=2) + '\n')


def direct(job, phase, design, model, task, width, depth, sources, top, engine, expected, timeout=1800, optional=False):
    folder = RUN / job
    folder.mkdir(parents=True)
    for name, text in sources.items():
        (folder / name).write_text(normalized(text, width))
    names = list(sources)
    options = ['mode ' + task, 'multiclock ' + ('on' if model == 'multi' else 'off'), 'depth ' + str(depth)]
    if task in ['bmc', 'prove']:
        options.append('aigsmt z3')
    config = '[options]\n' + '\n'.join(options) + '\n\n[engines]\n' + engine + '\n\n[script]\nplugin -i slang\nread_slang ' + ' '.join(names) + ' --top ' + top + '\nprep -top ' + top + '\n\n[files]\n' + '\n'.join(names) + '\n'
    (folder / 'case.sby').write_text(config)
    environment = dict(os.environ, TIMEOUT=str(timeout + 60), EVID=str(folder), DEPS=' '.join(names + ['case.sby']))
    command = [str(ROOT / 'run_quiet.sh'), 'run', '--', 'timeout', str(timeout), 'nice', '-n', '10', 'sby', '-f', 'case.sby']
    started = time.monotonic()
    with (folder / 'launcher.log').open('w') as stream:
        subprocess.run(command, cwd=folder, env=environment, stdout=stream, stderr=subprocess.STDOUT, check=True)
    logpath = folder / 'run.log'
    log = logpath.read_text()
    wrapper = (folder / 'run.status').read_text()
    code = int(re.search(r'rc=(\d+)', wrapper).group(1))
    status = outcome(log, code)
    if task == 'cover' and status == 'PASS' and 'Unreached cover' in log:
        status = 'FAIL'
    failures = [line for line in log.splitlines() if 'summary:   failed assertion' in line]
    scope = {'prove': 'unbounded checker proof', 'cover': 'bounded reachability', 'bmc': 'bounded'}[task]
    row = dict(job=job, phase=phase, design=design, clock_model=model, task=task, status=status, expected=expected, engine=engine, address_width=width, data_width=8, depth=depth, scope=scope, seconds=round(time.monotonic() - started, 3), source_sha256=source_digest(folder, names), config_sha256=digest(config.encode()), log=str(logpath.relative_to(ROOT)), failure_summary=' | '.join(failures))
    (folder / 'command.json').write_text(json.dumps({'cwd': str(folder), 'argv': command, 'TIMEOUT': timeout + 60, 'DEPS': environment['DEPS']}, indent=2) + '\n')
    if optional:
        ROWS.append(row)
        save()
        print(job + ': ' + status + ' (optional)', flush=True)
    else:
        record(row)
    return folder, row


def batch(group, phase, width, models, designs, cdc=False):
    folder = RUN / group
    folder.mkdir()
    for name in designs:
        design_folder = folder / name
        design_folder.mkdir()
        expected_bmc = 'FAIL' if ((cdc and name in ['M5b', 'M5b_rd2wr']) or (not cdc and name in ['M1', 'M2', 'M3', 'M4'])) else 'PASS'
        command = ['bash', str(ROOT / 'tools/run_p2.sh'), name + '=' + ('async_fifo.sv' if name == 'CONTROL' else 'mutants/' + name + '/async_fifo.sv')]
        environment = dict(os.environ, W=str(width), DATA_WIDTH='8', MODES=' '.join(models), TMO='1800', BMC_ENGINE='abc', EXPECTED_BMC=expected_bmc)
        environment.pop('HARN', None)
        if cdc:
            environment['HARN'] = str(ROOT / 'tools/async_fifo_cdc_top.sv')
        with (design_folder / 'runner.log').open('w') as stream:
            process = subprocess.run(command, cwd=ROOT, env=environment, stdout=stream, stderr=subprocess.STDOUT)
        matches = re.findall(r'^RESULTS: (.*results\.csv)$', (design_folder / 'runner.log').read_text(), re.M)
        if not matches:
            raise RuntimeError('Missing batch result CSV: ' + group + '/' + name)
        csvpath = Path(matches[-1])
        with csvpath.open() as stream:
            records = list(csv.DictReader(stream))
        (design_folder / 'batch.json').write_text(json.dumps({'argv': command, 'csv': str(csvpath.relative_to(ROOT)), 'width': width, 'models': models, 'cdc': cdc, 'EXPECTED_BMC': expected_bmc}, indent=2) + '\n')
        for result in records:
            task = result['task']
            expected = expected_bmc if task == 'bmc' else 'PASS'
            logpath = Path(result['log'])
            log = logpath.read_text()
            wrapper = logpath.with_suffix('.status').read_text()
            code = int(re.search(r'rc=(\d+)', wrapper).group(1))
            decoded = outcome(log, code)
            if task == 'cover' and decoded == 'PASS' and 'Unreached cover' in log:
                decoded = 'FAIL'
            assert decoded == result['status'], result
            failures = [line for line in log.splitlines() if 'summary:   failed assertion' in line]
            if expected == 'FAIL' and result['status'] == 'FAIL':
                assert failures and (logpath.parent / 'p2_bmc/engine_0/trace.vcd').is_file(), result
            harness = 'async_fifo_cdc_top.sv' if cdc else 'async_fifo_integrity_top.sv'
            record(dict(job=group + '/' + name + '/' + result['mode'] + '/' + task, phase=phase, design=name, clock_model=result['mode'], task=task, status=result['status'], expected=expected, engine=result['bmc_engine'] if task == 'bmc' else 'smtbmc z3', address_width=width, data_width=8, depth=result['depth'], scope='bounded', seconds=result['seconds'], source_sha256=source_digest(logpath.parent, ['async_fifo.sv', harness]), config_sha256=digest((logpath.parent / 'p2.sby').read_bytes()), log=str(logpath.relative_to(ROOT)), failure_summary=' | '.join(failures)))
        assert process.returncode == 0 and len(records) == len(models) * 2, group + '/' + name


def self_check():
    assert outcome('DONE (PASS, rc=0)', 0) == 'PASS'
    assert outcome('DONE (PASS, rc=0)', 16) == 'ERROR'
    assert outcome('DONE (PASS, rc=16)', 0) == 'ERROR'
    assert outcome('', 124) == 'TIMEOUT'
    assert outcome('DONE (UNKNOWN, rc=4)', 4) == 'UNKNOWN'
    assert outcome('DONE (FAIL, rc=2)', 2) == 'FAIL'
    original = 'module example #(parameter ADDR_WIDTH = 4, parameter DATA_WIDTH = 8); initial assert (4 == 4); endmodule\n'
    assert normalized(original, 2) == 'module example #(parameter ADDR_WIDTH = 2, parameter DATA_WIDTH = 8); initial assert (4 == 4); endmodule\n'
    print('Suite self-checks PASS: status/exit agreement, timeout distinction and parameter-only normalization.')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--stretch', action='store_true')
    arguments = parser.parse_args()
    if arguments.check:
        self_check()
        return
    assert not RUN.exists(), 'Existing run preserved; extract a fresh source copy to rerun.'
    source_identity = verify_sources()
    RUN.mkdir(parents=True)
    save()
    versions()
    (RUN / 'source_identity.txt').write_text(source_identity + '\n')
    rtl = (ROOT / 'async_fifo.sv').read_text(encoding='utf-8-sig')
    formal = (ROOT / 'verification/async_fifo_formal.sv').read_text()
    baseline = {'async_fifo.sv': rtl, 'async_fifo_formal.sv': formal}
    try:
        for model, expected in [('single', 'PASS'), ('multi', 'FAIL')]:
            direct('clock_canary_' + model, 'clock_canary', 'CANARY', model, 'bmc', 2, 10, {'clock_canary.sv': (ROOT / 'verification/clock_canary.sv').read_text()}, 'clock_canary', 'abc bmc3', expected)
        for width in [2, 3, 4, 5]:
            for model in ['single', 'multi']:
                for task in ['bmc', 'cover'] + (['prove'] if model == 'single' else []):
                    direct('phase1_w' + str(width) + '_' + model + '_' + task, 'phase1', 'CONTROL', model, task, width, 30, baseline, 'async_fifo', 'abc bmc3' if task == 'bmc' else 'smtbmc z3', 'PASS')
        for mutant in ['M1', 'M2', 'M3', 'M4', 'M5b']:
            sources = dict(baseline, **{'async_fifo.sv': (ROOT / 'mutants' / mutant / 'async_fifo.sv').read_text(encoding='utf-8-sig')})
            direct('phase1_mutant_' + mutant, 'phase1_matrix', mutant, 'multi', 'bmc', 2, 30, sources, 'async_fifo', 'abc bmc3', 'FAIL' if mutant == 'M4' else 'PASS')
        branch_sources = {'async_fifo.sv': rtl, 'async_fifo_formal.sv': (ROOT / 'verification/branch_checker.sv').read_text()}
        folder, _ = direct('reset_branch_covers', 'branch_audit', 'CONTROL', 'multi', 'cover', 2, 30, branch_sources, 'async_fifo', 'smtbmc z3', 'PASS')
        branch_log = (folder / 'run.log').read_text()
        for goal in ['wr_first_active_branch', 'rd_first_active_branch', 'wr_history_branch', 'rd_history_branch']:
            assert re.search(r'Reached cover statement in step \d+ at .*?u_formal\.' + goal, branch_log), goal
        integrity = (ROOT / 'mutants/control/async_fifo_integrity_top.sv').read_text()
        anchor = '  assign occ = wr_cnt - rd_cnt;\n'
        insertion = "\n  always_comb begin\n    initialized_full: cover (rst_n && wr_reset_done && rd_reset_done && occ == DEPTH && wr_full);\n  end\n"
        assert integrity.count(anchor) == 1
        instrumented = integrity.replace(anchor, anchor + insertion)
        assert instrumented.replace(insertion, '') == integrity
        for width in [2, 3]:
            folder, _ = direct('initialized_full_w' + str(width), 'initialized_fill', 'CONTROL', 'multi', 'cover', width, (1 << (width + 2)) + 12, {'async_fifo.sv': rtl, 'async_fifo_integrity_top.sv': instrumented}, 'async_fifo_integrity_top', 'smtbmc z3', 'PASS')
            assert 'initialized_full' in (folder / 'run.log').read_text()
        batch('phase2_w2', 'phase2', 2, ['single', 'multi'], ['CONTROL', 'M1', 'M2', 'M3', 'M4', 'M5b'])
        batch('phase2_w3', 'phase2', 3, ['multi'], ['CONTROL', 'M1', 'M2', 'M3', 'M4'])
        batch('cdc_w2', 'cdc', 2, ['single', 'multi'], ['CONTROL', 'M1', 'M2', 'M3', 'M4', 'M5b', 'M5b_rd2wr'], cdc=True)
        batch('cdc_w3', 'cdc', 3, ['multi'], ['CONTROL', 'M5b', 'M5b_rd2wr'], cdc=True)
        if arguments.stretch:
            direct('phase1_pdr_w2', 'phase1_stretch', 'CONTROL', 'multi', 'prove', 2, 30, baseline, 'async_fifo', 'abc pdr', 'PASS', timeout=120, optional=True)
        assert source_identity == verify_sources()
        save('CORE COMPLETE', 'Declared bounded core passed all expected outcomes. Optional stretch results are separate.')
        print('CORE COMPLETE; rows=' + str(len(ROWS)), flush=True)
    except BaseException as error:
        save('INCOMPLETE', str(error))
        raise


if __name__ == '__main__':
    main()
