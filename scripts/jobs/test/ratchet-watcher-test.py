#!/usr/bin/env python3
"""Scheduler admission, consumer parity, and restart-safe one-step decisions."""
import datetime
import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from ratchet_fixture import HEAD, WATCHER, metadata, policy, seed, write_json
import driver

JOBS = Path(__file__).resolve().parents[1]


class Watcher(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix='.ratchet-watcher-', dir=Path.home())
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.journal = self.directory / 'seed'
        self.journal.mkdir()
        seed(self.journal)
        self.git('init', '-q', '-b', 'journal2')
        self.git('config', 'user.name', 'test')
        self.git('config', 'user.email', 'test@example.invalid')
        # The fixture receipt's finished watcher must not occupy the scheduler.
        (self.journal / f'jobs/doin/{WATCHER}.md').unlink()
        schedule = self.journal / 'schedules/ironhorse-ratchet.md'
        schedule.parent.mkdir()
        schedule.write_text('cadence: 2h\nlast_dispatched: \njob_basename_prefix: ironhorse-ratchet-watch\n'
                            'occupancy: skip\n---\nUnrelated task attempting to use mentat.\n')
        self.commit()
        self.remote = self.directory / 'journal.git'
        subprocess.run(['git', 'clone', '-q', '--bare', str(self.journal), str(self.remote)], check=True)
        self.git('remote', 'add', 'origin', str(self.remote))
        self.root = self.directory / 'root'
        self.root.mkdir()
        subprocess.run(['git', 'init', '-q', str(self.root)], check=True)
        (self.root / 'scripts').symlink_to(JOBS.parent)
        self.environment = {key: value for key, value in os.environ.items()
                            if not key.startswith(('GARDEN_', 'JOURNAL_'))}
        self.environment.update(GARDEN_TEST='1', GARDEN='testhost', GARDEN_LEADER='testhost',
                                GARDEN_ROOT=str(self.root), GARDEN_STATE=str(self.directory / 'state'),
                                GARDEN_SCHEDULER_CLONE=str(self.directory / 'scheduler'),
                                JOURNAL_REMOTE=str(self.remote), JOURNAL_BRANCH='journal2',
                                GARDEN_BUDGET_LEVEL_ENABLED='0', GARDEN_SCHEDULER_NOW='1790632800')
        driver.JOURNAL = self.journal
        driver.WATCHER = WATCHER
        driver.NOW = datetime.datetime(2026, 9, 28, 22, tzinfo=datetime.timezone.utc)
        self.state = json.loads((self.journal / policy.STATE).read_text())

    def git(self, *arguments):
        return subprocess.run(['git', '-C', str(self.journal), *arguments], check=True, capture_output=True)

    def commit(self):
        self.git('add', '.')
        self.git('commit', '-qm', 'fixture')

    def publish(self):
        self.commit(); self.git('push', '-q', 'origin', 'journal2')

    def scheduler(self):
        result = subprocess.run(['bash', str(JOBS / 'scheduler.sh')], env=self.environment,
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return list((self.directory / 'scheduler/jobs/todo').glob('*.md'))

    def test_scheduler_canonical_task_and_occupancy(self):
        jobs = self.scheduler()
        self.assertEqual(len(jobs), 1)
        self.assertEqual(jobs[0].read_text(), policy.TEMPLATE.read_text())
        policy.watcher_job(self.directory / 'scheduler', jobs[0])
        self.environment['GARDEN_SCHEDULER_NOW'] = '1790640000'
        self.assertEqual(len(self.scheduler()), 1)

    def test_budget_held_watcher_keeps_authority_through_promotion(self):
        job = self.journal / f'jobs/plan/{WATCHER}.md'
        job.parent.mkdir(parents=True)
        wrapped = subprocess.check_output(['bash', '-c',
            f'source "{JOBS}/common.sh"; body="$(cat "{policy.TEMPLATE}")"; budget_hold_wrap "$body" scheduler'],
            env=self.environment, text=True)
        job.write_text(wrapped)
        policy.watcher_job(self.journal, job)
        self.publish()
        result = subprocess.run(['bash', str(JOBS / 'promote-plan.sh'), WATCHER], env=self.environment,
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        promoted = self.directory / f'state/producer/journal/jobs/todo/{WATCHER}.md'
        self.assertEqual(promoted.read_text(), policy.TEMPLATE.read_text())
        policy.watcher_job(promoted.parents[2], promoted)

    def test_paused_scheduler_is_fail_closed(self):
        configuration = self.journal / policy.CONFIGURATION
        record = json.loads(configuration.read_text()); record['status'] = 'paused'
        write_json(configuration, record); self.publish()
        self.assertEqual(self.scheduler(), [])

    def test_revoked_scheduler_is_fail_closed(self):
        (self.journal / f'{policy.CONFIGURATION}.revoked').touch(); self.publish()
        self.assertEqual(self.scheduler(), [])

    def test_wrong_schedule_never_emits_mentat(self):
        original = self.journal / 'schedules/ironhorse-ratchet.md'
        other = original.with_name('other.md')
        original.rename(other)
        other.write_text('cadence: 2h\njob_basename_prefix: other\n---\n' + policy.TEMPLATE.read_text())
        self.publish()
        jobs = self.scheduler()
        self.assertEqual(len(jobs), 1)
        self.assertIn('tier: mentor', jobs[0].read_text())
        self.assertNotIn('tier: mentat', jobs[0].read_text())

    def test_claim_and_both_handlers_admit_only_active_canonical_watcher(self):
        job = self.journal / f'jobs/doin/{WATCHER}.md'
        job.write_text(policy.TEMPLATE.read_text())
        self.publish()
        claim_source = (JOBS / 'claim-job.sh').read_text()
        function = claim_source.split('job_eligible_for_kind() {', 1)[1].split('\n}', 1)[0]
        for kind, provider in (('monk', 'anthropic'), ('cleric', 'openai')):
            source = f'''source "{JOBS}/common.sh"
DIR="{self.journal}"
HERE="{JOBS}"
KIND={kind}; KIND_PROVIDER={provider}
job_eligible_for_kind() {{{function}
}}
job_eligible_for_kind "{job}"
'''
            result = subprocess.run(['bash', '-c', source], env=self.environment, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
        for handler in ('monk-claude.sh', 'cleric-codex.sh'):
            source = (JOBS / 'handlers' / handler).read_text()
            gate = 'if [ "$requested_tier" = mentat ]' + source.split('if [ "$requested_tier" = mentat ]', 1)[1].split('\nfi', 1)[0] + '\nfi'
            shell = f'source "{JOBS}/common.sh"\nHERE="{JOBS}/handlers"\nrequested_tier=mentat\njobfile="{job}"\n{gate}'
            result = subprocess.run(['bash', '-c', shell], env=self.environment, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            # Same declaration with different prose must not become a general route.
            job.write_text(policy.TEMPLATE.read_text() + 'Do unrelated work.\n')
            result = subprocess.run(['bash', '-c', shell], env=self.environment, capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            job.write_text(policy.TEMPLATE.read_text())
        (self.journal / f'{policy.CONFIGURATION}.revoked').touch(); self.publish()
        result = subprocess.run(['bash', '-c', shell], env=self.environment, capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)

    def test_live_transactions_pause_and_notify_atomically(self):
        first = WATCHER
        second = 'ironhorse-ratchet-watch-20260929-000000'
        for base in (first, second):
            (self.journal / f'jobs/doin/{base}.md').write_text(policy.TEMPLATE.read_text())
        self.publish()
        reason = self.directory / 'reason.txt'; reason.write_text('coverage floor loss')
        environment = dict(self.environment, GARDEN_JOB_MODEL='gpt-6-astra', GARDEN_WORKER_KIND='cleric',
                           GARDEN_RATCHET_CONTROL_CLONE=str(self.directory / 'control'))
        for base in (first, first, second):
            environment['GARDEN_JOB_BASE'] = base
            result = subprocess.run(['bash', str(JOBS / 'ironhorse-ratchet.sh'), 'fail', str(reason)],
                                    env=environment, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        configuration = subprocess.check_output(['git', '--git-dir', str(self.remote), 'show',
                                                 f'journal2:{policy.CONFIGURATION}'], text=True)
        self.assertEqual(json.loads(configuration)['status'], 'paused')
        notice = subprocess.check_output(['git', '--git-dir', str(self.remote), 'show',
                                         f'journal2:inbox/maintainer/unread/ironhorse-ratchet-halted-{second}.md'], text=True)
        self.assertIn('coverage floor loss', notice)
        self.assertEqual(self.scheduler(), [])

    def test_failed_criterion_twice_pauses_and_alerts_once(self):
        with patch.object(driver, 'notify') as notify:
            self.assertEqual(driver.failure(self.state, 'coverage lost')['action'], 'retry-next-tick')
            self.assertEqual(driver.failure(self.state, 'coverage lost')['action'], 'retry-next-tick')
            driver.WATCHER = 'ironhorse-ratchet-watch-20260929-000000'
            self.assertEqual(driver.failure(self.state, 'coverage lost')['action'], 'halt')
            notify.assert_called_once()
            self.assertEqual(json.loads((self.journal / policy.CONFIGURATION).read_text())['status'], 'paused')

    def test_stuck_child_halts(self):
        self.state['last_progress'] = '2026-09-27T20:00:00+00:00'
        with patch.object(driver, 'notify'):
            self.assertEqual(driver.waiting(self.state, 'child has not completed')['action'], 'halt')

    def test_single_draft_posts_one_gauntlet(self):
        information = metadata(); information.update(isDraft=True, statusCheckRollup=[])
        with patch.object(driver, 'pull_requests', return_value=[dict(number=17, state='open')]), \
             patch.object(driver, 'metadata', return_value=information), \
             patch.object(driver, 'github', return_value=[[]]), patch.object(driver, 'script') as script:
            result = driver.step(self.state)
            self.assertEqual(result['action'], 'gauntlet')
            self.assertEqual(script.call_count, 1)
            self.assertEqual(script.call_args.args[0], 'post-gauntlet.sh')
            record = self.journal / f'jobs/gauntlet/{result["job"]}.md'
            record.parent.mkdir(parents=True); record.write_text('state: running\n')
            self.assertEqual(driver.step(self.state)['action'], 'wait')
            self.assertEqual(script.call_count, 1)

    def test_multiple_open_prs_halt(self):
        with patch.object(driver, 'pull_requests', return_value=[dict(number=17, state='open'), dict(number=18, state='open')]), \
             patch.object(driver, 'notify'), patch.object(driver, 'script') as script:
            self.assertEqual(driver.step(self.state)['action'], 'halt')
            script.assert_not_called()

    def test_red_posts_shepherd_once_and_stuck_shepherd_halts(self):
        information = metadata(); information['statusCheckRollup'] = [{'conclusion': 'FAILURE'}]
        with patch.object(driver, 'pull_requests', return_value=[dict(number=17, state='open')]), \
             patch.object(driver, 'metadata', return_value=information), \
             patch.object(driver, 'github', return_value=[[]]), patch.object(driver, 'script') as script:
            result = driver.step(self.state)
            self.assertEqual(result['action'], 'shepherd')
            job = self.journal / f'jobs/todo/{result["job"]}.md'
            job.parent.mkdir(parents=True); job.write_text('role: shepherd\n')
            self.assertEqual(driver.step(self.state)['action'], 'wait')
            self.assertEqual(script.call_count, 1)
            self.state['last_progress'] = '2026-09-27T20:00:00+00:00'
            with patch.object(driver, 'notify'):
                self.assertEqual(driver.step(self.state)['action'], 'halt')

    def test_no_open_pr_waits_for_initial_builder(self):
        self.state['builder'] = 'first-crank'
        (self.journal / 'jobs/doin/first-crank.md').write_text('builder')
        with patch.object(driver, 'pull_requests', return_value=[]), patch.object(driver, 'script') as script:
            self.assertEqual(driver.step(self.state)['action'], 'wait')
            script.assert_not_called()


if __name__ == '__main__':
    unittest.main()
