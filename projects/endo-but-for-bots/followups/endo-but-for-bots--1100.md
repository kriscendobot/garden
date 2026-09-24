---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 1100
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-09-24T01:45:35Z
last_appended_at: 2026-09-24T01:45:35Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#1100

This ledger was created late. The round-2 panel (review 5111937485, 2026-09-04) deferred three `[follow-up]` items but never recorded them, and scribe flagged the gap in gauntlet 20260923b round 3 (review 5298718881). The ledger carries those items plus one should-fix deferral from round 3. Revisit them when the PR merges.

## Items

- [ ] **POSIX-only path separators in the code-mode type extractor.**
  **Source seat(s)**: transplanter.
  **Round**: 2 (2026-09-04).
  **Recommended action**: open a follow-up PR on endojs/endo-but-for-bots that makes `packages/agent-tools/scripts/code-mode-type-extract.js` separator-agnostic.
  Round 2 cited `includes('/pass-style/src/types.d.ts')`. That literal no longer appears at the current head, but the same pattern survives, for example `fileName.endsWith('/fs/types.d.ts')` (line ~980). On a Windows checkout, a `\`-separated `fileName` misses the branch. CI runs only on Ubuntu, so nothing catches this. Use `/[\\/]…$/u` tests.

- [ ] **Stale `@endo/base64` dependency in `@endo/exo-unzip`.**
  **Source seat(s)**: pruner / packager (round-2 aggregate).
  **Round**: 2 (2026-09-04).
  **Recommended action**: drop `@endo/base64` from `packages/exo-unzip/package.json`, with a separate `chore: Update yarn.lock` commit. This dependency predates the PR, and at head 4c016bcaca nothing under `packages/exo-unzip/{src,test}` imports it.

- [ ] **Benchmark harness for the accepted byteArray wire-cost regression.**
  **Source seat(s)**: benchmarker.
  **Round**: 2 (2026-09-04).
  **Recommended action**: largely addressed in-PR, because `packages/exo-stream/BENCH.md` now records the method, test bed, and reproduction. At merge, confirm the remaining gap: there is no XS or other interpreted-engine measurement. If the XS item below does not cover it, file an issue.

- [ ] **Un-stub exo-stream `test:xs`.**
  **Source seat(s)**: spec-keeper (should-fix).
  **Round**: gauntlet 20260923b round 3.
  **Recommended action**: open a follow-up PR that replaces `"test:xs": "exit 0"` in `packages/exo-stream/package.json` with a real XS run. It should cover at least the `frozenBytes`/`thawedBytes` round-trip and `M.byteArray()` under the `@endo/immutable-arraybuffer` emulation, which this PR puts on exo-stream's default path. See the hardened262 note: validating immutable ArrayBuffer needs Moddable 9.0.0 `xst`.
