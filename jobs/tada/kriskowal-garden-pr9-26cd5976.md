The work is complete. Here is my report.

---

## Completion report: attention directive on kriskowal/garden#9

**Directive (untrusted-input, re-fetched):** kriskowal asked, while waiting for a mainnet snapshot, for a precise accounting of the ymax0 v320 XS value-stack overflow: how slots are consumed and why it stops there; is it the Map; are module lexicals on the stack; per-frame slot counts; does inlining the loop help; does reducing hex just defer it a turn; does raising the stack limit break on-chain snapshot compatibility; and can that be verified with the snapshot + Inquisitor.

**Routing:** This is the slot-accounting workstream on garden#9. Questions 1–5 were answered by prior measured rounds; #6 was analytical; #7 was genuinely new; #8 is gated on the pending snapshot. Rather than recite possibly-inconsistent recalled numbers, I re-ran the on-host instrumented worker to get authoritative data and grounded the snapshot answer in the actual XS source.

**What I did:**
- **Re-measured fresh** on `worker-4096-symbolicated`: unpatched `bundle-ymax0` → exit 12, 4096/4096 slots, 9 frames (histogram CLOSURE=2003, REFERENCE=1909). Patched (`flatMap`→loop, 10→9 sites) → clean import to the full export set at stock 4096. This **resolved a cross-round attribution wobble**: frame#0 (1238 slots) is 1232 *references*/0 closures (the transient hex pair-arrays); frame#1 (2588 slots) is 1986 *closures* (the persistent module-functor baseline). The loop removes the references; the structural closure baseline remains.
- **Answered #7 from source** (`xsSnapshot.c` + `xsnap-worker.c`): raising `stackCount` does **not** break snapshot compatibility — `fxReadSnapshot` gates only on version/arch/`"xsnap 1"` signature; `stackCount` is per-snapshot CREA-atom data, `fxAllocate`d from the snapshot, not the binary. So a taller binary only enlarges fresh-machine creations (a vat upgrade is fresh-machine, so it does benefit); old-snapshot vats keep 4096. The real risk is determinism → lockstep validator cutover.
- **Posted the accounting** as a comment on garden#9 (as kriscendobot, the established channel): https://github.com/kriskowal/garden/issues/9#issuecomment-4839184870
- **Parked the gated #8 verification** as go-ahead plan job `verify-ymax0-hex-fix-inquisitor` (promote when a swing-store is captured), so the Inquisitor round isn't lost.
- **Committed a skill note** to main2 (`skills/agoric-chain-snapshot`, pushed `dbc371bed..1a2940a11`) recording the stackCount/snapshot-compat finding for the verification round.
- **Updated durable memory** (`reference_xsnap_xs_repro_without_agoric_build`) with the snapshot-compat finding and the fresh trace.

**Follow-ups:** (1) The inquisitor round (plan job above) once a snapshot lands. (2) One number I did not directly measure: the *patched* bundle's own overflow threshold (a downward `stackCount` bisection would pin the remaining structural baseline to a number); flagged in the comment as a cheap optional follow-up.

**Self-improvement:** Folded the new XS snapshot/`stackCount` compatibility finding into the canonical `agoric-chain-snapshot` skill (not just memory), so the future verifier reads it in the doc it follows — per the "encode directives in the always-read procedure doc" lesson.
