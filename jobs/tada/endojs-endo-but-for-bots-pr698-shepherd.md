CI is fully green (24/24) on head SHA `4e2153628`. The job is complete.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #698 — *fix(ocapn): bytes-preserving SturdyRef wire read (bridge cut 1)*

**Starting state (head `948aec29a`):** 4 red checks
- `lint` (CI workflow) — FAILURE
- `lint` (CI docs-only) — FAILURE
- `test (22.x, ubuntu-latest)` — FAILURE
- `test (22.x, macos-15)` — FAILURE

**Diagnosis**
- Both lint failures: a single prettier formatting violation in `packages/ocapn/test/codecs/passable.test.js` (redundant parens around a `/** @type */` cast). In-scope, definite.
- Both 22.x test failures: `@endo/daemon#test` reported "1 unhandled rejection" — a stray "Connection lost" rejection leaking during ws-relay test **teardown** in `packages/daemon/test/endo.test.js`. All ws-relay tests themselves passed (✔); no assertion failed. The 24.x jobs passed on both platforms, only 22.x tripped — a timing-sensitive teardown race. This PR's diff touches only ocapn (`src/client/ref-kit.js`, `src/codecs/descriptors.js`, ocapn test + snapshots) and no daemon code, so the flake was not caused by the PR.

**Action**
- Ran `prettier --write` on the test file and committed the one-line reformat as a separate atomic commit `chore: prettier --write passable.test.js to satisfy lint` (matching the PR's existing prettier-fixup style).
- Pushed to the PR head branch `build/sturdyref-bridge-1-bytes-wire-read` with `--force-with-lease` against the expected anchor (`948aec29a..4e2153628`).

**Result:** the push re-dispatched full CI on new head `4e2153628`. Both lint checks went green (prettier fix), and the daemon ws-relay unhandled-rejection cleared on the fresh run (confirming the flake). **All 24/24 checks now SUCCESS.** Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/29172861248

**Notes / follow-ups**
- No green-run summary comment posted: the auto-dispatched job body carried no per-action comment authorization (external-repo etiquette).
- PR remains a DRAFT (its intended state — this is a stacked bridge-cut PR); shepherd scope is CI-green, not un-drafting.
- The `@endo/daemon` ws-relay teardown unhandled-rejection is a recurring latent flake worth a separate hardening pass in the daemon package, but it is out of this PR's scope and cleared on re-run — no escalation needed here. `next: none` (operational flake, cleared on re-run).
