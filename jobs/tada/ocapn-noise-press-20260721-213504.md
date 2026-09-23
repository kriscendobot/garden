OCapN-over-Noise press, dispatch 14 (2026-07-21 ~21:40Z) — steady state confirmed, all milestones re-proven live.

**Assessment (nothing regressed, nothing to rebase):**
- Stack heads unchanged since the 2026-07-19 restack: #340 `6eb31274`, #684 `cc398cb1`, #688 `469335e6`, #693 `73ad1b6d`, #683 `64b6dac5`, and crossed-hello fix #806 `1e4f9104`. All six OPEN, DRAFT, MERGEABLE; #806 shows 22/22 checks green.
- `llm` advanced `d092e0e259` → `ec6deecfec` (six commits: content-store powers #585, endor top-level-await #805, endor referrer-relative resolution #812). None touch OCapN/Noise; every stack PR re-verified MERGEABLE against the new base, so per the settled policy (restack only on CONFLICTING or degraded checks) no rebase.
- #806 still has zero reviews/comments — its merge into `llm` remains the next external unblock.

**Live proofs (real command output captured this dispatch, from a fresh worktree at #693 head `73ad1b6d`, `corepack yarn install` clean in ~6s off the warm cache):**
- Both endpoints answer 426: `https://minion.town/ocapn` and `/ocapn-daemon`.
- Greeter demo (`demo/minion-town/run-demo.sh`): SSM-fetched the live daemon location (designator `810b996c…`, unchanged since dispatch 13), dialed `wss://minion.town/ocapn`, Noise IK completed, `RESULT {"ok":true, "reply":"Hello, the local peer!…"}`.
- Cross-host Pet-Daemon invite/accept (`run-cross-host.sh`): invitation minted on the minion.town daemon (container at `a371b007`), accepted by a local Pet Daemon over `wss://minion.town/ocapn-daemon`, peer bound as `minion`, `E(adder).add(2,3) = 5` plus greeting round-trip → **CROSS-HOST DEMO PASSED**. Trailing `Termination requested` is the known benign teardown race.

**What changed:** memory `ocapn-over-noise-goal` updated to record dispatch 14 and the new `llm` head. No evidence comment posted on #693 (nothing changed since dispatch 11's comment — no-repeat policy). No garden or project commits needed. One environment note for future dispatches: this fresh worktree needed `PATH=$HOME/.local/bin:$PATH` for the `aws` CLI before the SSM-backed demos run (already recorded in memory).

**Follow-ups:** (1) merge of #806 (green, unreviewed) into `llm` is the next external unblock; the restack after it lands inherits the crossed-hello settlement fix. (2) The likely next implementation arc remains design #794 (key-only session boundary) — designer/builder scope, not press scope. (3) Standing open items unchanged: mutual bidirectional pairing, `daemon-agent-network-identity`, session-reconnect design, remote TCP+CBOR blocked by minion.town's 443-only security group.
