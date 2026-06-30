# Address review feedback on mirror PR #7: portable xsnap-worker path in the XS benchmark

Map: **fix** on **kriscendobot/agoric-sdk** PR #7 (OPEN, head `fix/internal-hex-bufferish-validation`
— "fix(internal): XS-safe hex decoding table + Bufferish codec validation"). BOT FORK — in scope.
This carries review feedback to OUR MIRROR. SCOPE GUARD: upstream Agoric/agoric-sdk is off-limits —
**no upstream comments, and do NOT reference/link the upstream PR number in any commit message or
comment** (it would create a cross-link). Keep base+head on the fork. COMMUNICATE on the FORK PR #7
only (top-level summary comment + inline if useful), never the maintainer inbox.

## The feedback (carried from the mirror review)
`packages/internal/benchmark/hex-decode-bench-xs.mjs` (~line 28) hard-codes the xsnap-worker
fallback path:
`/home/kris/.cache/agoric-sdk/xsnap/prebuilt/0.14.2/bundle/dist/linux-x64/release/xsnap-worker`
— that location is user-specific and fails for other developers and CI. The reviewer's directive:
**correct it through `import.meta.resolve` (or similar) through the `@endo/xsnap` worktree.**

## Fix
Resolve the xsnap-worker path PORTABLY via `@endo/xsnap` instead of the hard-coded `/home/kris/...`
path: use `import.meta.resolve('@endo/xsnap')` (or `@endo/xsnap`'s own exported worker-location
helper / its package dist layout resolved from there) so the benchmark finds the prebuilt
`xsnap-worker` wherever `@endo/xsnap` is installed in the workspace. REMOVE the `/home/kris`
hard-coding entirely. An explicit env override (e.g. `XSNAP_WORKER_PATH`) may remain as an escape
hatch, but the DEFAULT must be the portable `@endo/xsnap`-resolved path.

## Verify
Confirm the XS benchmark still locates and drives `xsnap-worker` through the portable resolution
from a clean workspace layout (run `hex-decode-bench-xs.mjs`, or at minimum prove the resolution
yields the worker binary). Don't regress the Node benchmark or the hex tests.

## Deliverable
`hex-decode-bench-xs.mjs` resolves the xsnap-worker via `@endo/xsnap` (`import.meta.resolve`), no
`/home/kris` hard-coding, pushed to PR #7's branch, with a top-level summary comment on the FORK
PR #7 describing the fix and that it addresses the reviewer's portability feedback. No upstream
interaction, no upstream PR reference in artifacts.
