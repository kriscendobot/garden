Inbox empty. Fix stage complete: must-fix items applied, pushed, CI green.

## Completion report

**Job:** kriscendobot-minion.town-pr98-gauntlet-fix-5 — FIX round 5 for PR #98 (`designs/claude-on-minion-town-evaluation.md`).

**Panel round-5 must-fix items resolved (one commit, `6d7d7c6`, pushed to the PR head):**

1. **Nonce-propagation prerequisite (convergent: critic + skeptic + novice).** The turn-context→challenge-call nonce propagation — the sole defense against the zero-turn shortcut, previously asserted only in the indicative — is now named as an explicit hard prerequisite. Added a dedicated paragraph in § 7 (and a pointer in § 1.2) specifying it as the *second half* of the mechanism, distinct from the broker-to-oracle attestation channel, naming the responsible layer (the child's inference dispatch / MCP projection / CapTP turn boundary), noting no companion doc delivers it today, and stating it as an open dependency that fails closed — the same treatment § 1's endowment seam and the credential broker already get. Also added to § 7's "Other hard prerequisites" list.

2. **"the companion" resolved (novice).** All four bare "the companion" references to the per-`iss+sub` inference slot now name `claude-agents-capability.md` explicitly (its "Capability shape" section / the `subscription-busy` single per-subscription slot).

3. **Em-dashes (pedant).** All seven prose em-dashes (lines 35, 128–129, 146, 569, 705–706) replaced with colons/parentheses/commas per `skills/em-dash-style`. Verified zero U+2014 remain; a stray one I introduced in the new § 7 text was caught and fixed before commit.

**Notes / hygiene:** Dropped a stray `package-lock.json` engines-field change (`>=20`→`>=20.12`) injected by the worktree's npm warm-cache — committed only the design file via explicit pathspec. Pushed with `safe-push-pr-head.sh --mode advance` (153a88a → 6d7d7c6, clean fast-forward). Should-fix items (Driver/Harness naming, `already-used`→tagged sentinel, `--expect pending`, `section 8`→§ 8, etc.) were left for the driver's re-posted panel-6 to disposition; only must-fix was in scope.

**CI:** GREEN (`ci-wait-merge.sh … --no-merge` rc 0, 1/1 check passed). Did not re-run the panel; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr98-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2730126 cached reads)
- Output: 19225 tokens
- Cost: $2.7291669999999995
- Wall-clock: 395s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
