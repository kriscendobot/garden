OCapN-over-Noise press, dispatch 13 (2026-07-21 ~15:20Z) — steady state confirmed, all milestones re-proven live.

**Assessment (nothing regressed, nothing to rebase):**
- Stack heads unchanged since the 2026-07-19 restack: #340 `6eb31274`, #684 `cc398cb1`, #688 `469335e6`, #693 `73ad1b6d`, #683 `64b6dac5`, plus crossed-hello fix #806 `1e4f9104`. All six OPEN, DRAFT, MERGEABLE, every check green.
- One false alarm investigated: #693's status rollup lists a fully-CANCELLED check batch — two `pull_request` run sets fired within the same second on 2026-07-19 and concurrency cancelled one; the surviving batch is all-success. Cosmetic, no action.
- `llm` advanced to `d092e0e259` (endor Node-semantics reland, #802) without conflicting the stack; per the settled policy (restack only on CONFLICTING or degraded checks), no rebase.

**Live proofs (real command output captured):**
- Both endpoints answer 426: `https://minion.town/ocapn` and `/ocapn-daemon`.
- Greeter demo (`demo/minion-town/run-demo.sh`): SSM-fetched the daemon's live location, dialed `wss://minion.town/ocapn`, Noise IK completed, `RESULT {"ok":true, "nodeId":"810b996c…", "reply":"Hello, the local peer!…"}`.
- Cross-host Pet-Daemon invite/accept (`run-cross-host.sh`): invitation minted on the minion.town daemon (container at `a371b007`), accepted by a local Pet Daemon over `wss://minion.town/ocapn-daemon`, peer bound as `minion`, capability round-trip `E(adder).add(2,3) = 5` → **CROSS-HOST DEMO PASSED**. Trailing `Termination requested` is the known benign teardown race.

**What changed:** memory (`ocapn-over-noise-goal`) updated with the dispatch 12–13 steady-state record. No evidence comment posted on #693 — nothing has changed since dispatch 11's comment, matching the no-repeat policy from dispatches 7–8. No garden or project commits needed.

**Follow-ups:** (1) the next external unblock is merging #806 (green, zero reviews) into `llm`; the following restack inherits the crossed-hello settlement fix. (2) The likely next implementation arc remains design #794 (key-only session boundary), which is designer/builder scope, not press scope. (3) Standing open items unchanged: mutual bidirectional pairing, `daemon-agent-network-identity`, session-reconnect design, remote TCP+CBOR blocked by minion.town's 443-only security group.
