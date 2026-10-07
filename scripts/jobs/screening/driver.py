#!/usr/bin/env python3
"""One screener tick over kriscendobot/minion.town (proxy pre-pass 1d, no LLM).

Reads GitHub metadata, CI rollups, diff paths, and journal records only; fixed
heal/probe markers are the only PR-body matches, and no text reaches an LLM.
Journal writes (attestations, comparison blocks, and
validation records, the delegation's pause/resume, maintainer notices) land in the
working tree; the shell wrapper commits them with one CAS push and then performs
the printed actions (job posts and gauntlet records). Every action
is keyed by a deterministic name, so a lost push or a re-tick repeats nothing.
"""
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import quote

from policy import (AUTHOR, CONFIGURATION, HEARTBEAT_MAX_AGE, IDENTITY, LIVE_BASE,
                    REPOSITORY, SCREENINGS, VALIDATION_WINDOW, attestation_path,
                    canonical_login, digest, heal_target, human_veto, iso, now,
                    parse_time, probe_body, read_json, record, write_json)

JOURNAL = Path(sys.argv[1])
NOW = now()
HEARTBEAT = Path(os.environ.get('GARDEN_SCREEN_HEARTBEAT', '/nonexistent'))
URL = f'https://github.com/{REPOSITORY}'
actions, notes = [], []


def gh(*arguments, raw=False):
    output = subprocess.check_output([os.environ.get('GARDEN_GH', 'gh'), *map(str, arguments)], text=True)
    return output if raw else json.loads(output)


def pages(path):
    value = gh('api', '--paginate', '--slurp', path)
    if not (isinstance(value, list) and all(isinstance(page, list) for page in value)):
        raise ValueError(f'{path} unreadable')
    return [item for page in value for item in page]


def note(message):
    notes.append(message)


def notify(key, body):
    """A maintainer notice in the same commit as the state change that caused it."""
    path = JOURNAL / f'inbox/maintainer/unread/{IDENTITY}-{key}.md'
    if path.exists() or (JOURNAL / f'inbox/maintainer/read/{path.name}').exists():
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(f'from_host: {os.environ.get("GARDEN", "unknown")}\nfrom: proxy:screen\n'
                    f'sent_at: {iso(NOW)}\n---\n{body.rstrip()}\n'
                    'Operations: context/operations/minion-town-screening.md\n')


# --- board lookups ------------------------------------------------------------
TADA = {}
for path in (JOURNAL / 'jobs/tada').rglob('*.md') if (JOURNAL / 'jobs/tada').is_dir() else ():
    TADA.setdefault(path.stem, path)


def on_board(base):
    return base in TADA or any((JOURNAL / f'jobs/{kind}/{base}.md').is_file()
                               for kind in ('todo', 'doin', 'plan'))


def fields(path):
    found = {}
    for line in path.read_text(errors='replace').splitlines()[:40]:
        if line.startswith('# '):
            break
        key, _, value = line.partition(':')
        if key and _ and key.strip() not in found:
            found[key.strip()] = value.strip()
    return found


def matches(values, number):
    return values.get('repo') == REPOSITORY and values.get('pr_number') == str(number)


def probe_jobs():
    """PR numbers durably marked as probes by associated board/report records."""
    paths = list(TADA.values())
    for kind in ('todo', 'doin', 'plan', 'withdrawn', 'gauntlet'):
        root = JOURNAL / f'jobs/{kind}'
        if root.is_dir():
            paths.extend(root.glob('*.md'))
    found = set()
    url = re.compile(rf'https://github\.com/{re.escape(REPOSITORY)}/pull/(\d+)')
    marker = re.compile(r'(?im)^\s*(?:kind|verb):\s*probe\s*$|gap[- ]revealing')
    for path in paths:
        try:
            body = path.read_text(errors='replace')
        except OSError:
            continue
        if not marker.search(body):
            continue
        values = fields(path)
        if values.get('repo') == REPOSITORY and values.get('pr_number', '').isdigit():
            found.add(int(values['pr_number']))
        found.update(int(match.group(1)) for match in url.finditer(body))
    return found


PROBE_PRS = probe_jobs()


def gauntlets(number):
    """(in_flight, completed panel heads, probe-marked job exists)."""
    live = JOURNAL / 'jobs/gauntlet'
    live_records = [(path, fields(path)) for path in live.glob('*.md')] if live.is_dir() else []
    in_flight = any(matches(values, number) for _, values in live_records)
    probe = number in PROBE_PRS or any(
        matches(values, number) and values.get('kind') == 'probe'
        for _, values in live_records)
    heads = []
    for stem, path in TADA.items():
        if 'gauntlet' in stem:
            values = fields(path)
            if matches(values, number) and values.get('kind') == 'probe':
                probe = True
            if (values.get('gauntlet-status') == 'complete' and matches(values, number)
                    and values.get('kind', 'feature') != 'probe'
                    and len(values.get('panel_head', '')) == 40):
                heads.append((values['panel_head'], str(path.relative_to(JOURNAL))))
    return in_flight, heads, probe


# --- GitHub reads, cached per tick ----------------------------------------------
COMPARISONS = {}


def compare(base, head):
    key = (base, head)
    if key not in COMPARISONS:
        COMPARISONS[key] = gh('api', f'repos/{REPOSITORY}/compare/{quote(base, safe="")}...{head}')
    return COMPARISONS[key]


def patch_fingerprint(base, head):
    """The PR's own change (merge-base..head) with hunk offsets erased, or None."""
    items = []
    for item in compare(base, head).get('files', []):
        if 'patch' not in item and item.get('changes', 0):
            return None
        patch = '\n'.join(line for line in item.get('patch', '').splitlines() if not line.startswith('@@'))
        items.append([item['filename'], item.get('status'), item.get('previous_filename'), patch])
    return digest(json.dumps(sorted(items, key=str)).encode())


def compare_limit_exceeded(base, head):
    return len(compare(base, head).get('files', [])) >= 300


LATEST = {}


def latest_main_deploy():
    if 'run' not in LATEST:
        runs = gh('run', 'list', '-R', REPOSITORY, '--workflow', 'deploy.yml', '--branch', LIVE_BASE,
                  '--limit', '1', '--json', 'databaseId,status,conclusion,headSha,url,createdAt,updatedAt')
        LATEST['run'] = runs[0] if runs else None
    return LATEST['run']


def heartbeat():
    try:
        beat = json.loads(HEARTBEAT.read_text())
        beat['age'] = (NOW - parse_time(beat['at'])).total_seconds()
        return beat
    except (OSError, ValueError, KeyError, TypeError):
        return None


def healthy_after(moment=None):
    beat = heartbeat()
    return (beat is not None and beat.get('state') == 'ok' and beat['age'] < HEARTBEAT_MAX_AGE and
            (moment is None or parse_time(beat['at']) >= parse_time(moment))), beat


def baseline():
    run = latest_main_deploy()
    if not run or run.get('status') != 'completed' or run.get('conclusion') != 'success':
        return None, f"last main deploy is {run and (run.get('conclusion') or run.get('status'))}"
    ok, beat = healthy_after()
    if not ok:
        return None, f"MCP watchdog is {beat and beat.get('state')} (age {beat and int(beat['age'])}s)"
    return dict(deploy_run=run['databaseId'], deploy_url=run.get('url'), heartbeat_at=beat['at']), None


# --- the screen -------------------------------------------------------------------
def ci_state(rollup):
    if not isinstance(rollup, list) or not rollup:
        return 'none', []
    checks = []
    for check in rollup:
        status = (check.get('status') or check.get('state') or '').upper()
        conclusion = (check.get('conclusion') or check.get('state') or '').upper()
        if status in ('QUEUED', 'IN_PROGRESS', 'PENDING', 'WAITING', 'REQUESTED', 'EXPECTED'):
            return 'pending', []
        if conclusion not in ('SUCCESS', 'NEUTRAL', 'SKIPPED'):
            return 'red', []
        checks.append(check.get('detailsUrl') or check.get('targetUrl') or check.get('name') or check.get('context'))
    return 'green', checks


CONDUCTOR_ATTEMPTS = 3


def conductor(number, head, heal):
    """Post the delegated conductor for an attested head; a bounded re-post covers a
    conductor that finished without merging while the head stayed put."""
    first = f'screen-minion-town-pr{number}-{head[:7]}-conduct'
    names = [first] + [f'{first}-r{attempt}' for attempt in range(2, CONDUCTOR_ATTEMPTS + 1)]
    if any((JOURNAL / f'jobs/{kind}/{name}.md').is_file() for name in names for kind in ('todo', 'doin', 'plan')):
        return
    base = next((name for name in names if name not in TADA), None)
    if base is None:
        notify(f'stalled-pr{number}-{head[:7]}',
               f'minion.town delegated merge STALLED: {URL}/pull/{number} (head {head[:11]}) was '
               f'screened, but {CONDUCTOR_ATTEMPTS} conductors finished without merging it. '
               'Read their reports under jobs/tada/ (base ' + first + '*).')
        return
    body = f'''role: conductor
delegation: {IDENTITY}
# Screened delegated merge: {REPOSITORY}#{number} at {head}
The proxy's screen attested {SCREENINGS}/{number}/{head}.json on journal2
(delegation {CONFIGURATION}; designs/minion-town-pr-screening.md). No maintainer
approval is required; do not request one.
1. Get an isolated project checkout keyed by THIS job's base:
   scripts/jobs/ensure-project-worktree.sh <this-job-base> {REPOSITORY} <pr-head-branch>
2. From that checkout run:
   scripts/jobs/gardening/ci-wait-merge.sh {REPOSITORY} {number} --screened-delegated-merge
3. Exit 0 is done. "merge blocked: awaiting re-screen" means the rebase moved the head:
   finish and report it; the proxy screens the new head and posts a fresh conductor.
   Any other "merge blocked" or a red/stalled CI result: report it and finish; never
   fall back to an ordinary merge, never queue --auto, never ask for approval.
{f"This PR heals production after merge {heal}." if heal else ""}
PR: {URL}/pull/{number}
'''
    actions.append(dict(kind='post', base=base, body=body))


def screen(value, pull):
    number, head, pr_base = pull['number'], pull['headRefOid'], pull.get('baseRefName')
    if (not isinstance(pr_base, str) or not pr_base
            or canonical_login(pull['author']['login']) != AUTHOR
            or pull.get('isDraft') or pull.get('state', 'OPEN') != 'OPEN'
            or probe_body(pull.get('body'))):
        return
    in_flight, heads, probe = gauntlets(number)
    if probe:
        return note(f'#{number}: gap-revealing probe stays draft')
    heal = heal_target(pull.get('body'))
    heal = heal if heal in value.get('healing', []) else None
    if value['status'] != 'active' and not heal:
        return note(f'#{number}: delegation paused')
    target = attestation_path(JOURNAL, number, head)
    if target.is_file():
        return conductor(number, head, read_json(target).get('heal'))
    if any((target.parent / f'{kind}-{head}.json').is_file()
           for kind in ('escalated', 'blocked')):
        return
    state, checks = ci_state(pull.get('statusCheckRollup'))
    if state != 'green':
        return note(f'#{number}: CI {state}')
    if pull.get('reviewDecision') == 'CHANGES_REQUESTED' or human_veto(
            pages(f'repos/{REPOSITORY}/pulls/{number}/reviews?per_page=100')):
        return note(f'#{number}: human changes requested')
    if compare_limit_exceeded(pr_base, head):
        write_json(target.parent / f'blocked-{head}.json',
                   dict(schema=2, repository=REPOSITORY, pull_request=number, head=head,
                        base=pr_base, reason='diff exceeds the 300-file compare limit', at=iso(NOW)))
        notify(f'compare-limit-pr{number}-{head[:7]}',
               f'minion.town screen BLOCKED {URL}/pull/{number} (head {head[:11]}): '
               'the GitHub compare reached its 300-file response limit, so the screen cannot '
               'prove it inspected the complete diff. This is a correctness refusal, not a '
               'policy escalation; split the change or otherwise bring it below the limit.')
        return
    verdict = next(((panel, path, 'exact') for panel, path in heads if panel == head), None)
    if verdict is None and heads:
        fingerprint = patch_fingerprint(pr_base, head)
        verdict = next(((panel, path, 'rebase') for panel, path in heads
                        if fingerprint and patch_fingerprint(pr_base, panel) == fingerprint), None)
    if verdict is None:
        if in_flight:
            return note(f'#{number}: gauntlet in flight')
        gauntlet_base = f'kriscendobot-minion-town-pr{number}-screen-{head[:8]}-gauntlet'
        if not on_board(gauntlet_base) and not (JOURNAL / f'jobs/gauntlet/{gauntlet_base}.md').is_file():
            actions.append(dict(kind='gauntlet', base=gauntlet_base, url=f'{URL}/pull/{number}'))
        return note(f'#{number}: no panel verdict at this head')
    if pr_base != LIVE_BASE and not re.fullmatch(
            rf'{re.escape(LIVE_BASE)}-[0-9a-f]{{4,40}}', pr_base):
        return note(f'#{number}: stacked on {pr_base}; awaiting parent merge and weave onto {LIVE_BASE}')
    production = dict(deploy_run=None, heartbeat_at=None)
    if not heal:
        production, why = baseline()
        if production is None:
            return note(f'#{number}: {why}')
    write_json(target, dict(schema=2, repository=REPOSITORY, pull_request=number, head=head,
                            base=pr_base,
                            screened_at=iso(NOW), gauntlet=verdict[1], panel_head=verdict[0],
                            panel_match=verdict[2], ci=checks, heal=heal, **production))
    note(f'#{number}: screened at {head[:11]}')
    conductor(number, head, heal)


# --- post-merge validation ----------------------------------------------------------
def pause(value, reason):
    if value['status'] == 'active':
        value.update(status='paused', paused_by='proxy:screen', paused_at=iso(NOW), paused_reason=reason)


def failed(value, attested, reason, detail):
    merge = attested['merge_commit']
    pause(value, f'#{attested["pull_request"]} merge {merge[:11]}: {reason}')
    if merge not in value.setdefault('healing', []):
        value['healing'].append(merge)
    base = f'heal-minion-town-{merge[:7]}'
    if not on_board(base):
        actions.append(dict(kind='post', base=base, body=f'''role: fixer
delegation: {IDENTITY}
# Heal minion.town production after merge {merge}
Merge {merge} ({URL}/pull/{attested["pull_request"]}) broke production: {reason}.
{detail}
Restore production by the cheapest correct route: a forward-fix PR or a revert PR of
{merge}, against base main. Put this marker on its own line in the PR body:
<!-- garden-heal: {merge} -->
Open it with scripts/jobs/gardening/ensure-pr.sh and stage the ordinary gauntlet; the
proxy screens and merges a marked heal PR even while the delegation is paused. Never
push to main directly and never force-revert main.
'''))
    notify(f'paused-{merge[:7]}',
           f'minion.town screening PAUSED: merge {merge[:11]} of {URL}/pull/{attested["pull_request"]} '
           f'broke production ({reason}). {detail}\nHeal job {base} posted; the delegation '
           'resumes by itself once a later main deploy succeeds and the watchdog is ok.')


def track(value, open_heads):
    views = {}
    for path in sorted((JOURNAL / SCREENINGS).glob('*/*.json')):
        if path.name.startswith(('escalated-', 'blocked-')):
            continue
        attested = read_json(path)
        if attested.get('closed'):
            continue
        number = attested['pull_request']
        if number in open_heads:
            if open_heads[number] != attested['head']:
                attested.update(closed=iso(NOW), outcome='superseded')
                write_json(path, attested)
            continue
        if number not in views:
            views[number] = gh('pr', 'view', number, '-R', REPOSITORY, '--json',
                               'state,headRefOid,mergeCommit,mergedAt')
        view = views[number]
        if view['state'] == 'OPEN' and view['headRefOid'] == attested['head']:
            continue
        if view['state'] != 'MERGED' or view['headRefOid'] != attested['head']:
            attested.update(closed=iso(NOW), outcome='superseded' if view['state'] != 'CLOSED' else 'closed-unmerged')
            write_json(path, attested)
            continue
        attested.setdefault('merge_commit', (view.get('mergeCommit') or {}).get('oid'))
        attested.setdefault('merged_at', view.get('mergedAt') or iso(NOW))
        attested.setdefault('deploy', 'pending')
        runs = gh('run', 'list', '-R', REPOSITORY, '--workflow', 'deploy.yml', '--commit',
                  attested['merge_commit'], '--limit', '1',
                  '--json', 'databaseId,status,conclusion,url,createdAt,updatedAt')
        run = runs[0] if runs else None
        since_merge = (NOW - parse_time(attested['merged_at'])).total_seconds()
        if run is None:
            if since_merge > VALIDATION_WINDOW:
                attested.update(deploy='none', closed=iso(NOW), outcome='merged-no-deploy')
        elif run.get('status') == 'completed':
            attested.update(deploy_run=run['databaseId'], deploy_url=run.get('url'))
            if run.get('conclusion') != 'success':
                attested.update(deploy='failure', closed=iso(NOW), outcome='failed')
                failed(value, attested, f"deploy.yml {run.get('conclusion')}", f"Run: {run.get('url')}")
            else:
                attested['deploy'] = 'success'
                ok, beat = healthy_after(run['updatedAt'])
                late = (NOW - parse_time(run['updatedAt'])).total_seconds() > VALIDATION_WINDOW
                fresh_down = (beat is not None and beat.get('state') == 'down' and
                              parse_time(beat['at']) >= parse_time(run['updatedAt']))
                if ok:
                    attested.update(health='ok', closed=iso(NOW), outcome='validated')
                elif fresh_down or late:
                    attested.update(health='down', closed=iso(NOW), outcome='failed')
                    failed(value, attested, 'MCP watchdog down after a successful deploy',
                           f"Watchdog: {beat and beat.get('state')} {beat and beat.get('detail', '')}".strip())
        write_json(path, attested)


def resume(value):
    if value['status'] != 'paused' or value.get('paused_by') != 'proxy:screen':
        return
    run = latest_main_deploy()
    if not run or run.get('status') != 'completed' or run.get('conclusion') != 'success':
        return
    if parse_time(run['createdAt']) <= parse_time(value['paused_at']):
        return
    ok, _ = healthy_after(run['updatedAt'])
    if ok:
        for key in ('paused_by', 'paused_at', 'paused_reason'):
            value.pop(key, None)
        value.update(status='active', healing=[], resumed_at=iso(NOW))
        note(f"delegation auto-resumed after deploy run {run['databaseId']}")


def main():
    try:
        value = record(JOURNAL)
    except (ValueError, KeyError, TypeError, OSError) as error:
        print(json.dumps(dict(actions=[], notes=[f'inert: {error}'])))
        return
    before = json.dumps(value, sort_keys=True)
    pulls = gh('pr', 'list', '-R', REPOSITORY, '--state', 'open', '--limit', '1000',
               '--json', 'number,state,isDraft,baseRefName,headRefName,author,headRefOid,reviewDecision,statusCheckRollup,body')
    track(value, {pull['number']: pull['headRefOid'] for pull in pulls})
    resume(value)
    for pull in sorted(pulls, key=lambda item: item['number']):
        screen(value, pull)
    if json.dumps(value, sort_keys=True) != before:
        write_json(JOURNAL / CONFIGURATION, value)
    print(json.dumps(dict(actions=actions, notes=notes)))


if __name__ == '__main__':
    main()
