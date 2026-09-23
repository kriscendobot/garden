Press dispatch 8 (2026-07-18 18:35Z) — steady state confirmed, all live proofs re-passed. Report:

---

# Press dispatch 8 (2026-07-18 18:35Z) — steady state; M1–M5 remain proven live

**Assessment.** No motion since dispatch 7 (12:20Z). All five stack heads are byte-identical to the last record: #340 `ceba59e6fe` → #684 `eecc1246e7` → #688 `7c9a0e212f` → #693 `97b8499e95`, with #683 untouched at `64b6dac549`. All four stack PRs are OPEN/DRAFT/**MERGEABLE** with **zero non-passing checks** (#340 25/25, #684/#688/#693 23/23 each). `llm` sits at `b43e801633` (the daemon content-locator/data-planes advance) without conflicting the stack, so per the settled press policy — restack only on CONFLICTING or degraded checks — no rebase was performed.

**Live validation (real command output, this dispatch):**
- Both durable Caddy endpoints answer `426 Upgrade Required`: `https://minion.town/ocapn` and `/ocapn-daemon` — the repo-landed routes (minion.town PR #9) continue to survive CD runs.
- Toy-service greeter round-trip over `wss://minion.town/ocapn` via `run-demo.sh` (daemon location fetched live over SSM): `RESULT {"ok":true,"nodeId":"810b996c…","reply":"Hello, the local peer! — greetings over OCapN-Noise-WS from the minion.town host."}` — full Noise IK + capability invocation through Caddy TLS 443.
- Full cross-host Pet-Daemon invite/accept over `wss://minion.town/ocapn-daemon` via `run-cross-host.sh`: **CROSS-HOST DEMO PASSED** — invitation minted on the minion.town Pet Daemon over SSM, accepted by a freshly booted local Pet Daemon, minion peer bound under pet name `minion`, `E(adder).add(2,3) → 5` plus the greeting round-tripped across the Noise session. The trailing `CapTP … Termination requested` is the known post-pass teardown race.
- Both demos ran read-only from the reuse worktree `scratch/project-wt-ocapn-noise-press-20260717-182002-0ce34f17` (already at #693 head with deps installed).

**Changes made.** None to any repo — nothing was broken and no heads moved, so no PR evidence comment was posted (dispatch 6's issuecomment-5010229283 remains current). Updated the `ocapn-over-noise-goal` memory: folded dispatches 7–8 into one steady-state paragraph and recorded a reuse-worktree gotcha (`$HOME` *is* the garden root, so the demo PATH prefix is `/home/kris/garden/.local/bin`).

**Follow-ups (unchanged, for future dispatches or separate jobs):** (a) drive the stack toward un-draft; (c) mutual bidirectional-dialable pairing; (d) close `daemon-agent-network-identity` (#340 carries the stopgap); (e) `ocapn-noise-session-reconnect` design still Proposed/unimplemented; (f) cross-host TCP+CBOR still blocked on the unanswered maintainer question about a non-443 port in minion.town's security group (do not re-send). Next dispatch: re-check llm drift, CI, endpoints; rebase only if CONFLICTING. Note the live peer `endo-daemon-data-plane-press` is working llm-side daemon code — if its landings ever conflict the base of #340, that's the likely trigger for the next restack.
