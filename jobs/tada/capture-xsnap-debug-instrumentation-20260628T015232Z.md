Job complete. The xsnap stack-overflow debug instrumentation is now durable in both bot-owned forks as committed branches + DRAFT PRs.

**Deliverable A — `kriscendobot/xsnap-pub` (engine instrumentation)**
- Branch `debug/xs-stack-overflow-trace`, commit `55449665`, DRAFT PR **https://github.com/kriscendobot/xsnap-pub/pull/2** (base = the fork's own `Agoric` branch).
- Edited the `XS_STACK_OVERFLOW_EXIT` arm of `fxAbort()` in `xsnap/sources/xsnapPlatform.c` + added `#include <execinfo.h>`. Reproduced the issue-thread patch verbatim, adapted to the fork's actual arm (a plain `case … break;`, which I converted to a braced block to scope the locals). It dumps value-stack fill level, the XS frame chain innermost-first (per-frame slot span + source line, capped at 600), and an allocation-free native C backtrace, all on inherited stderr — commit message explains the `mxNoConsole`/`fprintf` rationale and the ymax0 v320 context.

**Deliverable B — `kriscendobot/agoric-sdk` (build/run methodology)**
- Branch `debug/xs-stack-overflow-methodology`, DRAFT PR **https://github.com/kriscendobot/agoric-sdk/pull/6** (base = the fork's own `master`).
- Added `packages/xsnap/doc/xs-stack-overflow-debugging.md` recording the `xsnap-worker.mk` build invocation (gcc-13 shim, remove-prebuilt-symlink-first), the fd-3/4 netstring run procedure, the trivial/deep-recursion controls, and the key calibration conclusion (9 frames at 4096/4096 = wide value-stack exhaustion, `stackCount` fixed at 4096).

**Report comment:** posted on garden issue #9 with both PR URLs and a one-paragraph summary — https://github.com/kriskowal/garden/issues/9#issuecomment-4824033124. Issue left **open** for the submitter to close.

**Scope adherence:** touched only the two bot forks; nothing pushed to or PR'd against any upstream; both PRs left DRAFT with no un-draft/judge/conductor chain.

**Follow-up / deviation:** The submodule pin in Deliverable B was **not** advanced — this agoric-sdk fork's `master` carries no in-tree `xsnap-native` gitlink (no `.gitmodules`, no `160000` entry), so advancing a pointer would have meant fabricating submodule structure. Per the job's stated fallback, the doc references the xsnap-pub branch/commit directly instead. If a future task needs the two wired at the gitlink level, that would require reintroducing the submodule on the fork branch first.
