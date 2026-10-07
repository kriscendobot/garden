---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr85-review-f6a41dd9
verdict: not-a-miss
category: new-direction
pr: 85
repo: kriscendobot/minion.town
identity: kriscendobot/minion.town#85:review:5393724080:retro
comment_url: https://github.com/kriscendobot/minion.town/pull/85#pullrequestreview-5393724080
review_at: 2026-10-02T15:36:33Z
severity: minor
grounds: |
  A rationale question that resolved as a scope expansion, with no review
  stage that was due to catch it. Review 5393724080 (COMMENTED, kriskowal, no
  inline comments) asks the bot to restate why open DRAFT PR #85 defers
  rewriting a clip's powers (`back`) on the live @sites path. At that time the
  PR's declared scope was front-content upgrade only, the scope it had held
  since it was opened against designs/clip-ocap-synthesis.md. The bot answered
  (issue-comment 5955947150) that the code's stated reason, module header
  R2(a) "the deployed gateway serves with its powers plane off", was stale:
  the tracked endo-gateway unit arms the powers plane. The maintainer replied
  (2026-10-02T15:53Z) that they were "happy to expand scope to both sides of
  upgrade, run a gauntlet, and retcon". That is a scope decision first made in
  this thread, so it is not a defect review should have flagged.

  Not a `process` miss. Under the manual-gauntlet-trigger regime
  (designs/manual-gauntlet-trigger.md) a draft gets no panel until someone
  asks for one. journal/jobs/tada/ holds no gauntlet or panel job for pr85
  before 2026-10-03, and jobs/gauntlet{,-archived} hold none either. The first
  gauntlet (kriscendobot-minion.town-pr85-gauntlet-20261003, panel rounds 1-6)
  ran because this exchange asked for one. No evaluator was skipped. The
  review also does not show evaluator gaming: no measurement moved.

  Calibration note (not enough on its own to make this a miss): the stale
  R2(a) premise could be checked against the repo's own deploy unit, and the
  09-30 fixer (kriscendobot-minion.town-pr85-fix-ocap-publish-authority) kept
  it when it reworked the upgrade path. If a panel had been running, this is a
  stale-premise docs-drift claim that scribe/integrator could catch, and the
  later panels did catch similar drift (round 5 migrator: DEPLOYMENT.md; round
  6 integrator: PR body and header). If more stale deferral rationales show up
  on PRs that had a panel, record them as docs-drift misses.

  The primary genuinely delivered; it did not close as a no-op. It posted the
  answer and the fixer job minion-town-pr85-powers-upgrade. The deliverable
  exists in the world: PR #85's body now describes in-place upgrade of both
  `front` and `back`, and the 10-03 gauntlet reviewed that head.
---

Maintainer review 5393724080 (COMMENTED, kriskowal) on draft PR #85 asks why
the PR defers in-place upgrade of a clip's powers. The bot's answer showed that
the code's stated deferral reason (powers plane off in deployment) was stale.
The maintainer then expanded the PR's scope to cover both front and back and
requested a gauntlet. This is a scope decision first made in this exchange.
Under the manual-gauntlet regime no panel had run on the draft before then, so
this is a dismissal. Calibration note: the stale R2(a) premise is the kind of
docs drift scribe/integrator catch once a panel runs. Re-fetch the verbatim
review at comment_url.
