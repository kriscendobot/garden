I've checked the PR's state, reviews, and the current `llm` history. Now writing the viability report.

## Viability report: PR #1357 on endojs/endo-but-for-bots

The gauntlet can proceed. The PR is open and still relevant. Nothing on `llm` replaces this design, and the maintainer is still working with it.

**PR facts:**
- State: OPEN, draft, not merged.
- Title: "design(claude): back-fill inference backends from the minion.town experiments".
- Head: `design/endo-claude-inference-backends` @ `7a6d4259`.
- Base: frozen `llm-47f6965` @ `47f6965d`.
- The diff is design-only: `designs/endo-claude-inference-backends.md` plus its rows in `designs/README.md`.

**Deciding question:** Does the current `llm` branch, or any newer PR or design, already contain the provider-neutral `@endo/inference` seam and the minion.town-informed Claude backend design? Or has the maintainer dropped the back-fill request from the #1228 review? If the answer to both is no, the PR has not been superseded and its premise still holds.

**Evidence:**
- **The maintainer still wants this design.** kriskowal answered all four open questions inline on 2026-09-29 around 05:25Z:
  - Use kriscendobot's subscription for the root user.
  - Multiple subscriptions are required.
  - `@endo/inference` should be provider-abstract.
  - "I need real evidence".

  He left CHANGES_REQUESTED ("rsvp"), not a close. The bot resolved all four in commit `7a6d425` and linked the evidence probe, draft #1369. #1369 is a gap-revealing prototype *of this design*, so it supports the PR rather than replacing it.
- **No replacement exists on `llm`.** `designs/endo-claude-inference-backends.md`, any inference design, and `packages/inference/` all return 404 on `llm`. A title search for "inference" finds only #1357, the #1369 probe, and #995. #995 is the earlier merged design that this document builds on.
- **The only relevant new work on `llm` is #1015** (`@endo/claude` confinement core), merged 2026-09-29T06:09Z. The design already treats #1015 as "the implementation Decision 2 reshapes into `@endo/inference`, a sandbox-free `@endo/claude`, and a sandbox composition." So #1015 is input to this design, not a replacement for it.
- **The motivating premise still holds.** minion.town still carries two diverging Claude confinement reimplementations (kriscendobot/minion.town#105 and #106). The #1228 review's request to "back-fill this design and solidify in Endo later" has not been met anywhere else.

**Stale text for the fix loop:** Decision 2 (around line 358 of the design) still says "#1015 is unmerged", but #1015 merged on 2026-09-29. The Status text and the pinned version (2.1.268) should also be updated to the 2.1.278 that #1369 observed. These are fix-loop edits, not reasons to stop.

I made no changes: no commits, no pushes, no jobs posted.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (271685 cached reads)
- Output: 2939 tokens
- Cost: $0.473949
- Wall-clock: 39s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
