Done. Completion report:

## Report: pr7-portable-xsnap-worker-path

**Task:** Carry mirror-review feedback to kriscendobot/agoric-sdk PR #7 (BOT FORK) — replace the hard-coded user-specific xsnap-worker fallback path in the XS hex-decode benchmark with portable resolution.

**What I did:**
- Edited `packages/internal/benchmark/hex-decode-bench-xs.mjs`. Removed the `/home/kris/.cache/agoric-sdk/...` hard-coded default entirely. The worker path now resolves portably via `import.meta.resolve('@agoric/xsnap/package.json')`, then points at the prebuilt `xsnap-worker` in the package's dist layout (`xsnap-native/xsnap/build/bin/<platform>/release/xsnap-worker`) — the canonical location `@agoric/xsnap`'s `install-prebuilt` populates and its own `resolveXsnapWorkerPath` returns. `XSNAP_WORKER` is kept as an explicit override escape hatch.
- **Design choice:** I first tried importing the package's `resolveXsnapWorkerPath` helper directly, but that drags in `@agoric/xsnap`'s SES-dependent module graph (`@endo/errors` fails without lockdown) — wrong for a plain benchmark process. So I resolve only the package *path* (not its runtime), with a 2-entry platform map mirroring the helper.

**Verification** (in a built worktree with `@agoric/xsnap` installed + prebuilt worker, no `XSNAP_WORKER` set):
- `import.meta.resolve` yields a real, existing, executable `xsnap-worker`.
- Bounded drive test over the fd-3/fd-4 netstring protocol: core built, `tableSize === 484` asserted inside XS, corpus correctness passed.
- `node --check` parses clean; no `/home/kris` reference remains. Node benchmark and hex tests untouched.

**Pushed:** commit `cb0d3b6b66` to `fix/internal-hex-bufferish-validation`. Posted a top-level summary comment on fork PR #7 describing the fix and that it addresses the reviewer's portability feedback.

**Scope guard honored:** all work base+head on the fork; no upstream comments and no upstream PR number referenced in the commit message or comment. Bot identity (kriscendobot) on the commit. Fork worktree torn down.

**Follow-ups:** None required. (Optional hygiene: `@agoric/xsnap` is not a declared devDependency of `@agoric/internal` — the import resolves via yarn workspace hoisting, and the benchmark is excluded from the repo typecheck, so this matches the existing setup; declaring it would introduce an internal↔xsnap dev cycle, so I left it as-is.)
