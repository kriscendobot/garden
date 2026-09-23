Press dispatch 10 complete. Report:

**What I did (dispatch 10, 2026-07-20 ~02:30–03:20Z):**
- Assessed the stack: heads unchanged since dispatch 9 (#340 `6eb31274` → #684 `cc398cb1` → #688 `469335e6` → #693 `73ad1b6d`), all five PRs open/draft/mergeable, no new comments, directives, or peer workers; inbox empty throughout. Both `wss://minion.town/ocapn*` Caddy routes still answer `426 Upgrade Required`.
- **Re-proved both live cross-host demos at the current #693 head `73ad1b6d0c`** from a fresh isolated worktree: (1) toy greeter over `wss://minion.town/ocapn` — full Noise IK + capability round-trip, `RESULT {"ok":true,…}`; (2) cross-host Pet-Daemon invite/accept over `wss://minion.town/ocapn-daemon` — `CROSS-HOST DEMO PASSED`, `E(adder).add(2,3) → 5` plus greeting round-tripped. Real output captured and cited in the dispatch comment.
- **Root-caused and cleared #688's UNSTABLE merge state** (flagged by today's arc daily): the 07-19 restack fired duplicate workflow runs; the cancelled duplicates' check-runs stuck to the head SHA. Reran all four cancelled runs — three concluded success, the main CI rerun (`29667372128`) was still in progress at close but #688 already reads **CLEAN** (identical tree passed its parallel duplicate 23/23).
- Posted press dispatch 10 on #693: https://github.com/endojs/endo-but-for-bots/pull/693#issuecomment-5018325263

**Repro notes learned:** this container lacks `aws` CLI — SSM via `pip install --user --break-system-packages boto3` + `minion-ssm.py`; a `--mode=skip-build` install breaks the local Pet Daemon (better-sqlite3 native binding) — fix with `corepack yarn rebuild better-sqlite3` (TMPDIR on an exec mount).

**Follow-ups:** next dispatch should confirm rerun `29667372128` concluded success (near-certain). Standing blockers unchanged: cross-host TCP+CBOR awaits the maintainer's non-443-port decision; bidirectional pairing awaits a public address for the garden container; `ocapn-noise-session-reconnect` remains unimplemented; merged design #794 (key-only session boundary) is candidate future work. M1–M5 remain proven at current heads. No garden-library changes were needed on main2.
