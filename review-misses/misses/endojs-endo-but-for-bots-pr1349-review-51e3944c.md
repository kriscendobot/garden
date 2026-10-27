---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1349-review-51e3944c
verdict: miss
category: docs-drift
pr: 1349
cluster: host-claim-exceeds-measured-evidence
cluster_pattern: A release note or comment states an external-host behavior range broader than the measurements the producing work recorded (an open-ended "all before N" from a sampled matrix), and review does not compare the claim against the recorded evidence, because the claim-accuracy lens covers only in-repo-verifiable claims.
review_at: 2026-10-27T18:33:00Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1349#pullrequestreview-5672187123
identity: endojs/endo-but-for-bots#1349:review:5672187123:retro
producing_role: fixer (review-feedback primary)
producing_job: endojs-endo-but-for-bots-pr1349-review-a794b43f
missed_by: archivist (claim accuracy; COMMON.md § Definite technical claims scoped to in-repo claims only), changeset-auditor; panel runs that passed heads 4f8e35f7, b3fecfbf, 4c315e84 with the claim present
severity: minor
grounds: |
  Paraphrase: COMMENTED review whose body asks for an upstream ferry, with
  three inline threads. (1) On the changeset: the maintainer believes the
  measured affected version range was narrower than "every Chromium before
  138" and asks for a check. (2) On browser-test.yml: schedule a weekly check
  and propose a revert when the workaround is no longer needed. (3) On
  depcheck.yml: spin out an investigation of an alternative so dependencies
  can return to latest (obtain the tool elsewhere or write our own).
  Verdict: (1) is a miss; (2), (3), and the ferry request are new direction.
  Grounds for (1), checked in the world: the 2026-10-07 mentat report
  (jobs/tada/2026/10/07/...-textcodec-encapsulation-mentat.md) recorded the
  measured matrix as Chromium 120-137 affected and 138+ clean, and said the
  matrix was in the PR Verification section. On 2026-10-08 the maintainer
  asked for a more precise range "from the empirical testing"; the primary of
  the prior retro (a794b43f, commit 2da28e7b94) answered with "Chromium before
  version 138", an open lower bound the evidence did not support, and replied
  that this was the precise measured boundary. That claim then sat in the
  changeset, the PR body, and test comments through panel runs that passed
  heads 4f8e35f7, b3fecfbf, and 4c315e84 (and was present at the reviewed head
  b43f86c0d3) without any seat comparing it with the recorded matrix. So the
  maintainer had to raise the same precision point a second time. The
  standing archivist claim-accuracy rule (COMMON.md § Definite technical claims) is
  scoped to in-repo-verifiable claims about in-repo entities, so it did not
  clearly bind an external host-version claim. That is why this mints a new
  cluster instead of joining docs-claim-contradicts-code-semantics. Related:
  evidence-backed-host-workaround (correctness-bug, #259). The primary fixed
  it at 91cca8a551, which states the measured versions (120, 126, 127, 133,
  136, 137 affected; 138-140 clean). That commit is on the PR head
  (confirmed). The PR body still says "Chromium before version 138" in two
  places, which the primary did not change.
---

Retro on #1349 review 5672187123. One of three inline asks (the
changeset version range) is a review miss: the claim went past recorded
evidence and repeated a precision point the maintainer had already raised.
The weekly-check and depcheck-alternative asks are new direction.
