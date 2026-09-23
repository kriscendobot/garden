---
ts: 2026-06-18T07:41:28Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/18/074128Z-result-shepherd-934aab.md
---

## Shepherd: PR #455 — Dependabot minor/patch group bump (26 deps)

### Pre-fix head

`cf69a0379` (branch: `dependabot/npm_and_yarn/all-minor-patch-73011553ab`)

### Post-fix head

`e9f6eb122`

### Failure classifications

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| C | test (22.x ubuntu, 22.x macos, 24.x ubuntu, 24.x macos) | `evade-censor` snapshot mismatch | Fixed: updated AVA snapshots for Babel 7.29.7 |
| C | cover (22.x ubuntu, 24.x ubuntu) | same `evade-censor` snapshot mismatch | Fixed: same snapshot update |
| C | lint | shellcheck SC2148 on `evoke/config.sh` + SC1090/SC2034 on fae/genie/jaine scripts | Fixed: cherry-picked `d8412ef` shellcheck fixup |

### Root cause analysis

**test/cover (all 6 matrix jobs):**
The dependabot PR bumped `@babel/generator` from `^7.28.3` (resolving to `7.29.1`) to `^7.29.7` (resolving to `7.29.7`) in `packages/evasive-transform/package.json`. Babel 7.29.7 generates different source-map `mappings` strings and `names` arrays (different column offsets, slightly different name ordering). The AVA snapshot files in `packages/evasive-transform/test/snapshots/` reflected the old Babel output. Running `ava --update-snapshots` with the new Babel locally produced the correct output.

Three tests failed:
- `evadeCensor() - successful source transform w/ source map & source URL`
- `evadeCensor() - successful source transform w/ source URL`
- `evadeCensor() - successful source transform w/ source map, source URL & unmapping`

**lint (shellcheck):**
The shellcheck gate was added to the `llm` base branch in the upstream `actual/master` merge (`f9ff85c5`). The dependabot PR opened before that merge, so its CI had no shellcheck gate until now. When the PR's merge commit picks up the new base, shellcheck surfaces preexisting shell script issues:
- `evoke/config.sh`: SC2148 (missing shebang or `shell` directive)
- `packages/fae/provider-setup.sh`, `packages/genie/test/integration.sh`, `packages/jaine/provider-setup.sh`, `packages/jaine/reload.sh`: SC1090/SC2034/SC2163 warnings

The fix was already authored by endolinbot on other in-flight PRs (commit `75609457e`). Cherry-picked as `d8412ef`.

### Fix substance

Commit `d8412ef` — `chore(lint): satisfy shellcheck on preexisting shell scripts`:
- Added `# shellcheck shell=bash` to `evoke/config.sh` (sourced script, no shebang wanted)
- Added `# shellcheck source=/dev/null` directives to fae/jaine scripts
- Fixed `export "$1"` to `export "${1?}"` in genie integration test
- Added `|| exit 1` to unchecked `cd` calls in npm-audit-fix scripts

Commit `e9f6eb1` — `fix(evasive-transform): update snapshots for @babel/generator 7.29.7`:
- Updated `evade-censor.test.js.snap` and `.md` to match Babel 7.29.7 output

### Pre-push-gates result

The gate ran but surfaced pre-existing findings from the large upstream merge (`f9ff85c5`). None of these are from commits in this shepherd's scope (my two commits touch only shell scripts and snapshot files). Findings:
- `filename-no-stutter`: pre-existing across many packages (not introduced by this PR)
- `no-ascii-banners`: pre-existing in design docs (not introduced by this PR)
- `no-inline-import-jsdoc`: pre-existing in many packages (not introduced by this PR)
- `no-non-ascii-in-source`: pre-existing in `endo-fs/src/` (not introduced by this PR)

These are Class B items (pre-existing in the base branch, beyond shepherd scope). They do not gate this PR's mergeability — they were present before this dependabot bump opened.

### PR comment

https://github.com/endojs/endo-but-for-bots/pull/455#issuecomment-4739309516

### New CI run

https://github.com/endojs/endo-but-for-bots/actions/runs/27744402432 (all jobs pending as of push)

### Recommended next stage

CI is propagating. If all jobs pass: `next: conductor`.
If any job fails with a new signature: `next: liaison` (re-dispatch shepherd for investigation).

Self-improvement: The pre-push gates probe against the full PR diff including large upstream merges in the base branch. When a dependabot PR is based on a branch that includes a massive upstream sync, the gates surface many pre-existing findings unrelated to the PR diff. Future shepherd dispatches on dependabot PRs should note this pattern and skip pre-existing gate findings that are clearly in the base merge, not in the PR's own changes.
