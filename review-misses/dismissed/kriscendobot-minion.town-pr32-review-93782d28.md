---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr32-review-93782d28
verdict: not-a-miss
category: new-direction
pr: 32
repo: kriscendobot/minion.town
identity: kriscendobot/minion.town#32:review:5119091125:retro
comment_url: https://github.com/kriscendobot/minion.town/pull/32#pullrequestreview-5119091125
review_at: 2026-09-05T00:59:13Z
severity: minor
grounds: |
  A house test-runner preference stated for the first time in this review. The
  PR's tests were written in the repo's own established runner. PR #32
  (fix(deploy): enforce and verify Endo daemon startup contract, head
  feat/b3-deploy-coherence-guard, base main-b5bfb92) went through several panel
  rounds before this review. Bot PR comments from 2026-09-01 to 2026-09-02 record
  successive panel follow-ups (heads 9a1011d, c1cfcb7, 818230d, 355804e,
  f495a00, 8378fc2), so the evaluator ran and was not skipped. Review 5119091125
  (CHANGES_REQUESTED, kriskowal, 2026-09-05) says the shop uses ava for testing.
  At the PR base, package.json had `scripts.test = "vitest run ..."`,
  `vitest: ^2.1.8`, and no `ava` dependency. main still has the same Vitest
  setup today. The new deploy-coherence suite followed the tree's documented
  convention. No garden seat brief, skill, context page, or COMMON.md norm says
  that minion.town (or the maintainer's projects in general) must use ava. A
  grep of roles/, skills/, and context/ finds no such rule, so a
  stylist/purist/packager seat had no basis to flag it. This is not a violated
  convention. Four minutes later the same maintainer made the same statement on
  #45 (review 5119105749), and that retro was also dismissed as new-direction on
  the same grounds. The two reviews are one first-statement of a preference, not
  a missed standing rule.

  This is not evaluator-gaming. The panel ran for real, and the measurement did
  not move. I checked whether the primary actually delivered: the bot's follow-up
  comment at head 1117138 (2026-09-05T03:09Z) reports that the root Vitest runner
  was replaced with AVA 6.4.1, all 36 root test files were migrated, and the CI
  test job was updated. The PR file list confirms vitest.config.ts was removed
  and test/ava-compat.{js,d.ts,test.ts} were added. The primary's deliverable
  exists, so there is no no-op discrepancy to report.
---

Maintainer review 5119091125 (CHANGES_REQUESTED) on minion.town PR #32 asks that
tests use ava, the shop's preferred runner. The PR had used Vitest, which was
the repo's own established runner at base and still is on main. No garden
standing rule encoded an ava preference, and panels ran on this PR. This is new
direction and is dismissed. The primary migrated the suite to AVA at 1117138.
Re-fetch the verbatim review body at comment_url.
