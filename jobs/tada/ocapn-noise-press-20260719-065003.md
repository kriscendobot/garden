All done — inbox empty, message delivered, nothing to commit to `main2` (this dispatch changed no garden library files). Final report:

---

# Press dispatch 9 (2026-07-19 06:50Z) — poisoned predecessor's restack verified sound; M1–M5 re-proven live at new heads

**Assessment.** Motion since dispatch 8: the 00:35Z dispatch (`ocapn-noise-press-20260719-003513`) restacked the entire stack at 00:38Z — endojs/endo-but-for-bots#340 → `6eb312743e`, #684 → `cc398cb179`, #688 → `469335e661`, #693 → `73ad1b6d0c` (#683 untouched at `64b6dac549`) — but was repeatedly wedge-killed and **poisoned** (parked in `jobs/plan/`, notice already in the maintainer inbox). Its pushed restack survived and is coherent: all four stack PRs OPEN/DRAFT/**MERGEABLE** with zero non-passing checks (#340 25/25; #684/#688/#693 23/23 latest runs). `llm` advanced to `00a04f5b4f`; #340 is behind but not conflicting, so per the settled press policy no further rebase.

**Live validation (real command output, this dispatch, from the reuse worktree fast-forwarded to `73ad1b6d0c` — no dep-manifest delta, so installed deps stayed valid):**
- Both durable Caddy endpoints answer `426 Upgrade Required` (`https://minion.town/ocapn`, `/ocapn-daemon`).
- Toy greeter over `wss://minion.town/ocapn` via `run-demo.sh`: `RESULT {"ok":true,"nodeId":"810b996c…","reply":"Hello, the local peer! — greetings over OCapN-Noise-WS from the minion.town host."}` — full Noise IK + capability invocation through Caddy TLS 443.
- Full cross-host Pet-Daemon invite/accept over `wss://minion.town/ocapn-daemon` via `run-cross-host.sh` (with `SSM=ssm.sh` override; `minion-ssm.py` needs absent boto3): **CROSS-HOST DEMO PASSED** — invitation minted on the minion.town Pet Daemon via SSM, accepted by a freshly booted local Pet Daemon, peer bound as `minion`, `E(adder).add(2,3) → 5` plus greeting round-tripped. Trailing `CapTP … Termination requested` is the known post-pass teardown race.

**Changes made.** Posted fresh evidence on the PR (the prior evidence comment cited pre-restack SHAs): https://github.com/endojs/endo-but-for-bots/pull/693#issuecomment-5014773879. Messaged the maintainer that the parked poisoned 003513 job's substance is complete and safe to discard (promoting it would duplicate this dispatch). Updated the `ocapn-over-noise-goal` memory with the new heads, the poison story, and the verification. No repo pushes — nothing was broken.

**New direction spotted:** `llm` merged design PR endojs/endo-but-for-bots#794, `ocapn-noise-key-only-session-boundary` (from issue #406, maintainer-directed): move Noise beneath the gateway/daemon handoff so public boundaries carry Ed25519 keys and authenticated plaintext sessions, never Noise frames. This is the likely next implementation arc touching this stack; future dispatches should watch for implementation jobs or conflicts arising from it.

**Follow-ups (unchanged):** (a) drive the stack toward un-draft; (c) mutual bidirectional-dialable pairing; (d) close `daemon-agent-network-identity`; (e) `ocapn-noise-session-reconnect` still Proposed/unimplemented; (f) cross-host TCP+CBOR still blocked on the unanswered minion.town security-group port question (do not re-send).
