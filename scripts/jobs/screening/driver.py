#!/usr/bin/env python3
"""One screener tick over kriscendobot/minion.town (proxy pre-pass 1d, no LLM).

Reads GitHub metadata, CI rollups, diff paths, and journal records only; it never
feeds PR or comment text anywhere. Journal writes (attestations, escalation and
validation records, the delegation's pause/resume, maintainer notices) land in the
working tree; the shell wrapper commits them with one CAS push and then performs
the printed actions (job posts, gauntlet records, review requests). Every action
is keyed by a deterministic name, so a lost push or a re-tick repeats nothing.
"""
import json
import os
import subprocess
import sys
from pathlib import Path

from policy import (AUTHOR, BASE, CONFIGURATION, HEARTBEAT_MAX_AGE, IDENTITY, REPOSITORY,
                    SCREENINGS, VALIDATION_WINDOW, attestation_path, canonical_login,
                    heal_target, human_veto, iso, now, parse_time, path_escalates, read_json,
                    record, section_escalates, write_json, digest)

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


def gauntlets(number):
    """(in_flight, [panel heads of completed feature gauntlets])."""
    live = JOURNAL / 'jobs/gauntlet'
    in_flight = live.is_dir() and any(matches(fields(path), number) for path in live.glob('*.md'))
    heads = []
    for stem, path in TADA.items():
        if 'gauntlet' in stem:
            values = fields(path)
            if (values.get('gauntlet-status') == 'complete' and matches(values, number)
                    and len(values.get('panel_head', '')) == 40):
                heads.append((values['panel_head'], str(path.relative_to(JOURNAL))))
    return in_flight, heads


# --- GitHub reads, cached per tick ----------------------------------------------
COMPARISONS = {}


def compare(head):
    if head not in COMPARISONS:
        COMPARISONS[head] = gh('api', f'repos/{REPOSITORY}/compare/{BASE}...{head}')
    return COMPARISONS[head]


def patch_fingerprint(head):
    """The PR's own change (merge-base..head) with hunk offsets erased, or None."""
    items = []
    for item in compare(head).get('files', []):
        if 'patch' not in item and item.get('changes', 0):
            return None
        patch = '\n'.join(line for line in item.get('patch', '').splitlines() if not line.startswith('@@'))
        items.append([item['filename'], item.get('status'), item.get('previous_filename'), patch])
    return digest(json.dumps(sorted(items, key=str)).encode())


def content(path, ref):
    try:
        return gh('api', '-H', 'Accept: application/vnd.github.raw+json',
                  f'repos/{REPOSITORY}/contents/{path}?ref={ref}', raw=True)
    except subprocess.CalledProcessError:
        return None


def escalations(value, head):
    comparison = compare(head)
    files = comparison.get('files', [])
    if len(files) >= 300:
        return ['(diff exceeds the 300-file compare limit)']
    hits = []
    for item in files:
        for path in filter(None, (item['filename'], item.get('previous_filename'))):
            if path_escalates(value, path):
                hits.append(path)
        for section in value['escalate_sections']:
            if item['filename'] == section['path']:
                base = comparison.get('merge_base_commit', {}).get('sha')
                if section_escalates(section, item.get('patch'), content(section['path'], base) if base else None,
                                     content(section['path'], head)):
                    hits.append(f"{section['path']} § {section['heading'].lstrip('# ')}")
    return sorted(set(hits))


LATEST = {}


def latest_main_deploy():
    if 'run' not in LATEST:
        runs = gh('run', 'list', '-R', REPOSITORY, '--workflow', 'deploy.yml', '--branch', BASE,
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
    number, head = pull['number'], pull['headRefOid']
    if (pull.get('baseRefName') != BASE or canonical_login(pull['author']['login']) != AUTHOR
            or pull.get('isDraft') or pull.get('state', 'OPEN') != 'OPEN'):
        return
    heal = heal_target(pull.get('body'))
    heal = heal if heal in value.get('healing', []) else None
    if value['status'] != 'active' and not heal:
        return note(f'#{number}: delegation paused')
    target = attestation_path(JOURNAL, number, head)
    if target.is_file():
        return conductor(number, head, read_json(target).get('heal'))
    if (target.parent / f'escalated-{head}.json').is_file():
        return
    state, checks = ci_state(pull.get('statusCheckRollup'))
    if state != 'green':
        return note(f'#{number}: CI {state}')
    if pull.get('reviewDecision') == 'CHANGES_REQUESTED' or human_veto(
            pages(f'repos/{REPOSITORY}/pulls/{number}/reviews?per_page=100')):
        return note(f'#{number}: human changes requested')
    hits = escalations(value, head)
    if hits:
        write_json(target.parent / f'escalated-{head}.json',
                   dict(schema=1, repository=REPOSITORY, pull_request=number, head=head,
                        paths=hits, at=iso(NOW)))
        notify(f'escalated-pr{number}-{head[:7]}',
               f'minion.town screen ESCALATED {URL}/pull/{number} (head {head[:11]}): it touches '
               f'{", ".join(hits)}, which the delegation reserves for the maintainer. It will not '
               'be merged by the proxy; review it (an APPROVED review triggers the ordinary merge).')
        actions.append(dict(kind='request-review', number=number))
        return
    in_flight, heads = gauntlets(number)
    verdict = next(((panel, path, 'exact') for panel, path in heads if panel == head), None)
    if verdict is None and heads:
        fingerprint = patch_fingerprint(head)
        verdict = next(((panel, path, 'rebase') for panel, path in heads
                        if fingerprint and patch_fingerprint(panel) == fingerprint), None)
    if verdict is None:
        if in_flight:
            return note(f'#{number}: gauntlet in flight')
        base = f'kriscendobot-minion-town-pr{number}-screen-{head[:8]}-gauntlet'
        if not on_board(base) and not (JOURNAL / f'jobs/gauntlet/{base}.md').is_file():
            actions.append(dict(kind='gauntlet', base=base, url=f'{URL}/pull/{number}'))
        return note(f'#{number}: no panel verdict at this head')
    production = dict(deploy_run=None, heartbeat_at=None)
    if not heal:
        production, why = baseline()
        if production is None:
            return note(f'#{number}: {why}')
    write_json(target, dict(schema=1, repository=REPOSITORY, pull_request=number, head=head,
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
        if path.name.startswith('escalated-'):
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
    pulls = gh('pr', 'list', '-R', REPOSITORY, '--state', 'open', '--base', BASE, '--limit', '100',
               '--json', 'number,state,isDraft,baseRefName,author,headRefOid,reviewDecision,statusCheckRollup,body')
    track(value, {pull['number']: pull['headRefOid'] for pull in pulls})
    resume(value)
    for pull in sorted(pulls, key=lambda item: item['number']):
        screen(value, pull)
    if json.dumps(value, sort_keys=True) != before:
        write_json(JOURNAL / CONFIGURATION, value)
    print(json.dumps(dict(actions=actions, notes=notes)))


if __name__ == '__main__':
    main()
