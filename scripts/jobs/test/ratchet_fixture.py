"""Hermetic journal evidence shared by Ironhorse policy and merge tests."""
import gzip
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'ratchet'))
import policy

HEAD = 'a' * 40
WATCHER = 'ironhorse-test262-press-20260928-220000'


def write_json(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(content))


def seed(journal):
    authorization = journal / policy.AUTHORIZATION
    authorization.parent.mkdir(parents=True)
    authorization.write_text('fixture authorization')
    write_json(journal / policy.CONFIGURATION,
               dict(schema=1, status='active', authorized_by='kriskowal',
                    authorization=policy.AUTHORIZATION, authorization_sha256=policy.digest(authorization.read_bytes()),
                    repository=policy.REPOSITORY, base='llm', author='kriscendobot', marker=policy.MARKER))
    (journal / 'maintainers').mkdir()
    (journal / 'maintainers/allowlist').write_text('kriskowal\nerights\n')
    job = journal / f'jobs/doin/{WATCHER}.md'
    job.parent.mkdir(parents=True)
    job.write_text(policy.TEMPLATE.read_text() + '\n---\nclaim:\n  model: gpt-6-astra\n')
    archive = journal / f'ratchets/{policy.IDENTITY}/attestations/17/{HEAD}'
    archive.mkdir(parents=True)
    (archive / 'watcher.md').write_bytes(job.read_bytes())
    hashes = {}
    for key in ('before_report', 'after_report', 'covered', 'lcov', 'test_log', 'gauntlet', 'panel', 'dual_run'):
        content = key.encode()
        hashes[key] = policy.digest(content)
        (archive / f'{key}.gz').write_bytes(gzip.compress(content))
    write_json(archive.with_suffix('.json'),
               dict(schema=1, repository=policy.REPOSITORY, pull_request=17, head=HEAD,
                    gauntlet_complete=True, new_code_covered=True, lost=0, gained=1, floor_count=3,
                    watcher_tier='mentat', watcher_job=WATCHER, watcher_model='gpt-6-astra',
                    watcher_sha256=policy.digest(job.read_bytes()), artifact_hashes=hashes,
                    evidence_sha256=policy.digest(json.dumps(hashes, sort_keys=True).encode()),
                    floor_sha256='b'*64, covered_sha256=hashes['covered']))
    write_json(journal / policy.STATE, dict(schema=1, crank=3, crank_date='20260928', floor={}, queue=[], actions={},
                                          branch_point='b'*40, last_progress='2026-09-28T20:00:00+00:00'))


def metadata():
    return dict(baseRefName='llm', author={'login': 'kriscendobot'}, body=policy.MARKER,
                state='OPEN', headRefOid=HEAD, isDraft=False, reviewDecision='')
