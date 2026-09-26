The job is complete. Let me summarize.

## Completion report

**Job:** Address the CHANGES_REQUESTED review by @kriskowal on kriscendobot/minion.town PR #47 (a design doc, `designs/weblet-ocap-synthesis.md`).

**Re-derivation of state (clean requeue):** The review has no inline comments — it's a single top-level body directive asking to revisit the design "from a fresh direction." Preflight returned PROCEED (no correlated peer resolution). The PR branch HEAD was still the original commit `7a4aea7` — no prior attempt had pushed a revision — so I did the work from scratch.

**What the review asked for:** every fresh guest gets a `@sites` power; use it to create weblets whose durable storage is an arbitrary Endo directory conventionally holding `front` (frontend readable tree) and `back` (a capability the frontend reaches over CapTP to its own websocket); publish via `E(guest).evaluate` calling `E(sites).register(directory)`; the site watches the directory for `front`/`back` changes and updates static content and dynamic capabilities.

**What I did:**
- Rewrote `designs/weblet-ocap-synthesis.md` (§§ 2–9) around the `@sites`/`register(directory)`/`front`+`back`/watch model, replacing the earlier `makeWeblet`-synthesis-of-`{content-lookup, powers}` framing and the separate `weblet_upgrade` re-point verb (upgrade now falls out of the directory watch → `E(directory).write`). Identity re-keyed on the registered directory's stable formula id. Grounded the seams in the real code (`composeFacet` grant site, `guest-tools.ts`, `gateway/`, `powers-source.ts`).
- Preserved the ocap conclusion — introduction, not gateway-authority name resolution — and kept `assertValidPowers`/`assertNotHostShaped`/close `4012` deleted; updated migration, acceptance criteria, and follow-on units to match. Recorded the revision provenance at the top.
- Validated the mermaid diagram parses (parse-only, `OK flowchart-v2`).
- Committed `27227f1` and pushed to `design/weblet-ocap-synthesis` via a rebase-CAS push.
- Posted a summary reply on PR #47 (issuecomment-5337789212) mapping each ask to the section that resolves it.

**Changed:** `designs/weblet-ocap-synthesis.md` (+271/−207). Design-doc-only; no code/DNS/cert/deploy change. **Follow-ups:** none — the § 9 implementation units are captured in the doc for future build jobs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr47-review-237136a0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 2 host(s) (8 unmetered)
- Input: 33 tokens (1111220 cached reads)
- Output: 22426 tokens
- Cost: $1.7755759999999998 (8 engagement(s) unpriced)
- Wall-clock: 528s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
