"""Run one selected, budgeted proof/witness using preserved source inputs."""
import argparse
import importlib.util
from pathlib import Path
import sys

ROOT=Path(__file__).resolve().parents[1]

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('suite',choices=['phase1-pdr','integrity-pdr','observer','observer-cover','reset'])
    parser.add_argument('--width',type=int,choices=[2,3,4,5],default=2)
    parser.add_argument('--timeout',type=int,default=300)
    args=parser.parse_args()
    if not 1<=args.timeout<=3600:parser.error('--timeout must be 1..3600 seconds')
    if args.suite in ['observer-cover','reset'] and args.width!=2:parser.error('This reference/witness command uses --width 2')
    spec=importlib.util.spec_from_file_location('suite',ROOT/'tools/run_all.py')
    suite=importlib.util.module_from_spec(spec);spec.loader.exec_module(suite)
    suite.RUN=ROOT/'results'/f'{args.suite}_w{args.width}'
    assert not suite.RUN.exists(),'Existing evidence preserved; use a fresh source checkout to repeat.'
    identity=suite.verify_sources()
    suite.save();suite.versions()
    sources={'async_fifo.sv':(ROOT/'async_fifo.sv').read_text(encoding='utf-8-sig')}
    task='prove';model='multi';depth=30;engine='abc pdr'
    if args.suite=='phase1-pdr':
        sources['async_fifo_formal.sv']=(ROOT/'verification/async_fifo_formal.sv').read_text();top='async_fifo'
    elif args.suite=='reset':
        sources={'reset_sync_reference.sv':(ROOT/'verification/reset_sync_reference.sv').read_text()};top='reset_release_check'
    else:
        sources['async_fifo_integrity_top.sv']=(ROOT/'mutants/control/async_fifo_integrity_top.sv').read_text();top='async_fifo_integrity_top'
        if args.suite in ['observer','observer-cover']:
            sources['late_observer.sv']=(ROOT/'verification/late_observer.sv').read_text();top='late_observer_top'
        if args.suite=='observer-cover':
            sources['late_cover_driver.sv']=(ROOT/'verification/late_cover_driver.sv').read_text()
            top='late_cover_driver';task='cover';model='single';depth=48;engine='smtbmc z3'
    try:
        _,row=suite.direct(args.suite.replace('-','_')+'_w'+str(args.width),args.suite,'CONTROL',model,task,args.width,depth,
            sources,top,engine,'PASS',timeout=args.timeout,optional=True)
        if args.suite=='reset':
            row['address_width']=row['data_width']='N/A (reset reference)'
        assert identity==suite.verify_sources()
        suite.save('ATTEMPT COMPLETE', 'Check literal status and scope. Covers do not establish safety; reference reset is not full integration.')
        return 0 if row['status']=='PASS' else 1
    except BaseException as error:
        suite.save('INCOMPLETE',str(error));raise

if __name__=='__main__':sys.exit(main())
