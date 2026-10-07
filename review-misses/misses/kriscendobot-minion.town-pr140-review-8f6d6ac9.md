---
kind: review-miss
primary_job: kriscendobot-minion.town-pr140-review-8f6d6ac9
verdict: miss
category: style-convention
pr: 140
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code uses or reimplements a lower-level primitive where an existing @endo/* package provides the project-standard abstraction, while authoring checks and review fail to direct the producer to reuse it.
review_at: 2026-10-01T04:49:28Z
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/140#pullrequestreview-5375087214
identity: kriscendobot/minion.town#140:review:5375087214:retro
producing_role: builder
producing_job: build-minion-town-claude-delegation-durability-20260929
missed_by: builder pre-push reuse rule / prefer-endo-primitives gate
severity: moderate
grounds: |
  The review's inline finding identified a newly added platform cancellation
  controller in ordinary Endo application code where the repository convention
  requires the @endo/cancel abstraction except at a platform adapter. This is a
  concrete house-style and reuse failure, not new taste or a scope change. It
  belongs to the existing prefer-endo-primitives cluster: the code selected a
  lower-level platform primitive even though an Endo package already owned the
  domain abstraction. The change did not alter an evaluator's measurement, so
  this is not evaluator gaming.

  The producing builder completed the draft at 0175805 and reported local and CI
  validation, but the PR history and the deterministic completion receipt show
  zero panel rounds before the maintainer reviewed head 55829ef5 and merged it.
  There is no gauntlet or panel job for PR 140 in the journal. Consequently the
  purist seat never had an opportunity to apply its standing reuse-over-
  reimplementation inquiry. The authoring layer nevertheless already carried a
  standing instruction to reach for existing @endo/* utilities, and the
  prefer-endo-primitives pre-push check existed but covered a narrower catalog
  that did not recognize AbortController versus @endo/cancel. Those prevention
  mechanisms failed to bind before the draft reached the maintainer.

  This is moderate rather than major because the package-specific cancellation
  convention was not named in the builder rule or deterministic signature
  catalog, and the independent panel backstop was skipped rather than returning
  a false approval. The primary response is independently visible in the world:
  the inline thread links follow-up PR 146, whose eventual code imports
  makeCancelKit from @endo/cancel. The miss remains review telemetry because the
  maintainer, rather than the gauntlet, supplied the convention and the original
  PR merged before the repair.
---

# Review miss: Endo cancellation abstraction was bypassed

The change used a platform cancellation controller in ordinary Endo code instead
of the repository's cancellation abstraction. Existing reuse guidance and its
deterministic check were too narrow to surface that package choice, and no panel
ran before maintainer review. This is a bot-authored paraphrase; the original
review and its inline finding are available only through `comment_url`.
