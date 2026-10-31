import csv
import os
from pathlib import Path
import shutil
import signal
import subprocess
import tempfile
import time
import unittest


PROJECT = Path(__file__).resolve().parents[1]


class RunnerTests(unittest.TestCase):
    def setUp(self):
        (PROJECT / 'results').mkdir(exist_ok=True)
        self.workspace = tempfile.TemporaryDirectory(dir=PROJECT / 'results', prefix='runner_test_')
        self.addCleanup(self.workspace.cleanup)
        self.root = Path(self.workspace.name)
        (self.root / 'tools').mkdir()
        (self.root / 'bin').mkdir()
        shutil.copy2(PROJECT / 'tools/run_p2.sh', self.root / 'tools/run_p2.sh')
        shutil.copy2(PROJECT / 'run_quiet.sh', self.root / 'run_quiet.sh')
        self.rtl = self.root / 'input.sv'
        self.rtl.write_text('module async_fifo #(parameter DATA_WIDTH = 1, parameter ADDR_WIDTH = 2); endmodule\n')
        self.harness = self.root / 'integrity.sv'
        self.harness.write_text('module integrity #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4); initial assert (1); endmodule\n')
        solver = self.root / 'bin/sby'
        solver.write_text('''#!/usr/bin/env bash
task=${@: -1}
if [ -n "${MOCK_CALLS:-}" ]; then echo "$task" >> "$MOCK_CALLS"; fi
case "${MOCK_RESULT:-PASS}" in
  BLOCK) echo 'solver started'; sleep 10 ;;
  TIMEOUT) exit 124 ;;
  ERROR) echo 'DONE (ERROR, rc=16)'; exit 16 ;;
  CONTRADICT) echo 'DONE (PASS, rc=0)'; exit 16 ;;
  BAD_MARKER) echo 'DONE (PASS, rc=16)'; exit 0 ;;
  BMC_FAIL) if [ "$task" = bmc ]; then echo 'Assert failed in integrity: integrity.sv:1.1-1.10'; echo 'DONE (FAIL, rc=2)'; exit 2; fi ;;
  UNKNOWN) echo 'DONE (UNKNOWN, rc=4)'; exit 4 ;;
  FAIL) echo 'Assert failed in integrity: integrity.sv:1.1-1.10'; echo 'DONE (FAIL, rc=2)'; exit 2 ;;
  UNREACHED) if [ "$task" = cover ]; then echo 'Unreached cover statement at integrity.sv:1'; fi ;;
esac
echo 'DONE (PASS, rc=0)'
''')
        solver.chmod(0o755)
        clock = self.root / 'bin/date'
        clock.write_text('''#!/usr/bin/env bash
if [ "${1:-}" = '+%m%d_%H%M' ]; then echo 0101_0000; else /usr/bin/date "$@"; fi
''')
        clock.chmod(0o755)
        self.env = dict(os.environ, PATH=str(self.root / 'bin') + ':' + os.environ['PATH'],
                        W='3', MODES='multi', TMO='1', HARN=str(self.harness),
                        DATA_WIDTH='8', BMC_ENGINE='abc', EXPECTED_BMC='')

    def run_script(self, specification=None, **environment):
        return subprocess.run(['bash', str(self.root / 'tools/run_p2.sh'),
                               specification or 'CONTROL=' + str(self.rtl)],
                              cwd=self.root, env=dict(self.env, **environment),
                              capture_output=True, text=True, timeout=20)

    def results(self):
        files = list((self.root / 'results').glob('*/results.csv'))
        self.assertEqual(len(files), 1)
        with files[0].open() as stream:
            return files[0], list(csv.DictReader(stream))

    def test_repeated_runs_preserve_both_evidence_directories(self):
        self.assertEqual(self.run_script().returncode, 0)
        self.assertEqual(self.run_script().returncode, 0)
        self.assertEqual(len(list((self.root / 'results').glob('*/results.csv'))), 2)

    def test_invalid_mode_and_escaping_label_are_rejected(self):
        self.assertNotEqual(self.run_script(MODES='mutli').returncode, 0)
        self.assertNotEqual(self.run_script('../../ESCAPE=' + str(self.rtl)).returncode, 0)
        self.assertFalse((self.root / 'ESCAPE').exists())
        self.assertNotEqual(self.run_script(MODES='multi\nmutli').returncode, 0)

    def test_engine_trace_solver_and_data_width_are_explicit(self):
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        csvpath, rows = self.results()
        config = (csvpath.parent / 'CONTROL/multi/p2.sby').read_text()
        self.assertIn('bmc: abc bmc3', config)
        self.assertIn('bmc: aigsmt z3', config)
        self.assertNotIn('\naigsmt z3\n', config)
        self.assertIn('bmc: depth 44', config)
        copied = (csvpath.parent / 'CONTROL/multi/async_fifo.sv').read_text()
        self.assertIn('DATA_WIDTH = 8', copied)
        self.assertIn('ADDR_WIDTH = 3', copied)
        self.assertEqual([row['status'] for row in rows], ['PASS', 'PASS'])
        self.assertEqual(self.rtl.read_text().count('DATA_WIDTH = 1'), 1)

    def test_invalid_width_timeout_and_engine_are_rejected(self):
        for environment in [dict(W='0'), dict(W='3;touch BAD'), dict(TMO='0'),
                            dict(DATA_WIDTH='-1'), dict(BMC_ENGINE='abc\ncover: custom')]:
            with self.subTest(environment=environment):
                self.assertNotEqual(self.run_script(**environment).returncode, 0)
        self.assertFalse((self.root / 'BAD').exists())

    def test_missing_rtl_is_recorded_without_reusing_old_artifacts(self):
        result = self.run_script('MISSING=' + str(self.root / 'missing.sv'))
        self.assertNotEqual(result.returncode, 0)
        _, rows = self.results()
        self.assertEqual([row['status'] for row in rows], ['NOT_RUN'])

    def test_z3_backend_and_restricted_data_width_keep_both_clock_modes(self):
        result = self.run_script(BMC_ENGINE='z3', DATA_WIDTH='1', MODES='single multi')
        self.assertEqual(result.returncode, 0, result.stderr)
        csvpath, rows = self.results()
        self.assertEqual([row['mode'] for row in rows], ['single', 'single', 'multi', 'multi'])
        self.assertTrue(all(row['data_width'] == '1' for row in rows))
        for mode in ['single', 'multi']:
            config = (csvpath.parent / ('CONTROL/' + mode + '/p2.sby')).read_text()
            self.assertIn('bmc: smtbmc z3', config)
            self.assertIn('multiclock ' + ('on' if mode == 'multi' else 'off'), config)

    def test_interruption_records_unknown_for_the_active_task(self):
        process = subprocess.Popen(['bash', str(self.root / 'tools/run_p2.sh'),
                                    'CONTROL=' + str(self.rtl)], cwd=self.root,
                                   env=dict(self.env, MOCK_RESULT='BLOCK', TMO='15'),
                                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                                   start_new_session=True)
        try:
            deadline = time.monotonic() + 8
            while time.monotonic() < deadline:
                logs = list((self.root / 'results').glob('*/CONTROL/multi/bmc.log'))
                if logs and 'solver started' in logs[0].read_text():
                    break
                time.sleep(0.05)
            else:
                self.fail('solver did not start')
            os.killpg(process.pid, signal.SIGTERM)
            self.assertNotEqual(process.wait(timeout=5), 0)
            _, rows = self.results()
            self.assertEqual([row['status'] for row in rows], ['UNKNOWN'])
        finally:
            if process.poll() is None:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()

    def test_false_pass_is_rejected_when_exit_status_disagrees(self):
        self.run_script(MOCK_RESULT='CONTRADICT')
        _, rows = self.results()
        self.assertEqual([row['status'] for row in rows], ['ERROR', 'ERROR'])

    def test_false_pass_is_rejected_when_recorded_exit_disagrees(self):
        self.run_script(MOCK_RESULT='BAD_MARKER')
        _, rows = self.results()
        self.assertEqual([row['status'] for row in rows], ['ERROR', 'ERROR'])

    def test_strict_gate_stops_before_cover_after_unexpected_control_failure(self):
        calls = self.root / 'calls.txt'
        result = self.run_script(MOCK_RESULT='BMC_FAIL', EXPECTED_BMC='PASS', MOCK_CALLS=str(calls))
        self.assertNotEqual(result.returncode, 0)
        _, rows = self.results()
        self.assertEqual([(row['task'], row['status']) for row in rows], [('bmc', 'FAIL')])
        self.assertEqual(calls.read_text().splitlines(), ['bmc'])

    def test_strict_gate_accepts_expected_mutant_failure_and_runs_cover(self):
        result = self.run_script(MOCK_RESULT='BMC_FAIL', EXPECTED_BMC='FAIL')
        self.assertEqual(result.returncode, 0, result.stderr)
        _, rows = self.results()
        self.assertEqual([row['status'] for row in rows], ['FAIL', 'PASS'])

    def test_invalid_expected_status_is_rejected(self):
        self.assertNotEqual(self.run_script(EXPECTED_BMC='UNKNOWN').returncode, 0)

    def test_unreached_cover_is_failure_even_with_pass_marker(self):
        self.run_script(MOCK_RESULT='UNREACHED')
        _, rows = self.results()
        self.assertEqual([row['status'] for row in rows], ['PASS', 'FAIL'])

    def test_timeout_unknown_error_and_counterexample_stay_distinct(self):
        for status in ['TIMEOUT', 'UNKNOWN', 'ERROR', 'FAIL']:
            with self.subTest(status=status):
                self.run_script(MOCK_RESULT=status)
                files = sorted((self.root / 'results').glob('*/results.csv'), key=lambda path: path.stat().st_mtime_ns)
                with files[-1].open() as stream:
                    rows = list(csv.DictReader(stream))
                self.assertEqual([row['status'] for row in rows], [status, status])


if __name__ == '__main__':
    unittest.main(verbosity=2)
