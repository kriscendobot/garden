---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr47-review-237136a0
verdict: not-a-miss
category: new-direction
review_at: 2026-08-17T23:22:53Z
repo: kriscendobot/minion.town
pr: 47
comment_url: https://github.com/kriscendobot/minion.town/pull/47#pullrequestreview-4955373305
identity: kriscendobot/minion.town#47:review:4955373305
---

Maintainer CHANGES_REQUESTED review on the design doc `designs/weblet-ocap-synthesis.md`.
The maintainer asks to revisit the design from a fresh direction and lays out a specific
new architecture for weblet publishing (a guest-endowed `@sites` power, weblet durable
storage as an arbitrary Endo directory conventionally holding `front`/`back`, publishing
via `E(guest).evaluate` calling `E(sites).register(directory)`, and a site that watches
the directory for changes). See comment_url for the verbatim text.

Grounds: this is quintessential design-owner taste and a first-stated requirement, not a
review-process miss. The maintainer is the author/owner of this design's direction and is
iterating on the architectural *approach* of a design document — the `@sites`/
`register(directory)`/`front`+`back`/watch model appears for the first time in this review
and had never been articulated in the PR, an earlier design, a seat brief, a skill, or any
standing instruction. No panel seat, gate, or convention could have anticipated the
maintainer's preferred alternative architecture; a design panel evaluates a design against
known criteria, it does not invent the owner's next architectural preference. This is the
essence of design authorship, not a gate the review skipped. Notably this same design PR
was *born* from a prior fresh-direction redirect (the maintainer's review closing its
predecessor #44 steered toward ocap synthesis), and #47 is a further iteration on that —
serial design steering by the owner, the designed path, not a forming defect pattern.

No evaluator-gaming/avoidance shape: the producer did not route around a gate to escape
scrutiny. The PR went through the standard gauntlet (gauntlet-clean is a completed no-op:
design-doc-only, CI green, already un-drafted); its panel-1 stage was later doomed
(requeue-exhausted 2026-08-18) and the gauntlet halted loudly — but the maintainer's
review landed 2026-08-17, on the owner's own timeline, and a panel completing would not
have produced "revisit from a fresh direction." This is not the `garden-design-pr-gauntlet-bypass`
avoidance pattern (which concerns the garden's own open-questions design carve-out reaching
review with no design panel); here a project-fork design doc simply received owner design
feedback.

World-grounded, not trusting the primary report: the primary did real work (it is not a
no-op) and its deliverable genuinely exists — the design was rewritten around the requested
`@sites`/`register(directory)` model and pushed (primary commit `27227f1`), the maintainer
then APPROVED review 4998095265 at head `7973ac34d42` on 2026-08-21T23:14:40Z, and PR #47
is MERGED (merge commit `04519fa3ffe`, 2026-08-21T23:18:21Z). The fresh direction was
delivered and accepted. No discrepancy to report.
