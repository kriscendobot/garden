#!/usr/bin/env python3
"""Closed Ironhorse delegation policy; journal push access is the trust boundary."""
import gzip
import hashlib
import json
import re
import sys
from pathlib import Path

IDENTITY = 'ironhorse-test262-ratchet'
REPOSITORY = 'endojs/endo-but-for-bots'
MARKER = '<!-- garden-arc: ironhorse-test262-ratchet -->'
AUTHORIZATION = 'entries/2026/09/28/201230Z-message-gardener-aa49da.md'
CONFIGURATION = f'config/delegations/{IDENTITY}'
STATE = f'ratchets/{IDENTITY}/state.json'
TEMPLATE = Path(__file__).with_name('watcher.md')


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_json(path):
    return json.loads(Path(path).read_text())


def digest(content):
    return hashlib.sha256(content).hexdigest()


def active(journal):
    journal = Path(journal)
    record = read_json(journal / CONFIGURATION)
    require(not (journal / f'{CONFIGURATION}.revoked').exists(), 'delegation revoked')
    expected = dict(schema=1, status='active', authorized_by='kriskowal',
                    authorization=AUTHORIZATION, repository=REPOSITORY,
                    base='llm', author='kriscendobot', marker=MARKER)
    require(all(record.get(key) == value for key, value in expected.items()),
            'delegation absent, paused, malformed, or outside scope')
    require(record.get('authorization_sha256') == digest((journal / AUTHORIZATION).read_bytes()),
            'authorization entry missing or changed')
    return record


def fields(content):
    return dict(re.findall(r'^([a-z][a-z_-]*):[ \t]*([^\n]*)$', content, re.M))


def watcher_job(journal, path, base=None):
    active(journal)
    path = Path(path)
    require(re.fullmatch(r'ironhorse-ratchet-watch-\d{8}-\d{6}', base or path.stem),
            'not a scheduled ratchet watcher')
    content = path.read_text().split('\n---\nclaim:\n')[0].strip()
    metadata = fields(content)
    for key, value in dict(tier='mentat', dispatch='ratchet-delegated',
                           role='conductor', delegation=IDENTITY).items():
        require(metadata.get(key) == value, f'incorrect watcher {key}')
    for key in ('model', 'fallback-tier', 'fallback-model', 'provider'):
        require(not metadata.get(key), f'watcher may not override {key}')
    instructions = TEMPLATE.read_text().split('\n---\n', 1)[1].strip()
    # Budget admission may add frontmatter, but may never change the task.
    require(content.endswith(instructions), 'watcher instructions changed')
    prefix = content[:-len(instructions)].strip()
    require(prefix.startswith('---') and prefix.endswith('---') and
            all(line == '---' or not line.strip() or re.fullmatch(r'[a-z][a-z_-]*:.*', line)
                for line in prefix.splitlines()), 'unexpected watcher task prose')
    return metadata


def scope(repository, metadata, head=None):
    require(repository == REPOSITORY, 'wrong repository')
    require(metadata['baseRefName'] == 'llm', 'wrong base')
    require(metadata['author']['login'] == 'kriscendobot', 'wrong author')
    require(MARKER in metadata['body'].splitlines(), 'arc marker missing')
    require(metadata['state'] in ('OPEN', 'MERGED', 'CLOSED'), 'PR state unreadable')
    require(re.fullmatch(r'[0-9a-f]{40}', metadata['headRefOid']), 'head unreadable')
    if head:
        require(metadata['state'] == 'OPEN', 'PR is not open')
        require(metadata['headRefOid'] == head, 'head changed')
        require(metadata['isDraft'] is False, 'PR is draft')


def reviews_clear(journal, metadata, pages):
    require(metadata['reviewDecision'] in ('', 'APPROVED'), 'review veto or required review')
    maintainers = {line.split('#')[0].strip().lower()
                   for line in (Path(journal) / 'maintainers/allowlist').read_text().splitlines()}
    maintainers.discard('')
    require(maintainers, 'maintainer allowlist empty')
    require(isinstance(pages, list) and all(isinstance(page, list) for page in pages),
            'reviews unreadable')
    effective = {}
    for review in sorted([review for page in pages for review in page], key=lambda item: item['id']):
        login = review['user']['login'].lower()
        state = review['state']
        if login in maintainers and state in ('APPROVED', 'CHANGES_REQUESTED', 'DISMISSED'):
            effective[login] = state
    require(not any(state in ('CHANGES_REQUESTED', 'DISMISSED') for state in effective.values()),
            'maintainer changes requested or dismissal')


def attestation(journal, number, head):
    active(journal)
    record = read_json(Path(journal) / f'ratchets/{IDENTITY}/attestations/{number}/{head}.json')
    require(record['schema'] == 1 and record['repository'] == REPOSITORY and
            record['pull_request'] == int(number) and record['head'] == head,
            'attestation does not cover this head')
    require(record['gauntlet_complete'] is True and record['new_code_covered'] is True and
            record['lost'] == 0 and record['gained'] > 0 and record['floor_count'] > 0,
            'attestation criteria not met')
    require(record['watcher_tier'] == 'mentat', 'attestor is not mentat')
    base = record['watcher_job']
    require(re.fullmatch(r'ironhorse-ratchet-watch-\d{8}-\d{6}', base), 'invalid attestor')
    archive = Path(journal) / f'ratchets/{IDENTITY}/attestations/{number}/{head}'
    watcher = archive / 'watcher.md'
    require(digest(watcher.read_bytes()) == record['watcher_sha256'], 'watcher receipt changed')
    # The doin job disappears at completion, so retain its canonical task and
    # claim receipt with the attestation instead of depending on a freeform report.
    watcher_job(journal, watcher, base)
    inventory = Path(__file__).resolve().parents[1] / 'model-tier-inventory.tsv'
    require(any(record['watcher_model'] in line.split('\t') and 'mentat' in line.split('\t')
                for line in inventory.read_text().splitlines() if not line.startswith('#')),
            'watcher runtime model is not mentat')
    for key, expected in record['artifact_hashes'].items():
        require(re.fullmatch('[a-z_]+', key), 'invalid artifact key')
        require(digest(gzip.decompress((archive / f'{key}.gz').read_bytes())) == expected,
                f'archived evidence changed: {key}')
    require(set(record['artifact_hashes']) == {'before_report', 'after_report', 'covered', 'lcov',
                                              'test_log', 'gauntlet', 'panel', 'dual_run'}, 'evidence missing')
    require(record['evidence_sha256'] == digest(json.dumps(record['artifact_hashes'], sort_keys=True).encode()),
            'evidence digest mismatch')
    for key in ('evidence_sha256', 'floor_sha256', 'covered_sha256'):
        require(re.fullmatch('[0-9a-f]{64}', record[key]), f'invalid {key}')
    return record


def main():
    command, journal, *arguments = sys.argv[1:]
    if command == 'active':
        active(journal)
    elif command == 'job':
        watcher_job(journal, arguments[0])
    elif command == 'scope':
        active(journal)
        scope(arguments[0], read_json(arguments[1]))
    elif command == 'merge':
        repository, number, head, metadata, reviews = arguments
        scope(repository, read_json(metadata), head)
        reviews_clear(journal, read_json(metadata), read_json(reviews))
        attestation(journal, number, head)
    else:
        raise ValueError('unknown policy command')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, TypeError, OSError) as error:
        print(f'ratchet denied: {error}', file=sys.stderr)
        sys.exit(1)
