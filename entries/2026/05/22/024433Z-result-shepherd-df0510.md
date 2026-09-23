---
ts: 2026-05-22T02:44:33Z
kind: result
role: shepherd
worktree: dispatches/shepherd--df0510/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/013228Z-result-barrister-1835ab.md
  - entries/2026/05/22/013052Z-result-cleaner-736a29.md
---

# Shepherd pass on PR #347 (CBOR mirror), head e3089cc2b

PR #347 `feat(ocapn): CBOR alternative encoding (mirror of endojs/endo#3033)`,
base `llm`, head `e3089cc2b`. Dispatch brief: "drive CI to green; distinguish
PR-introduced from pre-existing infra debt; for pre-existing, document and
leave; for PR-introduced, fix; do NOT exit early."

## CI snapshot at dispatch (and at exit; no push)

`gh pr view 347` reported `mergeStateStatus: UNSTABLE`, `mergeable: MERGEABLE`,
`reviewDecision: ""`. 15 SUCCESS, 10 FAILURE on head `e3089cc2b`:

- FAILURE: `lint`, `zizmor`, `cover (20.x|24.x, ubuntu-latest)`,
  `test (20.x|22.x|24.x × ubuntu-latest+macos-15)` (6 jobs).
- SUCCESS: all other check-runs (`build`, `browser-tests`,
  `test-ocapn-guile-interop`, `familiar-bundle`, `sandbox-drivers`,
  `test-async-hooks`, `test262 (20.x|24.x)`, `test-hermes`,
  `check-action-pins`, `viable-release (20.x|24.x)`, `test-xs`,
  `test-ocapn-python`, `build-wasm`).

## Per-cluster disposition

### Cluster A: `makeClient` import error (lint + 6 test + 2 cover = 9 jobs)

**Root cause:** `packages/ocapn/test/netlayer-tcp-syrup.test.js:7` imports
`makeClient` from `../src/client/index.js`. `client/index.js` on the merge ref
exports `makeOcapn` (the symbol was renamed at some prior point), so the
import resolves to undefined and the ava worker throws
`SyntaxError: The requested module '../src/client/index.js' does not provide
an export named 'makeClient'` before any test in the file runs. The
single ava-worker exit code propagates as the package's `yarn test` exit 1,
which fails the workflow's `lint`, every `test (<node>, <os>)` matrix entry
that runs the affected package, and both `cover (<node>, ubuntu-latest)`
jobs.

**Provenance:**

- `packages/ocapn/test/netlayer-tcp-syrup.test.js` exists at
  `b67ef3d9d:packages/ocapn/test/netlayer-tcp-syrup.test.js` (the PR base,
  i.e. `origin/llm@HEAD`). Blob `7bdcaf3d`. The PR head `e3089cc2b` is
  *behind* `origin/llm` (merge base `68246ad92`); the file was added on `llm`
  in the gap. GitHub's `pull_request` merge ref `refs/pull/347/merge`
  contains the file (the merge commit `9f0c40ce2` is a clean Merge of
  `e3089cc2b` into `b67ef3d9d` with only the PR's own +2/-0 JSDoc-cast
  change).
- PR #347's diff against `llm` is exactly
  `packages/ocapn/src/codecs/subtypes.js | 2 ++`. The test file is not
  touched by the PR; the import error is not introduced by the PR.
- A skip-fix already exists on its own branch
  `origin/pc-skip-netlayer-tcp-syrup` (commit `93e9cd2d0
  chore(ocapn): skip netlayer-tcp-syrup until makeClient port lands`).
  The branch is referenced in every CI job's `git fetch` output, confirming
  the steward (or some prior shepherd) registered the in-flight fix.

**Disposition:** document and leave. Matches the dispatch brief's "pre-
existing makeClient infra red that affects every PR on llm-base (per
#101/#125/#333 shepherd diagnoses)" and the cleaner's same-week diagnosis on
PR #345 (entry `013052Z-result-cleaner-736a29.md` § *CI on cleaner HEAD*).
Fixing the test file (skip, delete, or rewrite-import) is not in this
shepherd's scope: it would (a) touch a file outside the PR's
JSDoc-cast-only change set, (b) duplicate work already staged on
`pc-skip-netlayer-tcp-syrup`, and (c) require a workspace-touching decision
the shepherd's hard-escalation points reserve for the maintainer.

### Cluster B: zizmor (1 job)

**Root cause:** `Workflow security audit` (`zizmor` action) reports
`overly broad permissions`, `code injection via template expansion`,
`runtime artifacts potentially vulnerable to a cache poisoning attack`,
and `action's hash pin has mismatched or missing version comment` findings.
All errors are in `.github/workflows/ci-docs.yml` and
`.github/workflows/familiar-release.yml`. The PR does not touch
`.github/workflows/`.

**Disposition:** document and leave. Pre-existing workflow-security infra
debt on `llm`; same fingerprint as prior shepherd diagnoses. Out of scope
for a JSDoc-cast PR and would require a workflow-rewrite which exceeds the
shepherd's hard-escalation points (>~5 files, multiple modules).

## PR-introduced regressions

None. The PR's net diff is +2 lines of JSDoc casts on
`packages/ocapn/src/codecs/subtypes.js` (`/** @type {bigint} */` on two
`readInteger()` return values). The casts are inert at runtime; the
barrister's panel verdict on the same head (entry
`013228Z-result-barrister-1835ab.md`) confirmed the casts neither narrow nor
widen the inferred type (`SyrupReader.prototype.readInteger` is already
`@returns {bigint}` at `packages/ocapn/src/syrup/decode.js:455`).

The PR-touched surface is covered by the green jobs: `build`,
`build-wasm`, `test-ocapn-python`, `test-ocapn-guile-interop`,
`familiar-bundle`, `test262`, `test-xs`, `test-hermes`,
`sandbox-drivers`, `viable-release (20.x|24.x)`, `check-action-pins`, and
`browser-tests` all pass. The CBOR codec the PR mirrors is exercised in
coverage (95.17% statements on `src/cbor/encode.js`, 81.87% on
`src/cbor/decode.js`; 89.06% across all files) even though the surrounding
`cover` workflow exits 1 on the unrelated `netlayer-tcp-syrup.test.js`
uncaught exception.

## Commits

None. No push to `origin/mirror/3033-ocapn-cbor`. Head unchanged at
`e3089cc2b`.

## Post-exit CI snapshot

Identical to the pre-exit snapshot (no shepherd push). 15 SUCCESS, 10
FAILURE, all 10 in the two pre-existing infra-debt clusters above.

## Hand-off

The PR is **substantively green for the PR-touched surface** under the
shepherd's framing: every check that exercises the JSDoc-cast change passes;
every failing check is an unrelated pre-existing red. The barrister panel
already terminated and un-drafted the PR (entry
`013228Z-result-barrister-1835ab.md`). The next stage in the gamut is the
boatman (ferry to upstream endojs/endo#3033) or the conductor (merge to
`llm`), per the maintainer's preference. Neither stage is gated on the
infra-debt reds, since (a) the lint/test/cover/zizmor reds are documented
as pre-existing on the dispatch brief, on this entry, and on the cleaner /
barrister entries for the same head, and (b) the maintainer's review of the
PR is what decides merge readiness, not a green CI rollup that the PR cannot
deliver against an already-red base.

Self-improvement: nothing this time. The diagnostic chain (lint error
points to a test file; the test file's import error appears identically in
every test/cover matrix entry; the PR diff does not touch the file or the
imported module; the test file exists on `origin/llm`; a fix branch already
exists for the underlying skip-or-port decision) is the standard
"pre-existing infra red on llm-base" recognition that prior shepherd
dispatches on #101/#125/#333 and the cleaner on #345 each independently
re-derived. The recognition is already well-rehearsed in the journal; no
new skill or role edit is warranted on this occurrence.
