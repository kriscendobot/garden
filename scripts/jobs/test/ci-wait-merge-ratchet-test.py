#!/usr/bin/env python3
"""Exercise delegated merge through the real spine and journal fetches, with fake GH."""
import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path

from ratchet_fixture import HEAD, metadata, policy, seed, write_json

JOBS = Path(__file__).resolve().parents[1]


class DelegatedMerge(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='.ratchet-test-', dir=Path.home())
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.journal = self.directory / 'seed'
        self.journal.mkdir()
        seed(self.journal)
        self.git('init', '-q', '-b', 'journal2')
        self.git('config', 'user.name', 'test')
        self.git('config', 'user.email', 'test@example.invalid')
        self.commit()
        self.remote = self.directory / 'journal.git'
        subprocess.run(['git', 'clone', '-q', '--bare', str(self.journal), str(self.remote)], check=True)
        self.git('remote', 'add', 'origin', str(self.remote))
        self.root = self.directory / 'root'
        self.root.mkdir()
        subprocess.run(['git', 'init', '-q', str(self.root)], check=True)
        self.environment = {key: value for key, value in os.environ.items()
                            if not key.startswith(('GARDEN_', 'JOURNAL_'))}
        self.environment.update(GARDEN_TEST='1', GARDEN_ROOT=str(self.root),
                                GARDEN_STATE=str(self.directory / 'state'), JOURNAL_REMOTE=str(self.remote),
                                JOURNAL_BRANCH='journal2', GARDEN_NO_MAINTAINER_ALERT='1',
                                GARDEN_GH=str(self.directory / 'gh'), GARDEN_REBASE_PR=str(self.directory / 'rebase'),
                                GARDEN_CI_POLL_SECS='0', GARDEN_CI_POLL_MAX_SECS='0',
                                GARDEN_CI_DEADLINE_SECS='1', RATCHET_FIXTURE=str(self.directory))
        self.information = metadata()
        self.configuration = dict(metadata=self.information, reviews=[], ci='SUCCESS', downstream='',
                                  head=HEAD, mode='normal')
        self.write_stub('gh', '''import json, os, sys
from pathlib import Path
root = Path(os.environ['RATCHET_FIXTURE'])
configuration = json.loads((root / 'configuration').read_text())
arguments = sys.argv[1:]
if arguments[0] == 'api':
    if configuration.get('unreadable_reviews'): sys.exit(1)
    print(json.dumps(configuration['reviews'])); sys.exit()
if arguments[1] == 'merge':
    with (root / 'merges').open('a') as log: log.write(' '.join(arguments) + '\\n')
    if configuration.get('merge_fail'):
        print('not mergeable; required status'); sys.exit(1)
    sys.exit()
if arguments[1] == 'list':
    print(configuration['downstream']); sys.exit()
columns = arguments[arguments.index('--json') + 1]
if columns == 'baseRefName,author,body,state,headRefOid,isDraft,reviewDecision':
    if configuration.get('unreadable_metadata'): sys.exit(1)
    print(json.dumps(configuration['metadata']))
elif columns == 'state,baseRefName,headRefName':
    print(json.dumps(dict(state='OPEN', baseRefName='llm', headRefName='crank')))
elif columns == 'state,mergeable,statusCheckRollup,reviewDecision,headRefOid':
    head = configuration['head']
    if configuration['mode'] == 'rebase' and (root / 'rebased').exists(): head = 'c'*40
    print(json.dumps(dict(state='OPEN', headRefOid=head, mergeable='MERGEABLE', reviewDecision='',
                         statusCheckRollup=[dict(status='COMPLETED', conclusion=configuration['ci'])])))
elif columns == 'reviewDecision': print(json.dumps(dict(reviewDecision='')))
elif columns == 'headRefName': print('crank')
elif columns == 'state,autoMergeRequest': print('MERGED|false')
else: sys.exit(1)
''')
        self.write_stub('rebase', '''import json, os, subprocess
from pathlib import Path
root = Path(os.environ['RATCHET_FIXTURE'])
configuration = json.loads((root / 'configuration').read_text())
count = int((root / 'count').read_text()) if (root / 'count').exists() else 0
(root / 'count').write_text(str(count + 1))
if configuration['mode'] == 'revoke' and count == 1:
    target = root / 'seed/config/delegations/ironhorse-test262-ratchet.revoked'
    target.write_text('revoked during CI')
    for arguments in (['add', '.'], ['commit', '-qm', 'revoke'], ['push', '-q', 'origin', 'journal2']):
        subprocess.run(['git', '-C', str(root / 'seed'), *arguments], check=True)
if configuration['mode'] == 'rebase' and count >= 1:
    (root / 'rebased').touch()
    print('c'*40)
else: print(configuration['head'])
''')

    def write_stub(self, name, body):
        path = self.directory / name
        path.write_text('#!/usr/bin/env python3\n' + body)
        path.chmod(0o755)

    def git(self, *arguments):
        return subprocess.run(['git', '-C', str(self.journal), *arguments], check=True, capture_output=True)

    def commit(self):
        self.git('add', '.')
        self.git('commit', '-qm', 'fixture')

    def publish(self):
        self.commit()
        self.git('push', '-q', 'origin', 'journal2')

    def run_merge(self, expected=1, repository=policy.REPOSITORY):
        write_json(self.directory / 'configuration', self.configuration)
        result = subprocess.run(['bash', str(JOBS / 'gardening/ci-wait-merge.sh'), repository, '17',
                                 '--ratchet-delegated-merge'], env=self.environment, capture_output=True, text=True)
        self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
        if expected != 0:
            self.assertFalse((self.directory / 'merges').exists(), result.stdout + result.stderr)
        return result

    def test_merge_without_maintainer_approval_retains_downstream(self):
        self.configuration['downstream'] = '18'
        self.run_merge(0)
        merge = (self.directory / 'merges').read_text()
        self.assertIn('--match-head-commit ' + HEAD, merge)
        self.assertNotIn('--delete-branch', merge)
        self.assertNotIn('--auto', merge)

    def test_unscoped_repository(self):
        self.run_merge(repository='endojs/endo')

    def test_wrong_author(self):
        self.information['author']['login'] = 'human'
        self.run_merge()

    def test_wrong_base(self):
        self.information['baseRefName'] = 'llm-deadbeef'
        self.run_merge()
        self.assertFalse((self.directory / 'count').exists())

    def test_missing_marker(self):
        self.information['body'] = ''
        self.run_merge()

    def test_missing_authorization(self):
        (self.journal / policy.AUTHORIZATION).unlink()
        self.publish()
        self.run_merge()

    def test_paused(self):
        path = self.journal / policy.CONFIGURATION
        record = json.loads(path.read_text()); record['status'] = 'paused'
        write_json(path, record); self.publish()
        self.run_merge()

    def test_revoked_during_wait(self):
        self.configuration['mode'] = 'revoke'
        self.run_merge()

    def test_missing_attestation(self):
        (self.journal / f'ratchets/{policy.IDENTITY}/attestations/17/{HEAD}.json').unlink()
        self.publish(); self.run_merge()

    def test_stale_attestation_after_rebase_restarts_ci(self):
        self.configuration['mode'] = 'rebase'
        result = self.run_merge()
        self.assertIn('invalidating prior green and re-waiting', result.stdout)
        self.assertGreaterEqual(int((self.directory / 'count').read_text()), 3)

    def test_red(self):
        self.configuration['ci'] = 'FAILURE'
        self.run_merge(3)

    def test_changes_requested_without_rollup(self):
        self.configuration['reviews'] = [dict(id=1, user={'login': 'kriskowal'}, state='CHANGES_REQUESTED')]
        self.run_merge()

    def test_dismissal(self):
        self.configuration['reviews'] = [dict(id=1, user={'login': 'kriskowal'}, state='DISMISSED')]
        self.run_merge()

    def test_dismissal_superseded_by_approval(self):
        self.configuration['reviews'] = [dict(id=1, user={'login': 'kriskowal'}, state='DISMISSED'),
                                         dict(id=2, user={'login': 'kriskowal'}, state='APPROVED')]
        self.run_merge(0)

    def test_unreadable_reviews(self):
        self.configuration['unreadable_reviews'] = True
        self.run_merge()

    def test_unreadable_metadata(self):
        self.configuration['unreadable_metadata'] = True
        self.run_merge()

    def test_evidence_tampered(self):
        path = self.journal / f'ratchets/{policy.IDENTITY}/attestations/17/{HEAD}/covered.gz'
        path.unlink(); self.publish(); self.run_merge()

    def test_no_auto_merge_fallback(self):
        self.configuration['merge_fail'] = True
        write_json(self.directory / 'configuration', self.configuration)
        result = subprocess.run(['bash', str(JOBS / 'gardening/ci-wait-merge.sh'), policy.REPOSITORY, '17',
                                 '--ratchet-delegated-merge'], env=self.environment, capture_output=True, text=True)
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        merge = (self.directory / 'merges').read_text()
        self.assertEqual(len(merge.splitlines()), 1)
        self.assertNotIn('--auto', merge)


if __name__ == '__main__':
    unittest.main()
