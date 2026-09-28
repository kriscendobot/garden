#!/usr/bin/env python3
"""Re-derive coverage from complete sweep artifacts and the enforced Git floor."""
import collections
import json
import re
import subprocess
import tempfile
from pathlib import Path

from policy import digest, fields, read_json, require


def git(worktree, *arguments):
    return subprocess.check_output(['git', '-C', str(worktree), *arguments])


def covered_bytes(paths):
    return ''.join(path + '\n' for path in sorted(paths, key=lambda value: value.encode())).encode()


def sweep(path, head):
    report = read_json(path)
    provenance = report['provenance']
    require(provenance['endo_sha'] == head and provenance['scope'] == 'whole-corpus'
            and provenance['completion'] == 'complete' and provenance['corpus_verified'] is True
            and provenance['oracle_mode'] == 'on' and provenance['ses_mode'] == 'none',
            'sweep is incomplete, not oracle locked, or not at the required head')
    require(re.fullmatch('[0-9a-f]{40}', provenance['test262_sha']), 'corpus pin missing')
    cases = report['cases']
    require(cases and len({case['path'] for case in cases}) == len(cases), 'duplicate or absent cases')
    counts = collections.Counter(case['category'] for case in cases)
    require(report['summary']['total'] == len(cases), 'sweep total mismatch')
    require(all(report['summary']['by_category'].get(key) == value for key, value in counts.items()),
            'sweep category totals mismatch')
    for case in cases:
        require((case['category'] == 'covered') == (case['outcome'] == 'covered'),
                'covered classification disagrees with outcome')
    return report, {case['path'] for case in cases if case['category'] == 'covered'}


def added_lines(worktree, base, head):
    patch = git(worktree, 'diff', '--no-ext-diff', '--no-renames', '--unified=0', base, head).decode()
    result = {}
    path = None
    line_number = 0
    for line in patch.splitlines():
        if line.startswith('+++ b/'):
            path = line[6:]
        elif line.startswith('@@ '):
            line_number = int(re.search(r'\+(\d+)', line).group(1))
        elif line.startswith('+') and path:
            result.setdefault(path, {})[line_number] = line[1:]
            line_number += 1
        elif line.startswith(' '):
            line_number += 1
    return result


def code_coverage(worktree, base, head, evidence):
    require(evidence['head'] == head, 'new-code coverage has stale head')
    require(evidence['command'] and evidence['test_log'], 'coverage command/log missing')
    require(evidence['exit_code'] == 0, 'coverage tests failed')
    require(Path(evidence['test_log']).is_file(), 'coverage test log missing')
    worktree = Path(worktree).resolve()
    coverage = {}
    current = None
    for line in Path(evidence['lcov']).read_text().splitlines():
        if line.startswith('SF:'):
            source = Path(line[3:])
            if source.is_absolute():
                source = source.relative_to(worktree)
            current = str(source)
        elif line.startswith('DA:'):
            line_number, count, *_ = line[3:].split(',')
            coverage[current, int(line_number)] = int(count)
    exclusions = {(item['path'], item['line']): item['reason']
                  for item in evidence.get('non_executable', [])}
    require(all(reason.strip() for reason in exclusions.values()), 'unexplained non-executable line')
    changed = added_lines(worktree, base, head)
    examined = 0
    for path, lines in changed.items():
        # Other changed languages require an explicit coverage adapter, not a silent exemption.
        if Path(path).suffix in ('.md', '.txt', '.json', '.lock'):
            continue
        require(Path(path).suffix == '.rs', f'new-code coverage adapter required: {path}')
        for line_number, text in lines.items():
            if not text.strip() or text.lstrip().startswith('//') or re.fullmatch(r'[\s{}();,]+', text):
                continue
            if (path, line_number) in exclusions:
                require((path, line_number) not in coverage, 'executable line cannot be excluded')
                continue
            require(coverage.get((path, line_number), 0) > 0,
                    f'new code not covered: {path}:{line_number}')
            examined += 1
    require(examined > 0, 'no new executable code was measured')
    return examined


def comparable_floor(manifest, state, floor_bytes):
    gate = Path(__file__).resolve().parents[1] / 'ironhorse-test262-ratchet-gate.sh'
    worktree = manifest['worktree']
    floor = state['floor']
    with tempfile.TemporaryDirectory(prefix='ironhorse-ratchet-comparison-') as temporary:
        directory = Path(temporary)
        pinned = directory / 'enforced'
        pinned.mkdir()
        if 'pin' in floor:
            (pinned / 'pin.json').write_text(json.dumps(floor['pin']))
            (pinned / 'covered.txt').write_bytes(floor_bytes)
        else:
            baseline = directory / 'baseline'
            baseline.mkdir()
            baseline_path = str(Path(floor['path']).with_name('baseline.json'))
            (baseline / 'baseline.json').write_bytes(git(worktree, 'show', f"{floor['revision']}:{baseline_path}"))
            (baseline / 'covered.txt').write_bytes(floor_bytes)
            subprocess.run([str(gate), 'pin', '--from-baseline', str(baseline),
                            '--project-git', worktree, '--out', str(pinned)],
                           check=True, capture_output=True, text=True)
        comparisons = []
        for label, pin_directory in (('enforced floor', pinned), ('branch point', directory / 'before')):
            if label == 'branch point':
                subprocess.run([str(gate), 'pin', '--from-report', manifest['before_report'],
                                '--project-git', worktree, '--out', str(pin_directory)],
                               check=True, capture_output=True, text=True)
            pin = read_json(pin_directory / 'pin.json')
            require(all(value != 'MISSING' for value in pin['classifier']['blobs'].values()),
                    'classifier source missing from pinned commit')
            result = subprocess.run([str(gate), 'check', '--pin', str(pin_directory),
                                     '--report', manifest['after_report'], '--project-git', worktree,
                                     '--require-growth'], capture_output=True, text=True)
            comparison = json.loads(result.stdout)
            require(result.returncode == 0 and comparison['verdict'] == 'pass',
                    f"{label} comparison {comparison['verdict']}: {comparison.get('reasons')}")
            comparisons.append(comparison)
        next_pin = directory / 'next'
        subprocess.run([str(gate), 'pin', '--from-report', manifest['after_report'],
                        '--project-git', worktree, '--out', str(next_pin)],
                       check=True, capture_output=True, text=True)
        return comparisons, read_json(next_pin / 'pin.json')


def verify(manifest, state, journal, head, number):
    worktree = manifest['worktree']
    require(git(worktree, 'rev-parse', 'HEAD').decode().strip() == head, 'checkout head mismatch')
    require(not git(worktree, 'status', '--porcelain', '--untracked-files=no').strip(),
            'tracked changes invalidate coverage provenance')
    branch_point = state['branch_point']
    require(subprocess.call(['git', '-C', worktree, 'merge-base', '--is-ancestor', branch_point, head]) == 0,
            'branch point is not an ancestor')
    before, before_covered = sweep(manifest['before_report'], branch_point)
    after, after_covered = sweep(manifest['after_report'], head)
    require(after['provenance']['test262_sha'] == state['corpus'], 'corpus differs from enforced pin')
    for key in ('test262_sha', 'oracle', 'runner', 'ses_mode'):
        require(before['provenance'][key] == after['provenance'][key], f'sweep identity changed: {key}')
    require({case['path'] for case in before['cases']} == {case['path'] for case in after['cases']},
            'corpus case set changed')
    floor = state['floor']
    floor_bytes = git(worktree, 'show', f"{floor['revision']}:{floor['path']}")
    require(digest(floor_bytes) == floor['sha256'], 'enforced floor changed')
    comparisons, next_pin = comparable_floor(manifest, state, floor_bytes)
    floor_covered = set(floor_bytes.decode().splitlines())
    required = floor_covered | before_covered
    lost = required - after_covered
    gained = after_covered - required
    require(not lost, f'coverage lost {len(lost)} enforced/branch-point cases; first: {sorted(lost)[:5]}')
    require(gained, 'whole-corpus coverage did not strictly grow')
    require(after['summary']['by_category'].get('ironhorse-failure', 0) <=
            before['summary']['by_category'].get('ironhorse-failure', 0), 'failure count grew')
    final_bytes = covered_bytes(after_covered)
    require(Path(manifest['covered']).read_bytes() == final_bytes, 'covered.txt differs from report-derived set')
    refreshed_floor = manifest['refreshed_floor']
    require(re.fullmatch(r'rust/engine/ironhorse-262/baseline/refresh-\d{8}/covered.txt', refreshed_floor),
            'refreshed floor path is not baseline/refresh-<date>/covered.txt')
    require(git(worktree, 'show', f'{head}:{refreshed_floor}') == final_bytes,
            'PR does not commit the refreshed floor')
    terminal = Path(journal) / manifest['gauntlet_report']
    panel = Path(journal) / manifest['panel_report']
    require(str(terminal.relative_to(journal)).startswith('jobs/tada/'), 'invalid gauntlet report path')
    require(fields(terminal.read_text()).get('gauntlet-status') == 'complete', 'gauntlet not complete')
    require(terminal.stem == state['gauntlet'], 'gauntlet does not belong to this crank')
    require(str(panel.relative_to(journal)).startswith(f'panel-runs/endojs-endo-but-for-bots-{number}/'),
            'panel belongs to another PR')
    panel_fields = fields(panel.read_text())
    require(panel_fields.get('reviewed_head') == head and panel_fields.get('disposition') == 'passed',
            'panel is stale or has outstanding must-fix')
    dual_run = manifest['dual_run']
    require(dual_run['head'] == head and dual_run['exit_code'] == 0 and dual_run['command'],
            'dual-run regressions absent, failed, or stale')
    require(Path(dual_run['log']).stat().st_size > 0, 'dual-run regression log missing')
    measured = code_coverage(worktree, branch_point, head, manifest['new_code'])
    reasons = collections.Counter(case['reason'] for case in after['cases']
                                  if case['reason'].startswith('ironhorse-aborted:'))
    queue = [{'reason': reason, 'count': count} for reason, count in
             sorted(reasons.items(), key=lambda item: (-item[1], item[0]))]
    hashes = {key: digest(Path(manifest[key]).read_bytes())
              for key in ('before_report', 'after_report', 'covered')}
    hashes.update(dual_run=digest(Path(dual_run['log']).read_bytes()), lcov=digest(Path(manifest['new_code']['lcov']).read_bytes()),
                  test_log=digest(Path(manifest['new_code']['test_log']).read_bytes()),
                  gauntlet=digest(terminal.read_bytes()), panel=digest(panel.read_bytes()))
    return dict(floor_count=len(required), gained=len(gained), lost=0,
                gauntlet_complete=True, new_code_covered=True, measured_new_lines=measured,
                floor_sha256=digest(floor_bytes), covered_sha256=digest(final_bytes),
                evidence_sha256=digest(json.dumps(hashes, sort_keys=True).encode()), artifact_hashes=hashes,
                next_floor=dict(revision=head, path=refreshed_floor, sha256=digest(final_bytes), pin=next_pin),
                comparisons=comparisons, queue=queue)
