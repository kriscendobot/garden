#!/usr/bin/env python3
"""Closed minion.town PR-screening delegation; journal push access is the trust boundary.

Design: designs/minion-town-pr-screening.md. The record shape mirrors the Ironhorse
ratchet delegation (scripts/jobs/ratchet/policy.py): a journal message entry holds
the maintainer's words, and config/delegations/minion-town-pr-screening binds that
entry's SHA-256 to a closed scope. Anything missing, changed, paused, or revoked
denies the delegation, which falls back to ordinary maintainer approval.
"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

IDENTITY = 'minion-town-pr-screening'
REPOSITORY = 'kriscendobot/minion.town'
BASE = '*'
LIVE_BASE = 'main'
AUTHOR = 'kriscendobot'
AUTHORIZATION = 'entries/2026/10/07/203746Z-message-gardener-a253b1.md'
CONFIGURATION = f'config/delegations/{IDENTITY}'
TOMBSTONE = f'{CONFIGURATION}.revoked'
SCREENINGS = 'screenings/kriscendobot-minion.town'
HEAL_MARKER = re.compile(r'^<!-- garden-heal: ([0-9a-f]{40}) -->$', re.M)
PROBE_MARKER = re.compile(
    r'gap[- ]revealing|<!--\s*garden-probe\s*-->|^\s*(?:kind|verb):\s*probe\s*$',
    re.I | re.M)
# The heartbeat ticks every 10 minutes; "fresh" is under three ticks.
HEARTBEAT_MAX_AGE = 1800
# How long a merged PR has for its deploy and a healthy watchdog tick.
VALIDATION_WINDOW = 1800

ESCALATE_PATHS = []
ESCALATE_EXCEPT = []
ESCALATE_SECTIONS = []

AUTHORIZATION_TEXT = f'''---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-07T20:37:52Z
---
# Maintainer directive: invert review on minion.town (2026-10-07, liaison session)

Recorded by the liaison from the maintainer's own words in a liaison session on
2026-10-07. Journal push access is the authority boundary; this entry is the
authorization record the delegation binds to.

The maintainer (kriskowal) said:

> There are a lot of open pull requests on minion.town waiting for maintainer review. I
> would like to turn that on its head. I am interested in reviewing minion.town as a whole
> when the minion.town and claude-on-minion.town objectives are satisfied and validated
> automatically in production. I can provide corrections later. Please arrange for
> supervisors for these arcs to carry these pull requests through review as needed to make
> progress on the objectives. I will continue to review all changes to endo necessitated by
> work on minion.town.

Asked how far the supervisors' authority should go, with the option of keeping the
existing escalation paths offered and recommended, the maintainer chose: **"Everything,
no escalations."** Asked where the minion.town objectives come from, the maintainer said
the arc issues already exist: https://github.com/kriscendobot/garden/issues/58
(minion.town) and https://github.com/kriscendobot/garden/issues/89 (claude-on-minion.town).

## Scope this authorizes

- Repository `kriscendobot/minion.town` only. Supervisors of the two arcs may carry its
  pull requests through review (gauntlet, fixes, un-draft, weave and restack, merge) as
  needed to advance the arc objectives, including draft PRs and PRs on frozen/stacked
  bases, and with NO path or section escalation to the maintainer (workflows, deploy
  scripts, and CD docs are included).
- Post-merge production validation, pause-and-heal, and the maintainer's pause/revoke
  controls remain in force; they are safety mechanisms, not escalations.

## Not authorized

- Any change to `endojs/endo-but-for-bots` or any other repository: the maintainer keeps
  reviewing every endo change that minion.town work necessitates.
- Upstream `agoric/agoric-sdk` interaction, the ferry, or any identity switch.
- Gap-revealing probes stay draft by their own contract.
'''


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(Path(path).read_text())


def write_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def digest(content):
    return hashlib.sha256(content).hexdigest()


def now():
    return datetime.datetime.now(datetime.timezone.utc)


def iso(moment):
    return moment.strftime('%Y-%m-%dT%H:%M:%SZ')


def parse_time(value):
    return datetime.datetime.fromisoformat(value.replace('Z', '+00:00'))


def record(journal):
    """The verified record, whatever its status; raises when it grants nothing."""
    journal = Path(journal)
    require(not (journal / TOMBSTONE).exists(), 'delegation revoked')
    value = read_json(journal / CONFIGURATION)
    expected = dict(schema=2, authorized_by='kriskowal', authorization=AUTHORIZATION,
                    repository=REPOSITORY, base=BASE, author=AUTHOR)
    require(all(value.get(key) == item for key, item in expected.items()),
            'delegation malformed or outside scope')
    require(value.get('status') in ('active', 'paused'), 'delegation status is not active or paused')
    require(value.get('authorization_sha256') == digest((journal / AUTHORIZATION).read_bytes()),
            'authorization entry missing or changed')
    for key, expected_items in (('escalate_paths', ESCALATE_PATHS),
                                ('escalate_except', ESCALATE_EXCEPT),
                                ('escalate_sections', ESCALATE_SECTIONS)):
        require(value.get(key) == expected_items, f'{key} must be empty')
    return value


def status(journal):
    """'active', 'paused', or 'denied: <reason>' — never raises."""
    try:
        return record(journal)['status']
    except (ValueError, KeyError, TypeError, OSError) as error:
        return f'denied: {error}'


def active(journal):
    value = record(journal)
    require(value['status'] == 'active', 'delegation paused')
    return value


def canonical_login(login):
    return re.sub(r'\[bot\]$', '', re.sub(r'^app/', '', (login or '').lower()))


def human_veto(reviews):
    """True when any human's latest effective review is CHANGES_REQUESTED."""
    effective = {}
    for review in sorted(reviews, key=lambda item: item['id']):
        user = review.get('user') or {}
        login = canonical_login(user.get('login'))
        if user.get('type') == 'Bot' or login == AUTHOR:
            continue
        if review.get('state') in ('APPROVED', 'CHANGES_REQUESTED', 'DISMISSED'):
            effective[login] = review['state']
    return any(state == 'CHANGES_REQUESTED' for state in effective.values())


def heal_target(body):
    match = HEAL_MARKER.search(body or '')
    return match.group(1) if match else None


def probe_body(body):
    return bool(PROBE_MARKER.search(body or ''))


def attestation_path(journal, number, head):
    return Path(journal) / SCREENINGS / str(int(number)) / f'{head}.json'


def scope(metadata):
    require(isinstance(metadata.get('baseRefName'), str) and metadata['baseRefName'],
            'base unreadable')
    require(canonical_login(metadata['author']['login']) == AUTHOR, 'wrong author')
    require(re.fullmatch(r'[0-9a-f]{40}', metadata['headRefOid']), 'head unreadable')
    require(metadata.get('isDraft') is False, 'PR is draft')
    require(not probe_body(metadata.get('body')), 'gap-revealing probe')


def merge_gate(journal, repository, number, head, metadata, reviews):
    """Conductor boundary: every check is re-read at the post-rebase head."""
    require(repository == REPOSITORY, 'outside screening delegation')
    value = record(journal)
    scope(metadata)
    require(metadata['state'] == 'OPEN', 'PR is not open')
    require(metadata['isDraft'] is False, 'PR is draft')
    require(metadata['baseRefName'] == LIVE_BASE,
            'stacked PR must be woven onto the live base')
    require(metadata['headRefOid'] == head, 'head changed')
    require(metadata.get('reviewDecision') != 'CHANGES_REQUESTED', 'changes requested')
    require(isinstance(reviews, list) and all(isinstance(page, list) for page in reviews),
            'reviews unreadable')
    require(not human_veto([item for page in reviews for item in page]), 'human changes requested')
    path = attestation_path(journal, number, head)
    require(path.is_file(), 'awaiting re-screen')
    attested = read_json(path)
    require(attested.get('schema') == 2 and attested.get('repository') == REPOSITORY and
            attested.get('pull_request') == int(number) and attested.get('head') == head,
            'attestation does not cover this head')
    if value['status'] != 'active':
        heal = heal_target(metadata.get('body'))
        require(heal is not None and heal in value.get('healing', []) and attested.get('heal') == heal,
                'delegation paused')
    return attested


def main():
    command, journal, *arguments = sys.argv[1:]
    if command == 'status':
        print(status(journal))
    elif command == 'scope':
        repository, metadata = arguments
        require(repository == REPOSITORY, 'outside screening delegation')
        record(journal)
        scope(read_json(metadata))
    elif command == 'merge':
        repository, number, head, metadata, reviews = arguments
        merge_gate(journal, repository, number, head, read_json(metadata), read_json(reviews))
    else:
        raise ValueError('unknown policy command')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, TypeError, OSError) as error:
        print(f'merge blocked: {error}', file=sys.stderr)
        sys.exit(1)
