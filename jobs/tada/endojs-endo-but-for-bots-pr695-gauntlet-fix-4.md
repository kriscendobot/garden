CI is green. The fix round is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #695 — gauntlet FIX round 4 (design doc `designs/sturdy-refs-agent-surface.md`).

**What I did:** Read the round-4 design panel verdict (aggregate must-fix), verified its key code citations against the checked-out tree (`guest.js:150` mail-attachment comment, `inbox-loop.js` long-lived `runInboxLoop`/`runOneRound` structure), applied the fixes once, pushed, and watched CI to green.

**Must-fix items applied:**
- **critic (mail-attachment locator conflict):** reconciled Phase 2's stripping of `lookupByLocator` with the shipped locator-based mail channel — a `SturdyRef`-carried attachment (resolved via `lookupBySturdyRef`) is the confinement-preserving replacement; bare-locator attachments are unresolvable by an attenuated worker by design, and keeping `lookupByLocator` would forfeit the confinement criterion. Stated the choice explicitly and noted it in Phase 2.
- **skeptic (turn-boundary enforcement):** stated the render-map reset mechanism explicitly (the runtime is one long-lived process with no per-turn teardown), added the round N→N+1 negative test as a Phase 4 step and an acceptance criterion.
- **pedant (em-dashes):** removed all nine em-dashes (rewritten to colons/periods/parentheses); design now has zero em-dashes and no typist-hostile code points.

**Should-fix / comment-only items also applied:**
- critic: folded mailbox storage of a SturdyRef into the deferred retention investigation (a persistent cross-turn channel).
- decomplector + ergonomist: pinned the reserved handle sub-sigil (`@:`) as one shared exported constant plus a cross-package disjointness test (replacing the ad hoc two-example grammar); clarified generic "worker" vs the formula-graph `worker` edge label.
- skeptic: softened the Status token-removal cost (a GC lifecycle fails this design's own auditability bar) and named the cross-turn handoff scope limit against the motivating example.
- copyeditor/pedant/novice: forward-pointed "formula" at first use, unified Status tense, split the dense attenuation paragraph, fixed serial comma and the `closely held` hyphenation outlier.

**Result:** committed `a5a62d75e9` as a review-feedback follow-up, pushed to the PR head via `safe-push-pr-head.sh`, CI terminal **GREEN** (5/5 checks, 0 failed). README date row already in sync. Did not re-run the panel (the driver re-posts panel-5).

**Follow-ups:** none from this stage; the driver drives the next panel round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2925950 cached reads)
- Output: 29797 tokens
- Cost: $3.178858
- Wall-clock: 880s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
