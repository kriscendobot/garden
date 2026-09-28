#!/usr/bin/env python3
"""Real Git floor/diff tests against complete sweep and LCOV fixtures."""
import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from ratchet_fixture import WATCHER, metadata, policy, seed, write_json
import evidence
import driver


class Evidence(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='ratchet-evidence-')
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.worktree = self.directory / 'project'
        self.worktree.mkdir()
        self.git('init', '-q')
        self.git('config', 'user.name', 'test')
        self.git('config', 'user.email', 'test@example.invalid')
        self.floor_path = 'rust/engine/ironhorse-262/baseline/refresh-20260904/covered.txt'
        floor = self.worktree / self.floor_path
        floor.parent.mkdir(parents=True); floor.write_text('a\nb\n')
        source = self.worktree / 'lib.rs'
        source.write_text('pub fn answer() -> u8 { 0 }\n')
        for path in ('scripts/full-run.sh', 'src/bin/endot_ih.rs', 'src/report.rs', 'src/xst.rs'):
            classifier = self.worktree / 'rust/engine/ironhorse-262' / path
            classifier.parent.mkdir(parents=True, exist_ok=True)
            classifier.write_text('// stable classifier fixture\n')
        self.commit(); self.base = self.git('rev-parse', 'HEAD').strip()
        source.write_text('pub fn answer() -> u8 { 1 }\n')
        self.refreshed = 'rust/engine/ironhorse-262/baseline/refresh-20260928/covered.txt'
        refreshed = self.worktree / self.refreshed
        refreshed.parent.mkdir(parents=True); refreshed.write_text('a\nb\nc\n')
        self.commit(); self.head = self.git('rev-parse', 'HEAD').strip()
        self.before = self.report(self.base, ('a', 'b'))
        self.after = self.report(self.head, ('a', 'b', 'c'))
        write_json(self.directory / 'before.json', self.before)
        write_json(self.directory / 'after.json', self.after)
        (self.directory / 'lcov').write_text('SF:lib.rs\nDA:1,1\nend_of_record\n')
        (self.directory / 'log').write_text('tests passed\n')
        self.journal = self.directory / 'journal'
        self.journal.mkdir()
        self.gauntlet = 'ironhorse-ratchet-pr17-gauntlet-20260928'
        terminal = self.journal / f'jobs/tada/2026/09/28/{self.gauntlet}.md'
        terminal.parent.mkdir(parents=True); terminal.write_text('gauntlet-status: complete\n')
        panel = self.journal / 'panel-runs/endojs-endo-but-for-bots-17/latest.md'
        panel.parent.mkdir(parents=True)
        panel.write_text(f'---\nreviewed_head: {self.head}\ndisposition: passed\n---\n')
        self.state = dict(branch_point=self.base, corpus='b'*40, gauntlet=self.gauntlet,
                          floor=dict(revision=self.base, path=self.floor_path,
                                     sha256=policy.digest(b'a\nb\n')))
        gate = Path(__file__).resolve().parents[1] / 'ironhorse-test262-ratchet-gate.sh'
        pinned = self.directory / 'pin'
        subprocess.run([str(gate), 'pin', '--from-report', str(self.directory / 'before.json'),
                        '--project-git', str(self.worktree), '--out', str(pinned)],
                       check=True, capture_output=True)
        self.state['floor']['pin'] = json.loads((pinned / 'pin.json').read_text())
        self.manifest = dict(worktree=str(self.worktree), before_report=str(self.directory / 'before.json'),
                             after_report=str(self.directory / 'after.json'), covered=str(refreshed),
                             refreshed_floor=self.refreshed, gauntlet_report=str(terminal.relative_to(self.journal)),
                             panel_report=str(panel.relative_to(self.journal)),
                             dual_run=dict(head=self.head, exit_code=0, command='oracle-test', log=str(self.directory / 'log')),
                             new_code=dict(head=self.head, exit_code=0, command='coverage-test',
                                           test_log=str(self.directory / 'log'), lcov=str(self.directory / 'lcov')))

    def git(self, *arguments):
        return subprocess.check_output(['git', '-C', str(self.worktree), *arguments], text=True)

    def commit(self):
        self.git('add', '.'); self.git('commit', '-qm', 'fixture')

    def report(self, head, covered):
        cases = [dict(path=path, category='covered' if path in covered else 'unsupported',
                      outcome='covered' if path in covered else 'skip',
                      reason='' if path in covered else 'ironhorse-aborted:cluster') for path in ('a', 'b', 'c')]
        return dict(schema='ironhorse-test262-report/1', provenance=dict(endo_sha=head, scope='whole-corpus', completion='complete', corpus_verified=True,
                                    oracle_mode='on', ses_mode='none', test262_sha='b'*40, oracle='xs@pin', runner='endot-ih',
                                    run_id=f'test262={"b"*40};endo={head};moddable={"c"*40};oracle=on;ses=none;cap=100;scope=<all>'),
                    summary=dict(total=3, by_category=dict(covered=len(covered), unsupported=3-len(covered))), cases=cases)

    def verify(self):
        write_json(self.directory / 'before.json', self.before)
        write_json(self.directory / 'after.json', self.after)
        return evidence.verify(self.manifest, self.state, self.journal, self.head, 17)

    def test_derives_growth_from_cases_and_real_git_floor(self):
        result = self.verify()
        self.assertEqual((result['gained'], result['lost'], result['measured_new_lines']), (1, 0, 1))
        self.assertEqual(result['next_floor']['revision'], self.head)

    def test_successful_attestation_archives_verifiable_evidence(self):
        seed(self.journal)
        for arguments in (['init', '-q'], ['config', 'user.name', 'test'],
                          ['config', 'user.email', 'test@example.invalid'], ['add', '.'], ['commit', '-qm', 'fixture']):
            subprocess.run(['git', '-C', str(self.journal), *arguments], check=True, capture_output=True)
        state = dict(self.state, pull_request=17, head=self.head, gauntlet_head=self.head)
        information = metadata(); information['headRefOid'] = self.head
        manifest_path = self.directory / 'manifest.json'; write_json(manifest_path, self.manifest)
        with patch.object(driver, 'JOURNAL', self.journal), patch.object(driver, 'WATCHER', WATCHER), \
             patch.object(driver, 'metadata', return_value=information), \
             patch.object(driver, 'github', return_value=[[]]), patch.dict(os.environ, GARDEN_JOB_MODEL='gpt-6-astra'):
            result = driver.attest(state, manifest_path)
        self.assertEqual(result['action'], 'attested')
        receipt = policy.attestation(self.journal, 17, self.head)
        self.assertEqual(receipt['gained'], 1)
        self.assertEqual(receipt['comparisons'][0]['verdict'], 'pass')
        archived = self.journal / f'ratchets/{policy.IDENTITY}/attestations/17/{self.head}/after_report.gz'
        self.assertEqual(policy.gzip.decompress(archived.read_bytes()), (self.directory / 'after.json').read_bytes())

    def test_historical_loss_not_hidden_by_lower_branch_point(self):
        self.before = self.report(self.base, ('a',))
        self.after = self.report(self.head, ('a', 'c'))
        with self.assertRaisesRegex(ValueError, 'comparison fail'):
            self.verify()

    def test_branch_point_growth_also_enforced(self):
        self.before = self.report(self.base, ('a', 'b', 'c'))
        with self.assertRaisesRegex(ValueError, 'comparison fail'):
            self.verify()

    def test_stale_head_report(self):
        self.after['provenance']['endo_sha'] = self.base
        with self.assertRaisesRegex(ValueError, 'required head'):
            self.verify()

    def test_partial_or_oracle_off_never_attests(self):
        for field, value in (('scope', 'subtree=Array'), ('completion', 'incomplete'), ('oracle_mode', 'off')):
            with self.subTest(field=field):
                old = self.after['provenance'][field]
                self.after['provenance'][field] = value
                with self.assertRaises(ValueError): self.verify()
                self.after['provenance'][field] = old

    def test_fabricated_summary_rejected(self):
        self.after['summary']['by_category']['covered'] = 4
        with self.assertRaisesRegex(ValueError, 'totals mismatch'): self.verify()

    def test_missing_case_rejected(self):
        self.after['cases'].pop()
        with self.assertRaisesRegex(ValueError, 'total mismatch'): self.verify()

    def test_corpus_pin_change_rejected(self):
        self.after['provenance']['test262_sha'] = 'c'*40
        self.before['provenance']['test262_sha'] = 'c'*40
        with self.assertRaisesRegex(ValueError, 'enforced pin'): self.verify()

    def test_run_parameter_change_is_incompatible_with_enforced_floor(self):
        self.before['provenance']['run_id'] += ';case-timeout=10'
        self.after['provenance']['run_id'] += ';case-timeout=10'
        with self.assertRaisesRegex(ValueError, 'comparison incompatible'):
            self.verify()

    def test_uncovered_new_code_rejected(self):
        (self.directory / 'lcov').write_text('SF:lib.rs\nDA:1,0\n')
        with self.assertRaisesRegex(ValueError, 'new code not covered'): self.verify()

    def test_cannot_exclude_instrumented_executable_line(self):
        self.manifest['new_code']['non_executable'] = [dict(path='lib.rs', line=1, reason='trust me')]
        with self.assertRaisesRegex(ValueError, 'executable line cannot be excluded'): self.verify()

    def test_stale_new_code_and_dual_run_evidence(self):
        for field in ('new_code', 'dual_run'):
            with self.subTest(field=field):
                self.manifest[field]['head'] = self.base
                with self.assertRaises(ValueError): self.verify()
                self.manifest[field]['head'] = self.head

    def test_panel_must_pass_at_exact_head(self):
        path = self.journal / self.manifest['panel_report']
        path.write_text(f'disposition: must-fix\nreviewed_head: {self.head}\n')
        with self.assertRaisesRegex(ValueError, 'panel is stale or'): self.verify()

    def test_gauntlet_review_budget_is_not_complete(self):
        (self.journal / self.manifest['gauntlet_report']).write_text('gauntlet-status: review-budget-reached\n')
        with self.assertRaisesRegex(ValueError, 'gauntlet not complete'): self.verify()

    def test_floor_cannot_be_overwritten(self):
        self.state['floor']['sha256'] = '0'*64
        with self.assertRaisesRegex(ValueError, 'enforced floor changed'): self.verify()

    def test_forged_covered_file(self):
        forged = self.directory / 'covered.txt'; forged.write_text('c\nb\na\n')
        self.manifest['covered'] = str(forged)
        with self.assertRaisesRegex(ValueError, 'report-derived set'): self.verify()


if __name__ == '__main__':
    unittest.main()
