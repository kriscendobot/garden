---
role: builder
tier: mentor
arc: garden-book
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=high at=2026-10-16T04:17:37Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
arc: garden-book
---

# Finish garden-book illumination merge and immutable republication after review-budget authorization

This is the durable successor to
`garden-book-illuminations-finish-after-gauntlet-20261014` and owns all
remaining work from that job.

The staged gauntlet `kriscendobot-garden-book-pr15-gauntlet` ended on
2026-10-15 with `gauntlet-status: review-budget-reached` after six panel/fix
rounds. The last fix addressed every round-6 must-fix and moved
https://github.com/kriscendobot/garden-book/pull/15 to exact remote head
`f1b549b89cfcdc53f15aa153adc2899d9f4c0145`, but the review budget ended
before panel 7. The PR remains draft. Do not merge it without a clean gauntlet.

This plan item requires maintainer authorization to grant more gauntlet rounds.
After promotion, resume with:

    scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-garden-book-pr15-gauntlet panel --add-rounds 2

Wait in the foreground until the staged gauntlet is terminal. If it passes,
complete every remaining step from the predecessor specification: adopt the
exact reviewed head; retarget the frozen base to live `main`; safely rebase and
merge with a merge commit; sweep frozen bases; fetch the merged `main`; run
`npm ci`, `npm test`, the 27-file build, and real Chromium checks; publish a new
immutable clip with the checked `build/publish.mjs` and an inert
`garden-book-*` power; compare all 27 served bytes and immutable headers; run
the live book at 390x844 and 1440x900 in light and dark, checking all 25
illuminations, all placements, nine charts, the glyph sprite, and layout; record
the edition in `build/README.md`; open the history PR only through
`ensure-pr.sh`; run one staged gauntlet; merge only if clean; sweep its frozen
base; and send the maintainer the root cause, PR links, and verified URL.

Evidence already collected at `f1b549b` by the predecessor (rerun after any
head movement): `npm ci`; `npm test` passed 80/80; build emitted 27 files;
`tools/browser-check.mjs out/index.html` passed all four 390x844/1440x900
light/dark configurations with 25 rendered figures, no overflow, and no
reported clipping, overlap, or CSP violation.

Never publish or merge while the gauntlet is failed, draft, red, conflicted, or
not exact-head fresh. Never republish an old edition or omit the history PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-16T04:50:06Z
