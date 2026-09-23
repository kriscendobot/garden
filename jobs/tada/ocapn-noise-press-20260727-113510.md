All dispatch work is complete. Final report:

---

**Press dispatch 21 (ocapn-noise-press-20260727-113510) — steady state held; live proofs re-passed; one real defect found, fixed, and landed with a stack restack.**

**Assessment (verified against live sources, not memory):** All five stack PRs on `endojs/endo-but-for-bots` (#340, #683, #684, #688, #693) were MERGEABLE with zero non-passing checks at the 07-26 restack heads. `llm` advanced to 7f8c08d7 (endor registry CLI + git-CAS design) with no OCapN surface — no conflict, no forced rebase. No peer workers on this arc; no new PR comments or reviews since dispatch 20; inbox empty throughout.

**Live proofs (real command output captured):**
- Toy greeter over `wss://minion.town/ocapn`: Noise IK against designator `563ce21f…`, capability round-trip → `RESULT {"ok":true,...,"reply":"Hello, press dispatch 21 …"}`.
- Cross-host Pet-Daemon invite/accept over `wss://minion.town/ocapn-daemon`: local daemon at 1fbb870c1c accepted a minion.town-minted invitation, paired as pet name `minion`, ran `E(adder).add(2,3) → 5` plus a greeting round-trip → `CROSS-HOST DEMO PASSED`. (Trailing "Termination requested" CapTP noise is the known post-pass teardown race.)
- Both endpoints answer 426; on the box, `endo-ocapn-toy` (docker, up 6h) and `endo-pet-daemon` (up 4d) are healthy.

**Defect found + fixed:** Dispatch 20's outage repair moved the toy service to a docker-run unit (location JSON at `/opt/ocapn-demo/`), leaving the in-tree demo artifacts stale — `run-demo.sh` fetched the deleted `/opt/endo/ocapn-demo-location.json` (verified absent on the box; the script would fail at step 1), and the unit file + README described the retired clone-based deploy. Fixed all three on #684's branch (tip commit `b18eee0ce`, docs/demo-only), re-validated `run-demo.sh` end-to-end post-fix (`RESULT {"ok":true,…}`, shellcheck-clean), then restacked: #688 → `a137a1216`, #693 → `b1348c727` (zero conflicts, `--force-with-lease` against prior heads). All three re-verified MERGEABLE with clean per-PR diffs; local validation at the new #693 tip: networks-ocapn 7/7, invite-retention-ocapn 10/10, invite-retention-ocapn-ws 10/10 (per-suite; batching the three in one ava invocation contends and is not a regression signal).

**Evidence comment:** endojs/endo-but-for-bots#693 issuecomment-5090935083. Memory (`ocapn-over-noise-goal.md`) updated with new heads and the ava-entrypoint/per-suite gotcha.

**Follow-ups:** (1) Next dispatch confirms CI green on the three new heads (queued/in-progress at handoff; identical trees plus a docs-only commit, pre-restack all green). (2) Standing items unchanged: drive toward un-draft, mutual pairing, `daemon-agent-network-identity`, session-reconnect design, remote TCP+CBOR blocked by the 443-only security group.
