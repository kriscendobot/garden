Inbox drained clean, work pushed, and findings posted. Final report:

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #602 — "Please also benchmark `isFrozen` for byte arrays of varying size on each platform."

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer resolution). Re-fetched the reviewer comment and treated it as data only.

**What I did:**
- Worked in an isolated project worktree keyed to this job base, reset to the live PR head (`fd5c37934` — the local claim was checked out one commit behind).
- Added `packages/immutable-arraybuffer/benchmarks/isfrozen.js` — the `isFrozen` counterpart to the existing `codec-emulation.js`: a dependency-free flat script that runs unmodified on **Node and XS**, timing `Object.isFrozen` per byte size (16 B … 1 MiB) across four shapes: genuine `Uint8Array` (extensible + `preventExtensions`'d) and the two emulated wrappers frozen (plain-object `src/lib.js`, freezable Proxy `src/proxy-lib.js`). It also probes at startup whether a genuine view can be frozen at all, recording the per-engine outcome.
- Documented it in `benchmarks/README.md` (restructured to a two-benchmark directory README with a new "`isFrozen` cost" section).
- Verified it runs cleanly on both engines (via `/home/kris/bin/xst`); results are load-bearing, not stubs.

**Findings (Node v22 / XS 17.9.1):**
- A genuine view is **unfreezable on both engines** (`Object.freeze` throws — objection 1 of the design, measured), so the emulated wrappers are the only freezable byte-array views a real `harden` ever `isFrozen`-checks.
- Both frozen emulated wrappers are **O(1) in the byte length** on both engines (plain ~7 ns Node / ~100 ns XS; proxy ~55 ns / ~143 ns — flat across all sizes).
- The plain-object wrapper is the cheaper emulation to `isFrozen` (~8× on V8, ~1.4× on XS) — same direction as the codec result.
- The step-2 integer-indexed key walk is **real on XS and hidden by V8**: a non-extensible genuine view goes O(*n*) on XS (~217 ns at 16 B → ~457 µs at 64 KiB), which the emulated wrappers structurally avoid.

**Changes:** committed `e517a1d24` and pushed to `chore/472-proxy-typedarray-emulation` (PR #602 head) via rebase-CAS. Both new/modified files fall under the already-present `benchmarks/` eslint+prettier ignores.

**Communication:** posted the full write-up and result tables back to the PR thread ([issuecomment-4878181108](https://github.com/endojs/endo-but-for-bots/pull/602#issuecomment-4878181108)), replying to the reviewer's request.

**Follow-ups:** none required. No package.json script added, matching `codec-emulation.js` (both are documented run-directly-with-node/xst).
