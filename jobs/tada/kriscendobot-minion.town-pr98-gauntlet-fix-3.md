CI is **GREEN** (rc 0). The fix is pushed. Per the job, I stop here and do not re-run the panel (the driver re-posts panel-4).

## Completion report

**Job:** kriscendobot/minion.town PR #98 gauntlet — FIX stage, round 3 (design panel).

**What I did:** Applied the round-3 design panel's must-fix items (and the high-confidence should-fixes) to the single design doc `designs/claude-on-minion-town-evaluation.md`, grounding each change against the companion designs the panel cited.

**Changes (one commit `d76c9b4`, +308/−146):**
- **Zero-turn defense reframed (critic, skeptic, decomplector, novice).** Dropped the false "parent holds no path" claim — the child *is* an entry in the parent's guest directory, so `E(guest).lookup(child)` reaches it. The defense now rests on a **per-child inference attestation** (`{childFormulaId, credentialKind, openedAt, closedAt}`) the credential broker emits over a named oracle-only channel, correlated by the oracle **from recorded values**; a direct parent-side call carries no matching attestation and grades as isolation failure. Fail-closed if the channel is unavailable. Distinguished this from the companion's per-`iss+sub` concurrency lease.
- **Endowment seam vs `create` contract (critic, ergonomist).** Stated failure modes as tagged sentinels in `create`'s never-reject idiom (`ticket-spent`, `ticket-principal-mismatch`, `ticket-name-mismatch`, `ticket-scenario-unknown`), resolved the get-or-create collision via name binding, and specified that a rejected redemption provisions no child and does not burn the ticket. Added the negative check.
- **Grader independence (decomplector).** Split the single `observer-token` into a seal-check token and an effect-observation token; gave the verifier its own oracle-granted authority minted at `prepare` (never routed through the harness, no harness-supplied observation), writing the verdict straight to the artifact store.
- **Harness hygiene (skeptic, decomplector).** Made the diagnostic mirror non-fatal so it cannot preempt the authoritative verifier; archive evidence before `rm -rf`.
- **`@`-sigil transport ambiguity (skeptic).** Made the fixed task text sigil-free; each transport attaches the ticket its own way; fixed the stale comment.
- **Actor roster (novice)** added before the first section that reasons about the authority split; **concurrency prerequisite (critic-3)** added (parent turn ends before the child's, durable inbox re-triggers; per-subscription concurrency>1 named as the only alternative).
- **should-fixes:** reconciled the guest-owned invite shape with `remote-guest-endo-cli.md` § 3, renamed `localPeerName`→`localPetName`, defined an ordered stage enum, stated a re-run budget, and applied the `§ N` / `PR #N` citation, HTTP(S), heading-numbering, and cross-reference fixes. Kept the doc em-dash-free and typist-clean (only `§`, the corpus convention, is non-ASCII).

**Push & CI:** Pushed as follow-up commit `349f684..d76c9b4` to the PR head via `safe-push-pr-head.sh` (advance mode). Bounded CI watch returned **GREEN** (1/1 check, rc 0).

**Follow-ups:** None from me. The gauntlet driver re-posts panel round 4; I did not re-run the panel. Note the design remains a spec-only proposal whose several new prerequisites (per-child attestation channel, broker abstraction, `api-token` kind, `endowments` seam, PR #1125 guest-owned invite) are explicitly unbuilt.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr98-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2832780 cached reads)
- Output: 44204 tokens
- Cost: $3.630345
- Wall-clock: 817s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
