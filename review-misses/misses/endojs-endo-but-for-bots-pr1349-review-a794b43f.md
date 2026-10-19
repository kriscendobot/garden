---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1349-review-a794b43f
verdict: miss
category: process
pr: 1349
cluster: post-gauntlet-fixer-change-unreviewed
cluster_pattern: A substantive fixer change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head.
review_at: 2026-10-08T04:35:48Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1349#pullrequestreview-5451375971
identity: endojs/endo-but-for-bots#1349:review:5451375971:retro
producing_role: mentat (manual job)
producing_job: endojs-endo-but-for-bots-pr1349-textcodec-encapsulation-mentat
missed_by: gauntlet chain (no panel over heads 7ece21a220/500550badc); would-be seats changeset-auditor/archivist (claim accuracy) and decomplector (minimum mechanism)
severity: minor
grounds: |
  Paraphrase: CHANGES_REQUESTED review ("minor findings only") with three
  inline threads. (1) The changeset gave an approximate affected-Chrome
  cutoff; the maintainer asked for the precise range the empirical testing
  had established. (2) A WeakSet guard making the codec taming idempotent
  was called overkill: SES avoids double application higher up the stack
  (single repairIntrinsics/lockdown), and the guard would not address eval
  twins anyway. (3) The XS missing-codecs test might belong in hardened262.
  Verdict: a process miss on the post-panel-head freshness pattern. The last
  completed panel (gauntlet-20260930 round 3, pass) reviewed 4d3354123e on
  2026-10-05. The PR's actual title change, the encapsulation fix
  (tame-text-codecs.js, changeset, browser tests; commits 7ece21a220 and
  500550badc, 2026-10-07), came from a manual mentat job and reached the
  maintainer with NO panel. The mentat's completion stamped "Panel-head
  freshness: review required ... No gauntlet was staged; the maintainer
  received a deduplicated stale-review action". So the freshness sensor from
  the cluster's improvement (05e02d8f4d1, 2026-09-27) detected the stale head
  but routed it to the maintainer docket instead of staging a panel; the
  2026-09-29 restored automatic handoff stages builder/design completions,
  not a manual job's push onto an existing reviewed PR. Findings (1) and (2)
  are in panel range: the same mentat report records the measured matrix
  (Chromium 120-137 affected, 138+ clean) while its changeset still said
  "before roughly Chrome 127" (a claim contradicting the job's own evidence,
  archivist/changeset-auditor), and (2) is the decomplector's
  minimum-viable-mechanism question. (3) alone is new direction.
  Checked in the world: the primary pushed 2da28e7b94 (measured
  Chromium-before-138 range) and 32be2c61d3 (WeakSet removed); both on the
  PR head. A later gauntlet-20261007 halted at viability (upstream #3372
  overtook the approach), so the new head was never panelled either.
