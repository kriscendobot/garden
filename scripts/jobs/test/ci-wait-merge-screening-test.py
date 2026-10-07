#!/usr/bin/env python3
"""--screened-delegated-merge through the real spine and journal fetches, with fake GH.

designs/minion-town-pr-screening.md § Test plan: the delegation must be seeded and
active (or paused with a marked heal PR), the post-rebase head must carry the proxy's
screening attestation, a human CHANGES_REQUESTED blocks, and the merge never queues
--auto. The ordinary path still demands maintainer approval.
"""
import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

JOBS = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(JOBS / 'screening'))
import control  # noqa: E402
import policy  # noqa: E402

HEAD = 'a' * 40
HEAL = 'c' * 40


def write_json(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(content))


class ScreenedMerge(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='.screened-merge-test-', dir=Path.home())
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.journal = self.directory / 'seed'
        self.journal.mkdir()
        (self.journal / 'maintainers').mkdir()
        (self.journal / 'maintainers/allowlist').write_text('kriskowal\n')
        control.seed(self.journal)
        write_json(policy.attestation_path(self.journal, 17, HEAD),
                   dict(schema=2, repository=policy.REPOSITORY, pull_request=17, head=HEAD,
                        base='main', heal=None))
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
        self.information = dict(baseRefName='main', author={'login': 'kriscendobot'}, body='',
                                state='OPEN', headRefOid=HEAD, isDraft=False, reviewDecision='')
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
if arguments[1] == 'edit':
    (root / 'unfrozen').touch(); sys.exit()
if arguments[1] == 'list':
    print(configuration['downstream']); sys.exit()
columns = arguments[arguments.index('--json') + 1]
if columns == 'baseRefName,author,body,state,headRefOid,isDraft,reviewDecision':
    if configuration.get('unreadable_metadata'): sys.exit(1)
    metadata = dict(configuration['metadata'])
    if (root / 'unfrozen').exists(): metadata['baseRefName'] = 'main'
    print(json.dumps(metadata))
elif columns == 'state,baseRefName,headRefName':
    base = 'main' if (root / 'unfrozen').exists() else configuration['metadata']['baseRefName']
    print(json.dumps(dict(state='OPEN', baseRefName=base, headRefName='crank')))
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
    target = root / 'seed/config/delegations/minion-town-pr-screening.revoked'
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
        self.git('add', '-A')
        self.git('commit', '-qm', 'fixture')

    def publish(self):
        self.commit()
        self.git('push', '-q', 'origin', 'journal2')

    def delegation(self, **changes):
        path = self.journal / policy.CONFIGURATION
        value = json.loads(path.read_text()); value.update(changes)
        write_json(path, value)

    def run_merge(self, expected=1, repository=policy.REPOSITORY, flag='--screened-delegated-merge'):
        write_json(self.directory / 'configuration', self.configuration)
        result = subprocess.run(['bash', str(JOBS / 'gardening/ci-wait-merge.sh'), repository, '17', flag],
                                env=self.environment, capture_output=True, text=True)
        self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
        if expected != 0:
            self.assertFalse((self.directory / 'merges').exists(), result.stdout + result.stderr)
        return result

    def test_attested_head_merges_without_approval(self):
        result = self.run_merge(0)
        self.assertIn('mode=screened-delegated-merge', result.stdout)
        merge = (self.directory / 'merges').read_text()
        self.assertIn('--match-head-commit ' + HEAD, merge)
        self.assertNotIn('--auto', merge)

    def test_ordinary_merge_still_needs_approval(self):
        self.run_merge(flag='--merge')

    def test_outside_repository(self):
        result = self.run_merge(repository='endojs/endo-but-for-bots')
        self.assertIn('outside screening delegation', result.stdout)
        self.assertFalse((self.directory / 'count').exists())

    def test_wrong_author_or_stacked_base(self):
        for key, value in (('author', {'login': 'someone'}), ('baseRefName', 'parent-feature')):
            with self.subTest(key=key):
                original = self.information[key]; self.information[key] = value
                self.run_merge()
                self.information[key] = original

    def test_frozen_main_base_is_unfrozen_and_merges(self):
        self.information['baseRefName'] = 'main-1234abcd'
        self.run_merge(0)
        self.assertTrue((self.directory / 'unfrozen').exists())

    def test_draft_or_probe_is_never_mutated(self):
        for key, value in (('isDraft', True), ('body', 'gap-revealing prototype')):
            with self.subTest(key=key):
                original = self.information[key]; self.information[key] = value
                self.run_merge()
                self.assertFalse((self.directory / 'count').exists())
                self.information[key] = original

    def test_missing_delegation(self):
        (self.journal / policy.CONFIGURATION).unlink(); self.publish()
        self.run_merge()

    def test_digest_mismatch(self):
        (self.journal / policy.AUTHORIZATION).write_text('tampered'); self.publish()
        self.run_merge()

    def test_old_delegation_schema_does_not_gain_new_scope(self):
        self.delegation(schema=1); self.publish()
        self.run_merge()

    def test_paused(self):
        self.delegation(status='paused', paused_by='maintainer'); self.publish()
        self.run_merge()

    def test_paused_heal_pr_merges(self):
        self.delegation(status='paused', paused_by='proxy:screen', healing=[HEAL])
        write_json(policy.attestation_path(self.journal, 17, HEAD),
                   dict(schema=2, repository=policy.REPOSITORY, pull_request=17, head=HEAD,
                        base='main', heal=HEAL))
        self.publish()
        self.information['body'] = f'revert\n<!-- garden-heal: {HEAL} -->\n'
        self.run_merge(0)

    def test_revoked_during_wait(self):
        self.configuration['mode'] = 'revoke'
        self.run_merge()

    def test_missing_attestation(self):
        policy.attestation_path(self.journal, 17, HEAD).unlink(); self.publish()
        result = self.run_merge()
        self.assertIn('awaiting re-screen', result.stdout + result.stderr)

    def test_rebased_head_awaits_re_screen(self):
        self.configuration['mode'] = 'rebase'
        self.run_merge()

    def test_human_changes_requested(self):
        self.configuration['reviews'] = [dict(id=1, user={'login': 'dckc', 'type': 'User'}, state='CHANGES_REQUESTED')]
        self.run_merge()

    def test_no_auto_merge_fallback(self):
        self.configuration['merge_fail'] = True
        write_json(self.directory / 'configuration', self.configuration)
        result = subprocess.run(['bash', str(JOBS / 'gardening/ci-wait-merge.sh'), policy.REPOSITORY, '17',
                                 '--screened-delegated-merge'], env=self.environment, capture_output=True, text=True)
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        merge = (self.directory / 'merges').read_text()
        self.assertEqual(len(merge.splitlines()), 1)
        self.assertNotIn('--auto', merge)


if __name__ == '__main__':
    unittest.main()
