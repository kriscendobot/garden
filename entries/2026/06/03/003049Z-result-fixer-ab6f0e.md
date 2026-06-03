---
ts: 2026-06-03T00:30:49Z
kind: result
role: fixer
host: endolinbot
repo: kriskowal/garden
project: garden
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - entries/2026/06/03/001640Z-dispatch-liaison-ab6f0e.md
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4414266979
  - https://github.com/kriskowal/garden/pull/3#issuecomment-4608074313
---

# result: fixer — garden #3 pre-dispatch grep-gate pattern landed

Addressed kriskowal review `4414266979` (CHANGES_REQUESTED, 2026-06-02T23:07:15Z) on garden PR #3. The pre-dispatch grep-gate pattern lands as named: each "common hint" is a (`check.sh`, `prompt.md`) pair under `scripts/checks/<gate-name>/`; the runner `scripts/checks/run-all.sh` enumerates, runs each check, and on non-zero invokes `claude -p` with the gate's prompt. Step 0 of the driver's pre-CI gauntlet per the design doc update.

## Push

- New head SHA: `1ddf76235fc3181e29b8b8b54f9aa45f457a508a`.
- Pushed `HEAD:design/driver` (regular append, 4 commits ahead of `1c7e27a2`).

## Commits (4)

| SHA | Subject | Files |
| --- | --- | --- |
| `cbe89f4b` | feat(scripts/checks): pre-dispatch grep-gate harness + two example gates (#3) | 9 created (run-all.sh, README.md, two gate dirs each with check.sh + prompt.md + README.md, SKILL.md) |
| `594bede5` | test(checks): smoke tests for the two example gates + CI wiring (#3) | 4 created + 1 modified (`.github/workflows/driver-tests.yml`) |
| `f82fda05` | design(driver): pre-dispatch grep-gate as step 0 of pre-CI gauntlet (#3) | 1 modified (`designs/driver.md`) |
| `1ddf7623` | fix(scripts/checks): widen bench-engines-rename exclusion to the runner index and test (#3) | 1 modified (`scripts/checks/bench-engines-rename/check.sh`) |

Total: 14 paths touched.

## Gates landed (2)

### `bench-engines-rename`

- **Scope**: whole tree (literal-string match).
- **Sketch**: `git grep -nF '.bench-engines' -- ':!scripts/checks/bench-engines-rename/' ':!scripts/checks/README.md' ':!tests/checks/test_bench_engines_rename.sh'`.
- **Origin**: PR #387 second-attempt force-push reversal, per endojs/endo#3294 discussion `r3342643104`.
- **Carve-outs**: gate's own subdirectory; runner index that lists installed gates; matching smoke-test that fixtures the literal string. Anywhere else, the string is an offender.

### `double-space-sentence-separator`

- **Scope**: diff-scoped against `GATE_BASE_REF` (default: `git merge-base HEAD main`, fall back to `HEAD`).
- **Sketch** (per-file added-lines pass through awk):

  ```awk
  /^\+\+\+/ { next }
  /^\+/ {
    body = substr($0, 2)
    gsub(allow_regex, "_", body)         # strip allowlist tokens
    if (match(body, /\.  ?[A-Z]/)) print $0
  }
  ```

- **Allowlist**: `e.g.`, `i.e.`, `cf.`, `etc.`, `et al.`, `vs.`, `viz.`, `Mr.`, `Mrs.`, `Ms.`, `Dr.`, `Prof.`, `Sr.`, `Jr.`, `St.`, `No.`, `vol.`, `ch.`, `p.`, `pp.`, `Fig.`, `Eq.` (22 tokens). Tokens are stripped before regex test, so a line with both an allowlist token AND a real offender still fires.
- **File scope**: `*.md *.js *.mjs *.cjs *.ts *.tsx *.sh *.py`. JSON / YAML / TOML excluded (their `. ` occurrences are typically structured).
- **Diff scope rationale**: the maintainer's "we dispatch an agent only if these patterns are found in the diff, so that we do not relitigate salutations." Pre-existing prose untouched.

## Local test exit codes

| Suite | Result |
| --- | --- |
| `tests/checks/run.sh` (new) | **0** (24 / 24 PASS across 3 suites) |
| `tests/driver/run.sh` (regression) | **0** (27 / 27 PASS across 4 suites) |
| `scripts/checks/run-all.sh --dry-run --gate bench-engines-rename` | **0** (clean) |
| `scripts/checks/run-all.sh --dry-run --gate double-space-sentence-separator` | **1** (fires on 25 files; see below) |

## Shellcheck results

```
shellcheck -S warning \
  scripts/checks/run-all.sh \
  scripts/checks/bench-engines-rename/check.sh \
  scripts/checks/double-space-sentence-separator/check.sh \
  tests/checks/run.sh \
  tests/checks/test_*.sh
EXIT=0
```

Clean. One SC2164 (cd-or-exit) warning surfaced on initial pass; resolved before committing.

`bash -n` syntax check on all new `.sh` files: clean.

## CI workflow

Extended `.github/workflows/driver-tests.yml`:

- Added new scripts to the `shellcheck -S warning` step.
- Added a new step `Run pre-dispatch grep-gate tests` invoking `bash tests/checks/run.sh`.
- The `bash -n` syntax check across `scripts/` and `skills/` automatically covers the new scripts.

## Top-level PR comment

Posted at <https://github.com/kriskowal/garden/pull/3#issuecomment-4608074313> (id `4608074313`). Summarizes the four commits, the layout, the two gates' regex sketches, the test pass count, the runner integration, judgment calls, and the current-tree firing summary.

## Genuine violations fixed

None on the source side. The `bench-engines-rename` gate found no `.bench-engines` references in the live tree (other than the gate infrastructure that documents the antipattern, which the exclusion list spares).

## False positives the gate now ignores

For `bench-engines-rename`:

- `scripts/checks/bench-engines-rename/` (the gate's own files).
- `scripts/checks/README.md` (the runner index that lists installed gates).
- `tests/checks/test_bench_engines_rename.sh` (the smoke test that has to fixture the literal string).

For `double-space-sentence-separator`: none (the gate's filter is regex-based; no false-positive list is maintained beyond the allowlist tokens).

## Current-branch firing surface

Running `scripts/checks/run-all.sh --dry-run` against the live `design/driver` HEAD with `merge-base ... main` as the base:

- `bench-engines-rename`: clean.
- `double-space-sentence-separator`: fires on 25 files (CLAUDE.md, designs/driver.md, designs/README.md, scripts/daemons/{README,start,stop}.{md,sh}, scripts/driver/{driver.sh,README.md}, scripts/systemd/README.md, scripts/watcher/endo-but-for-bots/{README.md,watcher.sh}, scripts/watcher/README.md, skills/activity-feed-watcher/SKILL.md, skills/cleaner/{cleaner.sh,SKILL.md}, skills/driver-{design-only-pr-workflow,pr-creation-state-machine}/SKILL.md, skills/gardener-inbox-error-reporting/{report-error.sh,SKILL.md}, skills/prompt-on-failure-capture/SKILL.md, tests/driver/{lib/mock-garden.sh,test_*.sh}).

These are multi-sentence physical lines in the design/driver branch's already-written prose. The branch's house style for design docs and prose is multi-sentence-per-line; the gate's rule is sentence-per-line. The two are in tension on this branch's specific diff against `main` because the diff captures hundreds of newly-authored paragraphs.

**Judgment**: the gate's behavior is correct (it implements the maintainer's stated rule). Mass-rewrapping the branch's prose on this PR would re-author much of the existing, already-reviewed prose; that is out of scope for the review item the maintainer just landed. For future PRs against `main` (or against `design/driver` once that lands), the gate's diff scope produces useful signal on small diffs. Surfacing the count in the PR comment so the maintainer can decide separately whether a wrap-cleanup pass is wanted.

## Judgment calls

1. **Initialism / salutation allowlist** — kept short, only tokens used repeatedly across the codebase. Per the gate's `prompt.md` guidance, one-off sentences earn a re-wrap rather than an allowlist entry.

2. **`run-all.sh` shape** — small bash, no external dependencies beyond `git` / `find` / `awk`. `--dry-run` (no `claude` invocation), `--list` (enumerate gates), `--gate` filter (run subset), `--base` and `--repo` (override defaults). Each `check.sh` runs in a subshell so a `set -e` inside cannot taint the runner. Runner exit is non-zero on any firing even after a `claude` dispatch, so the caller knows a follow-up happened.

3. **Exclusion list for `bench-engines-rename`** — initial commit excluded only the gate's own subdirectory. Discovered post-commit that the runner index (`scripts/checks/README.md`) and the gate's smoke test legitimately name the literal string. Widened the exclusion in commit `1ddf7623` (rather than amending) per garden convention.

4. **CI workflow** — extended in-place rather than adding a parallel `checks-tests.yml` workflow. The pre-dispatch grep-gate work is part of the driver design's pre-CI gauntlet; keeping it in `driver-tests.yml` keeps the test surface coherent.

5. **No allowlist for the design doc's existing house style** — would set the precedent that the gate accommodates the pre-existing style rather than enforcing the new rule. The branch's house style is a separate question for the maintainer.

## Per-action authorizations honored

- Create files under `scripts/checks/`, `skills/pre-dispatch-grep-gate/`, `tests/checks/`: done.
- Edit `designs/driver.md` § Driver-run pre-CI validation: done (added step 0).
- Edit `.github/workflows/driver-tests.yml`: done (added new scripts to shellcheck step; added Run pre-dispatch grep-gate tests step).
- One or more commits + regular-append push to `kriskowal/garden:design/driver`: done (4 commits, `1c7e27a2..1ddf7623`).
- Top-level PR comment on garden #3: done (id `4608074313`).

## Not done (per "Not authorized" list)

- Did not touch any path outside the authorized set.
- Did not refactor existing driver code, watchers, daemons, or systemd units.
- Did not un-draft / re-draft the PR.
- Did not force-push.
- Did not merge.

## Self-improvement

The diff-scoped sentence-separator gate's interaction with the design doc's existing multi-sentence prose surfaces a meta-pattern worth naming somewhere: when a deterministic rule lands later than the prose corpus it is meant to enforce, the rule has a "first-PR backlog" the maintainer may want to address as a separate pass. The gate is structurally correct but produces no useful per-PR signal until the corpus is brought into compliance once. Future gate authors should think about this and either (a) ship a one-time cleanup pass alongside the gate or (b) document the backlog and let it land naturally as files are edited. I did not have authority to do (a) on this PR (out of scope); the report surfaces (b). The lesson is small but worth a message to liaison so the next gate-author sees it.

Self-improvement: surface "first-PR backlog" tension to liaison as a candidate addition to skills/pre-dispatch-grep-gate/SKILL.md § Notes.
