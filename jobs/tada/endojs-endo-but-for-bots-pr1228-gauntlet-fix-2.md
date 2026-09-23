CI is green (rc 0). All three panel must-fix items are applied, pushed as a follow-up commit, and CI passed.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1228 — gauntlet FIX round 2 (design-doc PR: `design(claude): finish the bare CLI caplet contract`).

**Panel round-2 must-fix items applied (all three):**

1. **critic #1** — The acceptance condition didn't gate the load-bearing DD6 residual (co-located-daemon cross-guest escalation). Added **step 6** to § *Acceptance condition* asserting the fail-closed isolation gate, so the design's own acceptance test can no longer pass while that precondition is silently unenforced.

2. **decomplector #1** — DD6's cross-guest invariant was prose-only, enforced by nothing. Made it a **checked value**: `make(powers, context, options)` / `makeGuestInference` now take an explicit `options.isolation` attestation (`separate-uid` / `sandbox-slice` / `co-located-trusted`) and **fail closed** absent a recognized value, rather than launching an unwrapped child against a co-located many-guest daemon by default. Threaded the attestation through the § *Package shape* `make` signature and the `harness.js` seam comment.

3. **novice #1** — § *Status* opened with framing (CLI-vs-SDK path, "hermetically-sandboxed") that presupposed § *Prompt* ~1800 lines later. Added a self-contained **Orientation** paragraph so a top-down reader gets the referent up front.

**Also fixed opportunistically** (copyeditor finding, in the same DD6 passage I was editing): dropped the stray self-referential "exactly the threat the removed earlier text named" edit-diary note.

**Hygiene:** Kept all new prose em-dash-free (pedant rule); verified no em-dashes in added lines. Reverted an unrelated `packages/floot/package.json` normalization the install tool introduced; committed only `designs/endo-claude.md`.

**Push & CI:** Committed as a review-feedback follow-up and safe-pushed to the PR head `endojs/design/endo-claude-bare-caplet` (`86b0ebf14 → 517db9870`). Bounded CI watch returned **rc 0 / CI GREEN** (7 checks: 6 success, 1 skipped).

**Follow-ups:** Should-fix/comment-only items (roadmap/README confidence-overstatement, overloaded "confined" vocabulary, anonymous `GuestMcpHandle` record, idempotency contracts, #1206 citation linking, remaining pre-existing em-dashes) were left for the driver's re-posted panel-3 to re-assess per the stage's "apply must-fix once, then stop" contract. Panel not re-run (driver owns that).

Stopping here as instructed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1228-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2239895 cached reads)
- Output: 15832 tokens
- Cost: $2.2103505
- Wall-clock: 863s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
