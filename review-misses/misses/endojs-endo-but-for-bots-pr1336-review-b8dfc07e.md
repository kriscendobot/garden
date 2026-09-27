---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1336-review-b8dfc07e
verdict: miss
category: style-convention
pr: 1336
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code locally reimplements a helper or primitive that an existing Endo package already exports, while authoring checks and review fail to direct the producer to reuse it.
review_at: 2026-09-24T20:38:54Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1336#pullrequestreview-5307103246
identity: endojs/endo-but-for-bots#1336:review:5307103246:retro
producing_role: builder
producing_job: build-endo-guest-stdio-mcp
missed_by: builder pre-push reuse rule / purist backstop
severity: moderate
grounds: |
  This review is one watcher unit that includes its inline findings. Several of
  those findings identified locally implemented helpers whose authoritative
  equivalents already existed: two promise-kit copies, formula-identifier logic
  owned by the daemon package, and an older remotable-construction form where the
  guarded Exo form was expected. The common failure is reuse discovery, and it
  matches the existing prefer-endo-primitives cluster. The change did not alter
  what an evaluator measured, so this is not evaluator gaming.

  The producing builder already had a standing instruction, landed on 2026-08-04,
  to look for an existing Endo utility before implementing a primitive. The
  purist seat also carried a reuse-over-reimplementation inquiry. Those rules did
  not bind during production, and the then-current pre-push detector recognized
  only a narrower catalog of implementation idioms. The builder's durable report
  confirms that it stopped at the draft PR under the manual-gauntlet policy, so no
  panel had run before this maintainer review. The miss therefore lies in the
  authoring and pre-push layer, not in a panel verdict that had not yet occurred.

  The finding is moderate rather than major because it was caught on a draft
  before the gauntlet and merge. Independent durable evidence confirms the
  response exists: main2 commit 096c055fc18 expanded deterministic checks for
  copied promise kits and the older remotable constructor, and the subsequently
  completed export-index/build-vs-buy work reports a replay in which the PR 1336
  promise-kit copy is rejected. The record remains necessary because the review
  exposed a post-improvement gap in this cluster's original narrow catalog.
---

# Review miss: existing helpers were reimplemented locally

The maintainer review identified several helpers in the draft that should have
been sourced from existing Endo or daemon packages. The producer-side reuse rule
and its narrow detector did not surface those equivalents before the draft was
presented. This is a bot-authored paraphrase; the original review is available
only through `comment_url`.
