#!/usr/bin/env python3
"""The minion.town screener (proxy pre-pass 1d) and its operator command, end to end.

Real shell wrapper, real journal CAS pushes to a local bare remote, a fake gh, and
recording stand-ins for post-job.sh / post-gauntlet.sh that put the job on the board
so re-ticks exercise idempotence. designs/minion-town-pr-screening.md § Test plan.
"""
import datetime
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
import report  # noqa: E402

HEAD = 'a' * 40
OTHER = 'b' * 40
MERGE = 'c' * 40
PATCH = '@@ -1 +1 @@\n-old\n+new'


def stamp(minutes=0):
    moment = datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(minutes=minutes)
    return moment.strftime('%Y-%m-%dT%H:%M:%SZ')


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value))


GH = '''#!/usr/bin/env python3
import json, os, sys
from pathlib import Path
root = Path(os.environ['SCREEN_FIXTURE'])
c = json.loads((root / 'configuration').read_text())
a = sys.argv[1:]
with (root / 'gh-calls').open('a') as log: log.write(' '.join(a) + '\\n')
def out(value): print(json.dumps(value)); sys.exit()
if a[:2] == ['pr', 'list']: out(c['pulls'])
if a[:2] == ['pr', 'view']: out(c['views'][a[2]])
if a[:2] == ['run', 'list']:
    if '--commit' in a: out(c['commit_runs'].get(a[a.index('--commit') + 1], []))
    out(c['main_runs'])
if a[0] == 'api':
    path = [item for item in a[1:] if item.startswith('repos/')][0]
    if '-X' in a:
        with (root / 'review-requests').open('a') as log: log.write(path + '\\n')
        sys.exit()
    if '/reviews' in path: out([c['reviews']])
    if '/compare/' in path:
        head = path.rsplit('...', 1)[1]
        out(c['compare'].get(head, dict(merge_base_commit=dict(sha='d' * 40),
            files=[dict(filename='src/app.ts', status='modified', patch=c['patch'])])))
    if '/contents/' in path:
        ref = path.rsplit('ref=', 1)[1]
        print(c['contents'][ref]); sys.exit()
sys.exit(1)
'''

POST = '''#!/bin/bash
set -euo pipefail
base="$1"; [ "$base" = --by ] && { shift 2; base="$1"; }
echo "$(basename "$0") $base" >> "$SCREEN_FIXTURE/posts"
[ -f "${2:-}" ] && cp "$2" "$SCREEN_FIXTURE/body-$base"
seed="$SCREEN_FIXTURE/seed"
git -C "$seed" pull -q --rebase origin journal2
mkdir -p "$seed/jobs/todo"; echo "role: x" > "$seed/jobs/todo/$base.md"
git -C "$seed" add -A; git -C "$seed" commit -qm "post $base"; git -C "$seed" push -q origin journal2
'''


class Screening(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='.screen-test-', dir=Path.home())
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.journal = self.directory / 'seed'
        self.journal.mkdir()
        (self.journal / 'maintainers').mkdir()
        (self.journal / 'maintainers/allowlist').write_text('kriskowal\n')
        control.seed(self.journal)
        self.gauntlet(HEAD)
        self.git('init', '-q', '-b', 'journal2')
        self.git('config', 'user.name', 'test')
        self.git('config', 'user.email', 'test@example.invalid')
        self.commit()
        self.remote = self.directory / 'journal.git'
        subprocess.run(['git', 'clone', '-q', '--bare', str(self.journal), str(self.remote)], check=True)
        self.git('remote', 'add', 'origin', str(self.remote))
        self.git('fetch', '-q', 'origin')
        self.git('branch', '-q', '--set-upstream-to=origin/journal2')
        self.root = self.directory / 'root'
        self.root.mkdir()
        subprocess.run(['git', 'init', '-q', str(self.root)], check=True)
        for name, body in (('gh', GH), ('post-job', POST), ('post-gauntlet', POST)):
            path = self.directory / name
            path.write_text(body)
            path.chmod(0o755)
        self.heartbeat = self.directory / 'heartbeat.json'
        self.beat('ok')
        self.environment = {key: value for key, value in os.environ.items()
                            if not key.startswith(('GARDEN_', 'JOURNAL_'))}
        self.environment.update(
            GARDEN_TEST='1', GARDEN_ROOT=str(self.root), GARDEN_STATE=str(self.directory / 'state'),
            JOURNAL_REMOTE=str(self.remote), JOURNAL_BRANCH='journal2', GARDEN_NO_MAINTAINER_ALERT='1',
            GARDEN_GH=str(self.directory / 'gh'), GARDEN_SCREEN_HEARTBEAT=str(self.heartbeat),
            GARDEN_SCREEN_POST_JOB=str(self.directory / 'post-job'),
            GARDEN_SCREEN_POST_GAUNTLET=str(self.directory / 'post-gauntlet'),
            SCREEN_FIXTURE=str(self.directory))
        self.pull = dict(number=17, state='OPEN', isDraft=False, baseRefName='main',
                         author=dict(login='kriscendobot'), headRefOid=HEAD, reviewDecision='',
                         statusCheckRollup=[dict(name='test', status='COMPLETED', conclusion='SUCCESS')],
                         body='')
        self.configuration = dict(
            pulls=[self.pull], reviews=[], compare={}, contents={}, patch=PATCH, views={},
            commit_runs={}, main_runs=[dict(databaseId=9, status='completed', conclusion='success',
                                            headSha='e' * 40, url='https://run/9',
                                            createdAt=stamp(-60), updatedAt=stamp(-50))])

    # --- fixture helpers ---------------------------------------------------------
    def git(self, *arguments):
        return subprocess.run(['git', '-C', str(self.journal), *arguments], check=True, capture_output=True)

    def commit(self):
        self.git('add', '-A')
        self.git('commit', '-qm', 'fixture')

    def publish(self):
        self.commit()
        self.git('pull', '-q', '--rebase', 'origin', 'journal2')
        self.git('push', '-q', 'origin', 'journal2')

    def sync(self):
        self.git('pull', '-q', '--rebase', 'origin', 'journal2')

    def gauntlet(self, head, name='kriscendobot-minion-town-pr17-gauntlet'):
        path = self.journal / f'jobs/tada/2026/09/29/{name}.md'
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(f'gauntlet-status: complete\nrepo: {policy.REPOSITORY}\npr_number: 17\n'
                        f'panel_head: {head}\n# gauntlet {name} — complete\n')

    def beat(self, state, minutes=0):
        write_json(self.heartbeat, dict(at=stamp(minutes), state=state, host='h', detail='probe'))

    def delegation(self, **changes):
        path = self.journal / policy.CONFIGURATION
        value = json.loads(path.read_text())
        value.update(changes)
        write_json(path, value)

    def tick(self, expected=0):
        write_json(self.directory / 'configuration', self.configuration)
        result = subprocess.run(['bash', str(JOBS / 'screen-delegated-prs.sh')], env=self.environment,
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, expected, result.stdout + result.stderr)
        self.sync()
        return result

    def posts(self):
        path = self.directory / 'posts'
        return path.read_text().splitlines() if path.exists() else []

    def attested(self, head=HEAD):
        return (self.journal / policy.SCREENINGS / '17' / f'{head}.json').is_file()

    def refused(self):
        self.tick()
        self.assertFalse(self.attested())
        self.assertFalse(any('conduct' in post for post in self.posts()), self.posts())

    # --- delegation record ---------------------------------------------------------
    def test_missing_delegation_is_inert(self):
        (self.journal / policy.CONFIGURATION).unlink(); self.publish()
        self.refused()
        self.assertNotIn('pr list', (self.directory / 'gh-calls').read_text() if (self.directory / 'gh-calls').exists() else '')

    def test_digest_mismatch_denies(self):
        (self.journal / policy.AUTHORIZATION).write_text('tampered'); self.publish()
        self.refused()

    def test_revoked_denies(self):
        (self.journal / policy.TOMBSTONE).write_text('stop'); self.publish()
        self.refused()

    def test_paused_denies_ordinary_prs(self):
        self.delegation(status='paused', paused_by='maintainer', paused_at=stamp(-5)); self.publish()
        self.refused()

    # --- the screen -----------------------------------------------------------------
    def test_full_pass_attests_and_posts_one_conductor(self):
        self.tick()
        self.assertTrue(self.attested())
        record = json.loads((self.journal / policy.SCREENINGS / '17' / f'{HEAD}.json').read_text())
        self.assertEqual((record['panel_match'], record['deploy_run']), ('exact', 9))
        base = f'screen-minion-town-pr17-{HEAD[:7]}-conduct'
        self.assertEqual(self.posts(), [f'post-job {base}'])
        body = (self.directory / f'body-{base}').read_text()
        self.assertIn('--screened-delegated-merge', body)
        self.assertIn('role: conductor', body)
        self.tick()
        self.assertEqual(self.posts(), [f'post-job {base}'])

    def test_finished_conductor_is_retried_then_stalls_to_the_maintainer(self):
        base = f'screen-minion-town-pr17-{HEAD[:7]}-conduct'
        self.tick()
        for name in (base, f'{base}-r2', f'{base}-r3'):
            done = self.journal / f'jobs/tada/2026/09/30/{name}.md'
            done.parent.mkdir(parents=True, exist_ok=True)
            (self.journal / f'jobs/todo/{name}.md').rename(done)
            self.publish()
            self.tick()
        self.assertEqual(self.posts(), [f'post-job {base}', f'post-job {base}-r2', f'post-job {base}-r3'])
        notices = list((self.journal / 'inbox/maintainer/unread').glob('minion-town-pr-screening-stalled-*'))
        self.assertEqual(len(notices), 1)

    def test_rebase_equivalent_panel_head_passes(self):
        self.gauntlet(OTHER); (self.journal / 'jobs/tada/2026/09/29/kriscendobot-minion-town-pr17-gauntlet.md')
        self.pull['headRefOid'] = HEAD
        (self.journal / 'jobs/tada/2026/09/29/kriscendobot-minion-town-pr17-gauntlet.md').write_text(
            f'gauntlet-status: complete\nrepo: {policy.REPOSITORY}\npr_number: 17\npanel_head: {OTHER}\n')
        self.publish()
        self.configuration['compare'][OTHER] = dict(merge_base_commit=dict(sha='f' * 40), files=[
            dict(filename='src/app.ts', status='modified', patch='@@ -9 +9 @@\n-old\n+new')])
        self.tick()
        record = json.loads((self.journal / policy.SCREENINGS / '17' / f'{HEAD}.json').read_text())
        self.assertEqual(record['panel_match'], 'rebase')

    def test_stale_gauntlet_head_requests_a_gauntlet(self):
        (self.journal / 'jobs/tada/2026/09/29/kriscendobot-minion-town-pr17-gauntlet.md').write_text(
            f'gauntlet-status: complete\nrepo: {policy.REPOSITORY}\npr_number: 17\npanel_head: {OTHER}\n')
        self.publish()
        self.configuration['compare'][OTHER] = dict(files=[
            dict(filename='src/app.ts', status='modified', patch='@@ -1 +1 @@\n-old\n+other')])
        self.refused()
        gauntlet = f'post-gauntlet kriscendobot-minion-town-pr17-screen-{HEAD[:8]}-gauntlet'
        self.assertEqual(self.posts(), [gauntlet])
        self.tick()
        self.assertEqual(self.posts(), [gauntlet])

    def test_gauntlet_in_flight_waits(self):
        (self.journal / 'jobs/tada/2026/09/29/kriscendobot-minion-town-pr17-gauntlet.md').unlink()
        record = self.journal / 'jobs/gauntlet/kriscendobot-minion-town-pr17-gauntlet-x.md'
        record.parent.mkdir(parents=True)
        record.write_text(f'---\nrepo: {policy.REPOSITORY}\npr_number: 17\nstage: panel\n---\n')
        self.publish()
        self.refused()
        self.assertEqual(self.posts(), [])

    def test_scope_refusals(self):
        for key, value in (('author', dict(login='someone')), ('baseRefName', 'develop'), ('isDraft', True)):
            with self.subTest(key=key):
                original = self.pull[key]
                self.pull[key] = value
                self.refused()
                self.pull[key] = original

    def test_ci_refusals(self):
        for rollup in ([], [dict(status='IN_PROGRESS')], [dict(status='COMPLETED', conclusion='FAILURE')]):
            with self.subTest(rollup=rollup):
                self.pull['statusCheckRollup'] = rollup
                self.refused()

    def test_human_changes_requested(self):
        self.configuration['reviews'] = [dict(id=1, state='CHANGES_REQUESTED', user=dict(login='dckc', type='User'))]
        self.refused()

    def test_bot_changes_requested_is_not_a_veto(self):
        self.configuration['reviews'] = [dict(id=1, state='CHANGES_REQUESTED', user=dict(login='kriscendobot', type='User'))]
        self.tick()
        self.assertTrue(self.attested())

    def test_production_baseline_refusals(self):
        cases = (('red deploy', lambda: self.configuration['main_runs'][0].update(conclusion='failure')),
                 ('watchdog down', lambda: self.beat('down')),
                 ('watchdog stale', lambda: self.beat('ok', -45)))
        for name, change in cases:
            with self.subTest(name=name):
                self.configuration['main_runs'][0]['conclusion'] = 'success'
                self.beat('ok')
                change()
                self.refused()

    def test_escalated_path_notifies_once_and_requests_review(self):
        self.configuration['compare'][HEAD] = dict(files=[
            dict(filename='deploy/aws/scripts/deploy-cognito-github-idp.sh', status='modified', patch=PATCH)])
        self.refused()
        self.refused()
        notices = list((self.journal / 'inbox/maintainer/unread').glob('minion-town-pr-screening-escalated-*'))
        self.assertEqual(len(notices), 1)
        self.assertIn('from: proxy:screen', notices[0].read_text())
        self.assertEqual((self.directory / 'review-requests').read_text().count('\n'), 1)

    def test_ci_deploy_script_is_not_escalated(self):
        self.configuration['compare'][HEAD] = dict(files=[
            dict(filename='deploy/aws/scripts/deploy-app.sh', status='modified', patch=PATCH)])
        self.tick()
        self.assertTrue(self.attested())

    def test_deployment_section_escalates_only_inside_the_section(self):
        text = '# Deploy\n' + 'x\n' * 10 + '## Continuous deployment (GitHub Actions)\nrule\nrule\n## Later\ny\n'
        self.configuration['contents'] = {'d' * 40: text, HEAD: text}
        for hunk, escalates in (('@@ -3 +3 @@\n-x\n+z', False), ('@@ -13 +13 @@\n-rule\n+ruled', True)):
            with self.subTest(escalates=escalates):
                self.configuration['compare'][HEAD] = dict(merge_base_commit=dict(sha='d' * 40), files=[
                    dict(filename='DEPLOYMENT.md', status='modified', patch=hunk)])
                self.tick()
                self.assertEqual(self.attested(), not escalates)
                self.git('rm', '-rq', policy.SCREENINGS); self.publish()

    # --- post-merge validation --------------------------------------------------------
    def merged(self, conclusion):
        self.tick()
        self.configuration['pulls'] = []
        self.configuration['views']['17'] = dict(state='MERGED', headRefOid=HEAD,
                                                 mergeCommit=dict(oid=MERGE), mergedAt=stamp(-5))
        self.configuration['commit_runs'][MERGE] = [dict(databaseId=10, status='completed', conclusion=conclusion,
                                                         url='https://run/10', createdAt=stamp(-4), updatedAt=stamp(-2))]

    def test_failed_deploy_pauses_heals_and_notifies_once(self):
        self.merged('failure')
        self.tick(); self.tick()
        value = json.loads((self.journal / policy.CONFIGURATION).read_text())
        self.assertEqual((value['status'], value['paused_by'], value['healing']), ('paused', 'proxy:screen', [MERGE]))
        self.assertEqual([post for post in self.posts() if 'heal' in post], [f'post-job heal-minion-town-{MERGE[:7]}'])
        self.assertIn(f'<!-- garden-heal: {MERGE} -->', (self.directory / f'body-heal-minion-town-{MERGE[:7]}').read_text())
        notices = list((self.journal / 'inbox/maintainer/unread').glob('minion-town-pr-screening-paused-*'))
        self.assertEqual(len(notices), 1)
        record = json.loads((self.journal / policy.SCREENINGS / '17' / f'{HEAD}.json').read_text())
        self.assertEqual((record['deploy'], record['outcome']), ('failure', 'failed'))
        self.assertIn('paused', subprocess.run(['python3', str(JOBS / 'screening/report.py'), 'section',
                                                str(self.journal)], capture_output=True, text=True).stdout)

    def test_green_deploy_and_healthy_watchdog_validates(self):
        self.merged('success')
        self.tick()
        record = json.loads((self.journal / policy.SCREENINGS / '17' / f'{HEAD}.json').read_text())
        self.assertEqual((record['deploy'], record['health'], record['outcome']), ('success', 'ok', 'validated'))
        self.assertEqual(json.loads((self.journal / policy.CONFIGURATION).read_text())['status'], 'active')

    def test_watchdog_down_after_deploy_pauses(self):
        self.merged('success')
        self.beat('down')
        self.tick()
        self.assertEqual(json.loads((self.journal / policy.CONFIGURATION).read_text())['status'], 'paused')

    def test_auto_resume_only_for_a_screener_pause(self):
        for paused_by, expected in (('proxy:screen', 'active'), ('maintainer', 'paused')):
            with self.subTest(paused_by=paused_by):
                self.delegation(status='paused', paused_by=paused_by, paused_at=stamp(-120), paused_reason='x')
                self.publish()
                self.configuration['pulls'] = []
                self.tick()
                self.assertEqual(json.loads((self.journal / policy.CONFIGURATION).read_text())['status'], expected)

    def test_marked_heal_pr_screens_while_paused_despite_red_production(self):
        self.delegation(status='paused', paused_by='proxy:screen', paused_at=stamp(-5), healing=[MERGE])
        self.publish()
        self.configuration['main_runs'][0].update(conclusion='failure')
        self.beat('down')
        self.pull['body'] = f'fix\n<!-- garden-heal: {MERGE} -->\n'
        self.tick()
        record = json.loads((self.journal / policy.SCREENINGS / '17' / f'{HEAD}.json').read_text())
        self.assertEqual(record['heal'], MERGE)

    # --- operator command and bulletin ------------------------------------------------
    def test_operator_command_round_trip(self):
        (self.journal / policy.CONFIGURATION).unlink(); (self.journal / policy.AUTHORIZATION).unlink()
        self.publish()
        run = lambda *arguments: subprocess.run(['bash', str(JOBS / 'minion-town-screening.sh'), *arguments],
                                                env=self.environment, capture_output=True, text=True)
        self.assertIn('denied', run('status').stdout)
        self.assertEqual(run('seed').returncode, 0)
        self.sync()
        self.assertEqual(policy.status(self.journal), 'active')
        self.assertEqual(run('pause').returncode, 0); self.sync()
        self.assertEqual(json.loads((self.journal / policy.CONFIGURATION).read_text())['paused_by'], 'maintainer')
        self.assertEqual(run('resume').returncode, 0); self.sync()
        self.assertEqual(policy.status(self.journal), 'active')
        self.assertNotEqual(run('revoke').returncode, 0)
        reason = self.directory / 'reason'; reason.write_text('done here')
        self.assertEqual(run('revoke', str(reason)).returncode, 0); self.sync()
        self.assertTrue(policy.status(self.journal).startswith('denied'))
        self.assertNotEqual(run('seed').returncode, 0)

    def test_bulletin_parked_filter_and_section(self):
        rows = [f'{policy.REPOSITORY}\t17\turl\tt\ttitle\n', f'{policy.REPOSITORY}\t18\turl\tt\ttitle\n',
                'endojs/endo-but-for-bots\t5\turl\tt\ttitle\n']
        write_json(self.journal / policy.SCREENINGS / '18' / f'escalated-{HEAD}.json',
                   dict(pull_request=18, head=HEAD, paths=['.github/workflows/test.yml'], at=stamp()))
        result = subprocess.run(['python3', str(JOBS / 'screening/report.py'), 'parked-filter', str(self.journal)],
                                input=''.join(rows), capture_output=True, text=True, check=True)
        self.assertEqual(result.stdout, rows[1] + rows[2])
        section = subprocess.run(['python3', str(JOBS / 'screening/report.py'), 'section', str(self.journal)],
                                 capture_output=True, text=True, check=True).stdout
        self.assertIn('Delegation: **active**', section)
        self.assertIn('**escalated**', section)
        (self.journal / policy.CONFIGURATION).unlink()
        result = subprocess.run(['python3', str(JOBS / 'screening/report.py'), 'parked-filter', str(self.journal)],
                                input=''.join(rows), capture_output=True, text=True, check=True)
        self.assertEqual(result.stdout, ''.join(rows))


if __name__ == '__main__':
    unittest.main()
