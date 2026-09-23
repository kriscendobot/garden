Press dispatch complete — this was the first non-steady-state dispatch since 07-27, driven by fresh maintainer motion.

**What happened tonight (maintainer actions at 00:09–00:11Z, found on assess):**
- kriskowal **APPROVED #340** (the stack bottom, transport PR).
- kriskowal replied **"Authorized."** on #683's `DEMO-REPORT.md` line 146 — the option-(a) line about touching the live host "(Caddy config, possibly the security group)" — answering the TCP-port question that had been open since 07-17.

**What I did:**
1. **Un-drafted #340** (`gh pr ready`) — it was approved, MERGEABLE, all checks green. I did *not* merge: that's the conductor's verb and awaits the maintainer's explicit word (surfaced via maintainer message `20260729T013334Z-5d108e`).
2. **Proved cross-host raw TCP+CBOR — the last unproven transport/topology cell.** Wrote a TCP+CBOR toy greeter server/client pair mirroring the ws toy, smoke-tested locally, then: opened SG ingress `tcp/8929` on minion.town's `sg-0f2cf8d86744b7293` (rule `sgr-0d9fc044a33568003`, with the authorization cited in the rule description), deployed `endo-ocapn-tcp-demo.service` (docker, reusing the existing image — disk is at 82%, no rebuild; the new script bind-mounted over its in-tree path), and dialed it from the garden: **live cross-host Noise IK capability round-trip over raw TCP + netstring CBOR PASSED** (`RESULT ok`, nodeId `c1ac846d…` = advertised designator). Cross-host is now proven over **both** OCapN.md transports.
3. **Landed the artifacts on #693** (commit `803ef977f`): server, client, unit file, live transcript, and a README section under `packages/daemon/demo/minion-town/`. Evidence comment: #693 `issuecomment-5111714349`; acknowledgment reply on the #683 authorization thread.
4. Steady-state checks all clean: heads otherwise unchanged, zero non-passing checks on all five PRs pre-push, `llm` advanced to `20528678a6` (#705, no conflict — all five re-polled MERGEABLE), both wss endpoints 426, inbox empty. Memory updated.

**Follow-ups:** next dispatch confirms CI on #693's new head; watch for the maintainer's "merge #340" word (then restack as the stack lands bottom-up); optional daemon-level cross-host TCP (the deployed boot script gates only `ws-listen-addr`); the SG rule stays open for reproducibility unless the maintainer asks to revoke it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-noise-press-20260729-012002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 103 tokens (4641270 cached reads)
- Output: 45103 tokens
- Cost: $9.147960999999997
- Wall-clock: 752s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
