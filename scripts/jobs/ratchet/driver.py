#!/usr/bin/env python3
"""One-step ratchet driver. The shell wrapper owns journal synchronization/CAS."""
import datetime
import gzip
import json
import os
import subprocess
import sys
from pathlib import Path

from evidence import verify
from policy import (AUTHORIZATION, CONFIGURATION, IDENTITY, MARKER, REPOSITORY, STATE,
                    active, attestation, digest, fields, read_json, require, reviews_clear,
                    scope, watcher_job)

HERE = Path(__file__).resolve().parents[1]
JOURNAL = Path(sys.argv[2]) if len(sys.argv) > 2 else Path('.')
NOW = datetime.datetime.now(datetime.timezone.utc)
WATCHER = os.environ.get('GARDEN_JOB_BASE', '')


def write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def command(*arguments):
    return subprocess.check_output(list(map(str, arguments)), text=True)


def github(*arguments):
    return json.loads(command(os.environ.get('GARDEN_GH', 'gh'), *arguments))


def script(name, *arguments):
    subprocess.run([str(HERE / name), *map(str, arguments)], check=True)


def terminal(base):
    paths = list((JOURNAL / 'jobs/tada').rglob(f'{base}.md'))
    require(len(paths) <= 1, 'ambiguous completed job')
    return paths[0] if paths else None


def live(base):
    return any((JOURNAL / f'jobs/{category}/{base}.md').is_file()
               for category in ('todo', 'doin', 'plan'))


def notify(reason):
    # Pause and notification share the journal CAS: neither can get lost if a
    # separate bus producer is temporarily unavailable.
    notice = JOURNAL / f'inbox/maintainer/unread/ironhorse-ratchet-halted-{WATCHER}.md'
    notice.parent.mkdir(parents=True, exist_ok=True)
    notice.write_text(f'from_host: {os.environ.get("GARDEN", "unknown")}\n'
                      f'from: {IDENTITY}\nsent_at: {NOW.isoformat()}\n---\n'
                      f'Ironhorse ratchet halted: {reason}\n'
                      'Tracker: https://github.com/kriscendobot/garden/issues/51\n'
                      'Inspect ratchets/ironhorse-test262-ratchet/state.json and\n'
                      'context/operations/ironhorse-ratchet.md. Explicitly resume only after resolution.\n')


def halt(state, reason):
    state['halted'] = reason
    record = read_json(JOURNAL / CONFIGURATION)
    record['status'] = 'paused'
    write(JOURNAL / CONFIGURATION, record)
    write(JOURNAL / STATE, state)
    notify(reason)
    return {'action': 'halt', 'reason': reason}


def failure(state, reason):
    observations = state.setdefault('failure_ticks', [])
    if WATCHER not in observations:
        observations.append(WATCHER)
    state['failure_reason'] = reason
    write(JOURNAL / STATE, state)
    if len(observations) >= 2:
        return halt(state, reason)
    return {'action': 'retry-next-tick', 'reason': reason}


def progress(state):
    state['last_progress'] = NOW.isoformat()
    state['failure_ticks'] = []
    state.pop('failure_reason', None)
    write(JOURNAL / STATE, state)


def pull_requests():
    pages = github('api', '--paginate', '--slurp',
                   f'repos/{REPOSITORY}/pulls?state=all&per_page=100')
    require(isinstance(pages, list) and all(isinstance(page, list) for page in pages),
            'PR list unreadable')
    return [item for page in pages for item in page
            if MARKER in (item.get('body') or '').splitlines()]


def metadata(number):
    return github('pr', 'view', str(number), '-R', REPOSITORY, '--json',
                  'baseRefName,author,body,state,headRefOid,isDraft,reviewDecision,statusCheckRollup')


def job_body(state, action, number=None, head=None):
    if action == 'build':
        cluster = state['queue'][0]
        return f'''role: builder
ratchet-arc: {IDENTITY}
issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5884119530
submitter: kriscendobot
# One Ironhorse test262 ratchet crank
Authorization: journal {AUTHORIZATION}; delegation {CONFIGURATION} must remain active.
Repo {REPOSITORY}, base llm, branch point {state['branch_point']}.
Implement only the next refined abort cluster: {cluster['reason']} ({cluster['count']} cases).
Open ONE draft PR using ensure-pr.sh and put this marker on its own line:
{MARKER}
Use your isolated ensure-project-worktree.sh checkout; start from the named branch point.
Run the whole-corpus branch-point sweep BEFORE edits, with the pinned corpus and XS oracle.
Defend both its covered set and enforced floor {state['floor']}; fix losses before expanding.
Add this cluster's own oracle dual-run regression suite and instrumented new-code coverage.
Run the Rust package gates for ironhorse-vm, ironhorse-compile, ironhorse-262, ironhorse-snapshot.
Commit a byte-sorted refreshed baseline/refresh-<date>/covered.txt and publish durable full
before/after report.json artifacts, commands, source SHAs, LCOV and test logs. The watcher
requires measurements at the exact final head, not a pre-rebase commit. See garden
context/operations/ironhorse-ratchet.md for the evidence contract. Temporal/Intl are out of scope.
Do not begin another cluster or PR; leave this one draft. Do not lower the floor or change pins.
'''
    if action == 'shepherd':
        return f'''role: shepherd
ratchet-arc: {IDENTITY}
issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5884119530
submitter: kriscendobot
Drive CI to green for https://github.com/{REPOSITORY}/pull/{number}, currently {head}.
This is one authorized Ironhorse ratchet crank ({AUTHORIZATION}). Check the delegation
is active before mutations. Preserve its scope and enforced floor {state['floor']}.
Use your isolated project checkout. Refresh regression/coverage evidence after changes;
a changed head requires a new gauntlet and mentat attestation. Do not merge or start a crank.
'''
    return f'''role: conductor
ratchet-arc: {IDENTITY}
issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5884119530
submitter: kriscendobot
Merge https://github.com/{REPOSITORY}/pull/{number} only through the delegated spine:
scripts/jobs/gardening/ci-wait-merge.sh {REPOSITORY} {number} --ratchet-delegated-merge
Use your own ensure-project-worktree.sh checkout. Expected attested head: {head}.
Authorization: {AUTHORIZATION}; the helper rechecks the live delegation, exact-head
attestation, CI and maintainer veto/dismissal. Do not substitute ordinary merge commands,
queue auto-merge, or reinterpret missing authority. A rebase invalidates this attestation;
report the changed head and stop for the next watcher tick to re-run the gauntlet/verification.
Emit the orchestration failure signal on a refused merge; never claim a pending PR merged.
'''


def post_job(state, action, number=None, head=None):
    identity = f"pr{number}-{head[:12]}" if number else f"crank{state['crank']}"
    key = f'{action}:{identity}'
    actions = state.setdefault('actions', {})
    existing = actions.get(key)
    if existing:
        if live(existing):
            return waiting(state, f'{action} job {existing} still live')
        return failure(state, f'{action} job {existing} ended without the required PR transition')
    # The date is persisted by the enclosing journal transaction; after a rejected
    # push, deterministic head/crank + date still rediscovers the same post.
    base = f'ironhorse-ratchet-{identity}-{action}-{state["crank_date"]}'
    body = JOURNAL.parent / 'ratchet-job.txt'
    body.write_text(job_body(state, action, number, head))
    script('post-job.sh', base, body)
    actions[key] = base
    if action == 'build':
        state['builder'] = base
    progress(state)
    return {'action': action, 'job': base}


def completed_gauntlet(state, head, number):
    base = state.get('gauntlet')
    if not base or state.get('gauntlet_head') != head:
        return False
    report = terminal(base)
    if not report or fields(report.read_text()).get('gauntlet-status') != 'complete':
        return False
    # Journal history order, not filesystem timestamps, picks the newest review.
    directory = f'panel-runs/endojs-endo-but-for-bots-{number}'
    paths = command('git', '-C', JOURNAL, 'log', '--format=', '--name-only', '--', directory).splitlines()
    for path in dict.fromkeys(paths):
        if path.endswith('.md') and (JOURNAL / path).is_file():
            panel = fields((JOURNAL / path).read_text())
            if panel.get('disposition') in ('passed', 'must-fix', 'max-rounds-exceeded'):
                return panel.get('reviewed_head') == head and panel['disposition'] == 'passed'
    return False


def step(state):
    requests = pull_requests()
    opened = [item for item in requests if item['state'] == 'open']
    if len(opened) > 1:
        return halt(state, 'multiple open ratchet PRs; one crank at a time')
    current = state.get('pull_request')
    if current:
        previous = next((item for item in requests if item['number'] == current), None)
        require(previous is not None, 'current PR missing from GitHub enumeration')
        if previous['state'] == 'closed':
            if not previous.get('merged_at'):
                return halt(state, f'ratchet PR {current} closed without merge')
            receipt = read_json(JOURNAL / f'ratchets/{IDENTITY}/attestations/{current}/{previous["head"]["sha"]}.json')
            comment_marker = f'<!-- ironhorse-ratchet-merged: {current} -->'
            comments = github('api', '--paginate', '--slurp', 'repos/kriscendobot/garden/issues/51/comments?per_page=100')
            if not any(comment_marker in item['body'] for page in comments for item in page):
                body = JOURNAL.parent / 'ratchet-tracker.txt'
                body.write_text(f'{comment_marker}\nMerged https://github.com/{REPOSITORY}/pull/{current}\n'
                                f'Head {receipt["head"]}: +{receipt["gained"]} covered, zero lost; '
                                'gauntlet complete, CI green, new code covered.\n'
                                f'Next ranked clusters: {json.dumps(receipt["queue"][:10])}\n')
                script('ratchet-delegation.sh', 'active')
                command(os.environ.get('GARDEN_GH', 'gh'), 'issue', 'comment', '51', '-R',
                        'kriscendobot/garden', '--body-file', body)
            state.update(floor=receipt['next_floor'], queue=receipt['queue'],
                         pull_request=None, builder=None, gauntlet=None, crank=state['crank'] + 1, crank_date=NOW.strftime('%Y%m%d'))
            progress(state)
            return {'action': 'recorded-merge', 'pull_request': current}
    if not opened:
        if state.get('builder'):
            if live(state['builder']):
                return waiting(state, 'builder still live')
            return failure(state, 'builder finished or vanished without its single draft PR')
        if not state.get('queue'):
            return halt(state, 'ranked refined abort queue exhausted; maintainer disposition needed')
        state['branch_point'] = github('api', f'repos/{REPOSITORY}/git/ref/heads/llm')['object']['sha']
        return post_job(state, 'build')
    if state.get('builder') and live(state['builder']):
        return waiting(state, 'builder is still preparing its draft')
    for base in state.get('actions', {}).values():
        if live(base):
            return waiting(state, f'child {base} is still running')
    number = opened[0]['number']
    require(not current or current == number, 'unexpected next crank before prior merge recorded')
    information = metadata(number)
    head = information['headRefOid']
    scope(REPOSITORY, information)
    pages = github('api', '--paginate', '--slurp', f'repos/{REPOSITORY}/pulls/{number}/reviews?per_page=100')
    try:
        reviews_clear(JOURNAL, information, pages)
    except ValueError as error:
        return halt(state, str(error))
    if state.get('head') != head or state.get('pull_request') != number:
        state.update(pull_request=number, head=head)
        progress(state)
    gauntlet = state.get('gauntlet')
    if gauntlet and (JOURNAL / f'jobs/gauntlet/{gauntlet}.md').is_file():
        return waiting(state, 'gauntlet is running')
    checks = information['statusCheckRollup']
    failed = {'FAILURE', 'ERROR', 'CANCELLED', 'TIMED_OUT', 'ACTION_REQUIRED', 'STARTUP_FAILURE'}
    if any((check.get('conclusion') or check.get('state')) in failed for check in checks):
        return post_job(state, 'shepherd', number, head)
    if not completed_gauntlet(state, head, number):
        if gauntlet and state.get('gauntlet_head') == head and terminal(gauntlet):
            return failure(state, 'gauntlet ended without a passed exact-head panel')
        base = f'ironhorse-ratchet-pr{number}-gauntlet-{head[:12]}-{state["crank_date"]}'
        script('post-gauntlet.sh', '--by', IDENTITY, base, f'https://github.com/{REPOSITORY}/pull/{number}')
        state.update(gauntlet=base, gauntlet_head=head)
        progress(state)
        return {'action': 'gauntlet', 'job': base}
    if information['isDraft']:
        return failure(state, 'completed gauntlet left PR draft')
    if not checks or any((check.get('status') or check.get('state')) in
                         ('QUEUED', 'IN_PROGRESS', 'PENDING', 'WAITING') for check in checks):
        return waiting(state, 'CI is pending')
    receipt = JOURNAL / f'ratchets/{IDENTITY}/attestations/{number}/{head}.json'
    if receipt.is_file():
        attestation(JOURNAL, number, head)
        return post_job(state, 'conduct', number, head)
    return {'action': 'verify', 'pull_request': number, 'head': head, 'state': state}


def waiting(state, reason):
    previous = datetime.datetime.fromisoformat(state['last_progress'])
    if (NOW - previous).total_seconds() >= 24 * 3600:
        return halt(state, f'stuck for 24h without progress: {reason}')
    return {'action': 'wait', 'reason': reason}


def attest(state, manifest_path):
    number, head = state['pull_request'], state['head']
    information = metadata(number)
    scope(REPOSITORY, information, head)
    require(completed_gauntlet(state, head, number), 'latest gauntlet/panel is not passed at this head')
    pages = github('api', '--paginate', '--slurp', f'repos/{REPOSITORY}/pulls/{number}/reviews?per_page=100')
    reviews_clear(JOURNAL, information, pages)
    manifest = read_json(manifest_path)
    result = verify(manifest, state, JOURNAL, head, number)
    directory = JOURNAL / f'ratchets/{IDENTITY}/attestations/{number}'
    directory.mkdir(parents=True, exist_ok=True)
    archive = directory / head
    archive.mkdir(exist_ok=True)
    artifacts = {key: Path(manifest[key]) for key in ('before_report', 'after_report', 'covered')}
    artifacts.update(dual_run=Path(manifest['dual_run']['log']), lcov=Path(manifest['new_code']['lcov']), test_log=Path(manifest['new_code']['test_log']),
                     gauntlet=JOURNAL / manifest['gauntlet_report'], panel=JOURNAL / manifest['panel_report'])
    for key, path in artifacts.items():
        (archive / f'{key}.gz').write_bytes(gzip.compress(path.read_bytes(), mtime=0))
    (archive / 'manifest.json').write_bytes(Path(manifest_path).read_bytes())
    job = JOURNAL / f'jobs/doin/{WATCHER}.md'
    watcher_job(JOURNAL, job)
    (archive / 'watcher.md').write_bytes(job.read_bytes())
    result.update(schema=1, repository=REPOSITORY, pull_request=number, head=head,
                  watcher_job=WATCHER, watcher_tier='mentat', watcher_model=os.environ['GARDEN_JOB_MODEL'],
                  attested_at=NOW.isoformat(), watcher_sha256=digest(job.read_bytes()))
    write(directory / f'{head}.json', result)
    # The wrapper commits this receipt before posting the conductor; a crash
    # between the two is recovered by the next step without re-attestation.
    progress(state)
    return {'action': 'attested', 'head': head, 'gained': result['gained']}


def main():
    action = sys.argv[1]
    if action in ('pause', 'revoke', 'resume'):
        record = read_json(JOURNAL / CONFIGURATION)
        require(not (JOURNAL / f'{CONFIGURATION}.revoked').exists(), 'delegation permanently revoked')
        record['status'] = {'pause': 'paused', 'revoke': 'revoked', 'resume': 'active'}[action]
        if action == 'revoke':
            write(JOURNAL / f'{CONFIGURATION}.revoked', {'revoked_at': NOW.isoformat(), 'reason': Path(sys.argv[3]).read_text()})
        write(JOURNAL / CONFIGURATION, record)
        if action == 'resume':
            state = read_json(JOURNAL / STATE)
            state.pop('halted', None)
            progress(state)
        print(action)
        return
    if action == 'status':
        print(json.dumps(read_json(JOURNAL / STATE), indent=2))
        return
    active(JOURNAL)
    watcher_job(JOURNAL, JOURNAL / f'jobs/doin/{WATCHER}.md')
    require(os.environ.get('GARDEN_RATCHET_MODEL_TIER') == 'mentat', 'watcher runtime must be mentat')
    state = read_json(JOURNAL / STATE)
    require(not state.get('halted'), 'arc halted')
    if state.get('last_tick') == WATCHER and action != 'conduct':
        print(json.dumps({'action': 'already-advanced-this-tick'}))
        return
    try:
        if action == 'step':
            result = step(state)
        elif action == 'attest':
            result = attest(state, sys.argv[3])
        elif action == 'conduct':
            receipt = attestation(JOURNAL, state['pull_request'], state['head'])
            require(receipt['watcher_job'] == WATCHER, 'only this attestor may finish its posting step')
            result = post_job(state, 'conduct', state['pull_request'], state['head'])
        elif action == 'fail':
            result = failure(state, Path(sys.argv[3]).read_text())
        else:
            raise ValueError('unknown ratchet action')
    except (ValueError, KeyError, TypeError, OSError, subprocess.CalledProcessError) as error:
        result = failure(state, str(error))
    if result['action'] != 'verify':
        state['last_tick'] = WATCHER
        write(JOURNAL / STATE, state)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, TypeError, OSError, subprocess.CalledProcessError) as error:
        print(f'ratchet stopped: {error}', file=sys.stderr)
        sys.exit(1)
