## Completion report — ocapn-noise-press-20260727-053502 (dispatch 20)

**Assessment.** The 07-26 23:35Z dispatch's sole follow-up was confirming CI on the restacked heads. Confirmed this dispatch: **all five stack PRs fully green and MERGEABLE/CLEAN** — #340 `83f55ea9` (25/25 checks), #684 `c4692253` (23/23), #688 `727fce0e` (23/23), #693 `1fbb870c` (23/23), #683 `64b6dac5` (24/24). Zero non-passing checks; no new maintainer comments; no live peers on the branches.

**Outage found + repaired.** `wss://minion.town/ocapn` (the M3/M4 toy greeter endpoint) was returning **502** — down since 2026-07-22 ~19:13Z. Root cause: the host rebooted and a parallel workstream's redeploy replaced `/opt/endo` (leaving `/opt/endo.old`; neither tree a git repo, demo files gone), so `endo-ocapn-daemon.service` crash-looped ~170,558 restarts on `MODULE_NOT_FOUND`. Repair: rewrote the systemd unit to `docker run` the same demo from the on-box `endo-pet-daemon:ocapn-ws` image (built from `a371b007`, deps in-image), publishing `127.0.0.1:8930`, location JSON at `/opt/ocapn-demo/ocapn-demo-location.json`. The toy service now has **no `/opt/endo` dependency**, permanently removing that cross-workstream contention. Both endpoints verified back at 426. The Pet-Daemon endpoint/container was never affected.

**Live proofs re-run (both PASSED, real output captured):**
- Greeter over the restored endpoint: `RESULT {"ok":true,…}` with fresh designator `563ce21f…`, returned nodeId matches designator (Noise IK + reverse peer auth).
- **Cross-host Pet-Daemon invite/accept at the NEW head `1fbb870c1c`** (first since the restack), local ↔ minion container over `wss://minion.town/ocapn-daemon`: paired as `minion`, `E(adder).add(2,3) → 5`, greeting round-trip, `CROSS-HOST DEMO PASSED`.

**Evidence comment:** endojs/endo-but-for-bots#693 issuecomment-5087758110.

**Memory:** `ocapn-over-noise-goal.md` + index were stale (missing dispatches 16–20; still claimed "#806 awaits merge") — brought current with the merged #806, new heads, the outage/repair, and the note that `ensure-project-worktree.sh` now warm-caches endo deps (~6s install; old manual recipes obsolete).

**Follow-ups:** (1) at the next natural restack, update the tracked `demo/minion-town/endo-ocapn-daemon.service` copy on #684's branch to the deployed docker-run form (deferred now to avoid dirtying just-greened CI); (2) standing blocked items unchanged — stack awaits maintainer review/un-draft, cross-host TCP+CBOR blocked on the 443-only security group, reconnect design still Proposed, #794 key-only session boundary remains the likely next arc.
