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
BASE = 'main'
AUTHOR = 'kriscendobot'
REVIEW_URL = ('https://github.com/kriscendobot/minion.town/pull/139'
              '#pullrequestreview-5358570484')
AUTHORIZATION = 'entries/2026/09/29/205400Z-message-gardener-mtpr139.md'
CONFIGURATION = f'config/delegations/{IDENTITY}'
TOMBSTONE = f'{CONFIGURATION}.revoked'
SCREENINGS = 'screenings/kriscendobot-minion.town'
HEAL_MARKER = re.compile(r'^<!-- garden-heal: ([0-9a-f]{40}) -->$', re.M)
# The heartbeat ticks every 10 minutes; "fresh" is under three ticks.
HEARTBEAT_MAX_AGE = 1800
# How long a merged PR has for its deploy and a healthy watchdog tick.
VALIDATION_WINDOW = 1800

# Derived from the repository at build time (2026-09-29): .github/workflows/deploy.yml
# runs exactly the scripts in ESCALATE_EXCEPT; every other deploy/aws/scripts/ file
# is a one-time provisioning or operator script that DEPLOYMENT.md reserves as a
# deliberate maintainer act (IAM, Cognito IdPs, DynamoDB tables, secret creates,
# deploy-cd-iam.mjs). Workflows change what CD itself may do.
ESCALATE_PATHS = ['.github/workflows/**', 'deploy/aws/scripts/**']
ESCALATE_EXCEPT = [f'deploy/aws/scripts/{name}' for name in (
    'common.sh', 'deploy-endo-daemon.sh', 'deploy-app.sh', 'deploy-endo-gateway.sh',
    'deploy-git-remote.sh', 'deploy-oauth2-proxy.sh', 'deploy-caddy-route53.sh',
    'deploy-caddy.sh', 'deploy-www.sh')]
ESCALATE_SECTIONS = [dict(path='DEPLOYMENT.md', heading='## Continuous deployment (GitHub Actions)')]

AUTHORIZATION_TEXT = f'''---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-29T20:54:00Z
---
# Maintainer authorization: the proxy screens and merges kriscendobot/minion.town PRs

Authorized by: kriskowal (maintainer), APPROVED review on
{REVIEW_URL}
2026-09-29.

Maintainer's words: "This is beneath maintainer attention. Please arrange for the
proxy or a mentat supervisor to screen minion.town pull requests. The purpose of
minion.town is to validate in production and to get to a point where the garden
can supervise and self-heal the production system."

Scope (designs/minion-town-pr-screening.md; the implementation must not widen it):
- Repository kriscendobot/minion.town, base `main`, author kriscendobot only.
- The proxy's deterministic screen (no LLM) substitutes an exact-head attestation
  for the per-PR maintainer APPROVED signature. It never overrides CI freshness or
  any human CHANGES_REQUESTED review.
- Provisioning scripts, workflows, and the DEPLOYMENT.md continuous-deployment
  section escalate to the maintainer instead of merging.
- A failed post-merge deploy or a down MCP watchdog pauses the delegation and
  posts a heal job. `scripts/jobs/minion-town-screening.sh pause|revoke` stops it.
- Delegation record: {CONFIGURATION}.
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
    expected = dict(schema=1, authorized_by='kriskowal', authorization=AUTHORIZATION,
                    repository=REPOSITORY, base=BASE, author=AUTHOR)
    require(all(value.get(key) == item for key, item in expected.items()),
            'delegation malformed or outside scope')
    require(value.get('status') in ('active', 'paused'), 'delegation status is not active or paused')
    require(value.get('authorization_sha256') == digest((journal / AUTHORIZATION).read_bytes()),
            'authorization entry missing or changed')
    for key in ('escalate_paths', 'escalate_except', 'escalate_sections'):
        require(isinstance(value.get(key), list), f'{key} unreadable')
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


def glob_regex(pattern):
    out = ''
    index = 0
    while index < len(pattern):
        if pattern.startswith('**/', index):
            out += '(?:.*/)?'; index += 3
        elif pattern.startswith('**', index):
            out += '.*'; index += 2
        elif pattern[index] == '*':
            out += '[^/]*'; index += 1
        elif pattern[index] == '?':
            out += '[^/]'; index += 1
        else:
            out += re.escape(pattern[index]); index += 1
    return re.compile(out + r'\Z')


def path_escalates(value, path):
    return (any(glob_regex(item).match(path) for item in value['escalate_paths']) and
            not any(glob_regex(item).match(path) for item in value['escalate_except']))


def section_range(text, heading):
    """[first, last] 1-based lines of a Markdown section, or None when absent."""
    lines = text.splitlines()
    level = len(heading) - len(heading.lstrip('#'))
    for index, line in enumerate(lines):
        if line.strip() == heading:
            end = len(lines)
            for later in range(index + 1, len(lines)):
                match = re.match(r'^(#+)\s', lines[later])
                if match and len(match.group(1)) <= level:
                    end = later
                    break
            return index + 1, end
    return None


def hunks(patch):
    """(old_start, old_count, new_start, new_count) for each hunk of a unified patch."""
    found = []
    for match in re.finditer(r'^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@', patch, re.M):
        old, old_count, new, new_count = match.groups()
        found.append((int(old), int(old_count or 1), int(new), int(new_count or 1)))
    return found


def overlaps(span, start, count):
    if span is None:
        return False
    first, last = span
    return start <= last and start + max(count, 1) - 1 >= first


def section_escalates(item, patch, base_text, head_text):
    """A hunk touching the named section on either side escalates; unreadable fails closed."""
    if patch is None or base_text is None or head_text is None:
        return True
    old_span = section_range(base_text, item['heading'])
    new_span = section_range(head_text, item['heading'])
    return any(overlaps(old_span, old, old_count) or overlaps(new_span, new, new_count)
               for old, old_count, new, new_count in hunks(patch))


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


def attestation_path(journal, number, head):
    return Path(journal) / SCREENINGS / str(int(number)) / f'{head}.json'


def scope(metadata):
    require(metadata['baseRefName'] == BASE, 'wrong base')
    require(canonical_login(metadata['author']['login']) == AUTHOR, 'wrong author')
    require(re.fullmatch(r'[0-9a-f]{40}', metadata['headRefOid']), 'head unreadable')


def merge_gate(journal, repository, number, head, metadata, reviews):
    """Conductor boundary: every check is re-read at the post-rebase head."""
    require(repository == REPOSITORY, 'outside screening delegation')
    value = record(journal)
    scope(metadata)
    require(metadata['state'] == 'OPEN', 'PR is not open')
    require(metadata['isDraft'] is False, 'PR is draft')
    require(metadata['headRefOid'] == head, 'head changed')
    require(metadata.get('reviewDecision') != 'CHANGES_REQUESTED', 'changes requested')
    require(isinstance(reviews, list) and all(isinstance(page, list) for page in reviews),
            'reviews unreadable')
    require(not human_veto([item for page in reviews for item in page]), 'human changes requested')
    path = attestation_path(journal, number, head)
    require(path.is_file(), 'awaiting re-screen')
    attested = read_json(path)
    require(attested.get('schema') == 1 and attested.get('repository') == REPOSITORY and
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
