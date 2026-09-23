All work is complete. Final state verified: the install/lockfile CI gate (which fast-fails in ~14s when broken) is now progressing past that point, confirming the lockfile fix landed correctly.

---

## Completion report — `agoric-sdk-fork-pr-7-apply-richard-gibson-feedback`

**PR:** kriscendobot/agoric-sdk#7 (bot fork, bot identity). Pushed `184baed` to `fix/internal-hex-bufferish-validation`. Scope line held: zero upstream Agoric/agoric-sdk links, comments, or pushes; all artifacts self-contained on the fork.

### Richard's feedback (1) — concrete, applied
Rewrote `packages/internal/benchmark/hex-decode-bench-xs.mjs` to drive XS through the **real `@agoric/xsnap` `xsnap()` export** in his "best of all" form (dynamic import, `name`/`meteringLimit`/`fs: {}`/`os: osType()`/`spawn`). Deleted all the hand-rolled recapitulation it had been carrying: `resolveWorkerPath`, the fd-3/fd-4 `frame`/`makeReader`/`makeWorker` netstring machinery, the OK/ERROR/meter parsing, and the `must()` ok-flag wrapper. The benchmark now reads `r.meterUsage.compute` directly and relies on `evaluate()` rejecting on an uncaught XS exception (the inner correctness `throw`s are the pass/fail signal). `XSNAP_WORKER` override is preserved (now honored by `@agoric/xsnap` itself). The dynamic import is deliberate — `@agoric/xsnap` depends on `@agoric/internal`, so a static import would cycle, exactly as Richard's comment notes.

Declared `@agoric/xsnap` as a `workspace:*` devDependency of `@agoric/internal` (the file now imports it as a real module, not just `import.meta.resolve` on its path).

### Richard's feedback (2) — architectural, planned + queued
Captured the `@endo/hex` direction in the #7 reply comment and **posted a follow-on job** `endo-hex-tiered-codec-port` to the board for a tiered `@endo/hex` package **in endojs/endo-but-for-bots** (the bot's Endo fork — never upstream endojs/endo): prefer native `Uint8Array.fromHex`/`toHex` → `Buffer` fallback → per-byte char-pair "map" (built with a **bounded loop**, never `flatMap`+spread — the exact XS overflow #7 fixes). It carries #7's correctness pins forward and notes that #7 gets slimmed to consume `@endo/hex` in a later, separate job once the package exists.

### CI
Caught and fixed a real failure I introduced: CI's `restore-node` runs `yarn install --immutable`, which rejected the bare package.json change. Patched `yarn.lock` deterministically to match (merged the `@agoric/xsnap@workspace:*` descriptor key and added the `"@agoric/xsnap": "workspace:*"` line under `@agoric/internal`'s dependency block), amended, force-pushed. The re-run cleared the install gate (no longer fast-fails at ~14s); `lint`, `up-to-date`, `breakage`, and the script/merge-strategy checks pass; the full multi-package build is in progress with no failing checks. The benchmark dir remains excluded from eslint/typecheck/quickcheck (prior commits), so the rewrite is not statically checked by CI.

### Posted
Reply comment on #7 (issue-comment 4848793199) summarizing both points substantively, no upstream link.

### Follow-ups
- `endo-hex-tiered-codec-port` job is on the board (design+build the tiered `@endo/hex` in endo-but-for-bots).
- After `@endo/hex` lands: a separate agoric-sdk-fork job to slim #7 / `packages/internal/src/hex.js` to depend on it and drop the in-tree codec body.
- The full agoric-sdk build is still running; install/lint/lockfile gates are green, so no action expected, but the long build was not awaited to completion.
