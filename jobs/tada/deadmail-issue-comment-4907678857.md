No lingering compute processes (only my own grep and the claude runner). Inbox is empty. The job is complete.

## Completion report

**Job:** Dead-lettered issue-inbox comment (kriskowal/garden#9, comment 4907678857 from mhofman) → picked up its intent and replied on the thread.

**The ask:** Verify the ymax0 v320 XS `flat`/`flatMap` value-stack overflow using stock **`xst`** (the standalone XS shell from Moddable releases) instead of the agoric xsnap worker, before and after `73aad47b`; and if PR#1's end-of-block `mxPop()` is the more correct place, produce a test case that reproduces against the latest release.

**What I did:**
- Located the release window: `73aad47b` landed 2026-01-20, bracketed by release **7.0.0** (before, lacks it) and **7.1.0** (first after, has it); **8.3.0** is latest (also leaf-only pop). Confirmed via `gh api compare`.
- Built stock `xst` from the 7.0.0 / 7.1.0 / 8.3.0 release tarballs (no fork, no patches, `GOAL=release`).
- **Leaf/ymax0 class** (`[inner].flat()`, hex.js `new Map(RI.flatMap(...))` shape): **7.0.0 → STACK OVERFLOW**, **7.1.0 & 8.3.0 → OK**. `73aad47b`'s leaf pop fixes the issue on the canonical engine release — confirmed sufficient.
- **Nested branch** (`a.flat(1)`, every element an array): **overflows on the latest release 8.3.0** (and 7.1.0), because 73aad47b pops only the leaf slot; the sub-array `item` slot is never popped, so the overflow merely moves out from N≈150K (7.0.0, 2 leaks/elt) to N≈256K (leaf-popped, 1 leak/elt) rather than disappearing. This confirms PR#1's end-of-block placement is the more complete fix.

**What changed (committed to main2, `e268c4fdc`):** new `skills/agoric-chain-snapshot/repro/xst-release-ab/` — `build-xst.sh`, `run-ab.sh`, `README.md` (methodology + verified tables), and two Moddable-adoptable test cases: `testcase-flat-leaf-overflow.js` (leaf-pop regression guard) and `testcase-flat-nested-overflow.js` (**still overflows on latest release** — the one mhofman requested). Both test-case files validated against the built release binaries.

**Reply posted** as kriscendobot: https://github.com/kriskowal/garden/issues/9#issuecomment-4908049825 (issue left open, per the never-close rule).

**Follow-ups / caveats:** At `xst`'s default 256K-slot stack the nested overflow is O(N²) to reach (~218 s), a property of the large default stack, not the bug — the sibling `engine-flatmap-ab/` harness shows the identical nested overflow at N≈4200 in <1 s at the on-chain `stackCount=4096`. Recommended cleanest engine fix (noted to mhofman): cherry-pick `73aad47b` with its `flatAux` pop moved to the end-of-block spot, which also keeps the commit's unrelated sort/`xsDelete` hunks. Build artifacts live under `~/.cache/garden-scratch/xst-ab/` (transient; the durable harness is committed).
