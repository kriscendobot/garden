# Press dispatch 7 (2026-07-18 12:20Z) — steady state, all green, live proofs re-passed

**Assessment.** M1–M5 remain fully proven. All four stack heads are unchanged since the 06:20Z dispatch (#340 `ceba59e6fe` → #684 `eecc1246e7` → #688 `7c9a0e212f` → #693 `97b8499e95`; #683 untouched at `64b6dac549`). All four are **MERGEABLE / CLEAN with zero non-passing checks**. `llm` advanced 7 commits (daemon content-locator + data-planes work, #783/#789) without conflicting the stack, so I did not rebase — the press's settled policy is to restack only when a PR goes CONFLICTING or checks degrade.

**Live validation (real command output, not code-reading):**
- Both durable Caddy endpoints answer `426 Upgrade Required`: `https://minion.town/ocapn` and `/ocapn-daemon` — the repo-landed routes (minion.town PR #9) held through CD.
- Toy-service greeter round-trip over `wss://minion.town/ocapn`: `RESULT {"ok":true, "nodeId":"810b996c…", "reply":"Hello, the local peer! …"}` — full Noise IK + capability invocation via `run-demo.sh` (location fetched live over SSM).
- Full cross-host Pet-Daemon invite/accept over `wss://minion.town/ocapn-daemon`: **CROSS-HOST DEMO PASSED** — accept resolved, minion peer bound under pet name `minion`, `E(adder).add(2,3) → 5` plus greeting round-tripped across the Noise session. The trailing `CapTP … Termination requested` is the known post-pass teardown race.

**Changes made.** None to any repo — nothing was broken and heads didn't move, so no evidence comment was posted (dispatch 6's issuecomment-5010229283 remains current). Updated the `ocapn-over-noise-goal` memory with the dispatch-7 status and the rebase policy.

**Follow-ups (unchanged, for future dispatches or separate jobs):** (c) mutual bidirectional-dialable pairing; (d) `daemon-agent-network-identity` binding (#340 carries the stopgap); (e) `ocapn-noise-session-reconnect` design still Proposed/unimplemented; (f) cross-host TCP+CBOR blocked on the unanswered maintainer question about opening a non-443 port on minion.town's security group (do not re-send). Next dispatch: re-check llm drift, CI, endpoints; rebase only if CONFLICTING.
