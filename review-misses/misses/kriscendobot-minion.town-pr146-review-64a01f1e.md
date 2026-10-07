---
kind: review-miss
primary_job: kriscendobot-minion.town-pr146-review-64a01f1e
verdict: miss
category: style-convention
pr: 146
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code uses or reimplements a lower-level primitive where an existing @endo/* package provides the project-standard abstraction, while authoring checks and review fail to direct the producer to reuse it.
review_at: 2026-10-02T01:46:26Z
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/146#pullrequestreview-5387502389
identity: kriscendobot/minion.town#146:review:5387502389:retro
producing_role: builder
producing_job: minion-town-pr140-endo-cancel
missed_by: purist (reuse-over-reimplementation axis) / procurer (build-vs-buy; provider not indexed)
severity: moderate
grounds: |
  PR 146 was itself the follow-up to the PR 140 miss (already in this cluster),
  whose directive was to use the @endo/cancel package. At reviewed head 1258647
  the builder instead added a hand-written TypeScript port of the upstream
  makeCancelKit (src/endo/cancel-kit.ts) because @endo/cancel had no public npm
  release. The maintainer's review asked for the upstream JavaScript package to
  be consumed directly, fixing its TypeScript consumability upstream if needed,
  rather than duplicating JavaScript dependencies as local TypeScript copies.
  That is the standing reuse rule this cluster already carries (purist's
  reuse-over-reimplementation axis, landed 37b04ec909 on 2026-08-04, and the
  build-vs-buy skill "don't re-author what a package already exports", landed
  2026-09-24), not new direction; the language-conversion remark is incidental.

  The panel ran two full rounds (panel-runs/kriscendobot-minion.town-146/
  677588ce0f46 and the round-2 run) before the review. Every seat that noticed
  the copy (stylist, breaker, curator, surfacer, saboteur, others) called it a
  "faithful vendored port" and accepted "the package is unpublished" as the
  justification; purist was comment-only then approve; procurer was
  comment-only. Mechanically the build-vs-buy detector could not fire: the
  journal has no config/export-index-providers file at all, so the endo
  provider exports are never indexed for minion.town, and a provider that is
  not yet a dependency classifies as "blocked", which both the pre-push probe
  and the procurer silence. Standing rules existed and did not bind: an
  "upstream is unpublished" loophole licensed the duplication. Not evaluator
  gaming: the change did not alter what any check measures.
---

# Review miss: vendored TypeScript port of an unpublished @endo package

The follow-up to an earlier "use the Endo cancellation package" review vendored
a local TypeScript copy of that package's kit, because the package had no public
release. The maintainer asked to consume the upstream JavaScript package
directly instead of duplicating it. Two panel rounds saw the copy and accepted
"unpublished" as a reason to vendor; the build-vs-buy detector had no provider
index for this repo. This is a bot-authored paraphrase; the original review is
available only through `comment_url`.
