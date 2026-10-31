import importlib.util
import os
from pathlib import Path
import shutil
from unittest.mock import patch
import unittest

import test_run_p2


class SuiteGateTests(test_run_p2.RunnerTests):
    def test_optional_cover_is_bounded_reachability(self):
        source = Path(__file__).resolve().with_name('run_all.py')
        spec = importlib.util.spec_from_file_location('suite_cover_scope', source)
        suite = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(suite)
        suite.ROOT = self.root
        suite.RUN = self.root / 'results/cover_scope'
        suite.ROWS = []
        with patch.dict(os.environ, self.env):
            _, row = suite.direct('cover_scope', 'diagnostic', 'CONTROL', 'multi',
                'cover', 2, 10, {'top.sv': 'module top; initial cover (1); endmodule\n'},
                'top', 'smtbmc z3', 'PASS', timeout=10, optional=True)
        self.assertEqual(row['scope'], 'bounded reachability')
        self.assertEqual(suite.ROWS[0]['task'], 'cover')

    def test_batch_stops_before_later_designs_after_control_failure(self):
        source = Path(__file__).resolve().with_name('run_all.py')
        specification = importlib.util.spec_from_file_location('suite_under_test', source)
        suite = importlib.util.module_from_spec(specification)
        specification.loader.exec_module(suite)
        suite.ROOT = self.root
        suite.RUN = self.root / 'results/suite'
        suite.RUN.mkdir(parents=True)
        suite.ROWS = []
        shutil.copy2(self.rtl, self.root / 'async_fifo.sv')
        for design in ['control', 'M1']:
            (self.root / 'mutants' / design).mkdir(parents=True)
        shutil.copy2(self.harness, self.root / 'mutants/control/async_fifo_integrity_top.sv')
        shutil.copy2(self.rtl, self.root / 'mutants/M1/async_fifo.sv')
        calls = self.root / 'calls.txt'
        with patch.dict(os.environ, dict(self.env, MOCK_RESULT='BMC_FAIL', MOCK_CALLS=str(calls))):
            with self.assertRaisesRegex(RuntimeError, 'Core gate unresolved'):
                suite.batch('group', 'phase2', 3, ['multi'], ['CONTROL', 'M1'])
        self.assertEqual(calls.read_text().splitlines(), ['bmc'])
        self.assertEqual(len(suite.ROWS), 1)
        self.assertEqual(suite.ROWS[0]['design'], 'CONTROL')
        self.assertEqual(suite.ROWS[0]['status'], 'FAIL')


if __name__ == '__main__':
    unittest.main(verbosity=2)
