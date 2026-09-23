---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr133-review-d1b65e59
verdict: not-a-miss
category: new-direction
pr: 133
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/133#pullrequestreview-4682130054
identity: endojs/endo-but-for-bots#133:review:4682130054:retro
producing_role: builder
severity: minor
grounds: >
  kriskowal (repo owner/maintainer) left a CHANGES_REQUESTED review on PR #133
  whose entire body is a workflow directive — paraphrased: run the gauntlet,
  rebase, and retcon — with no inline comments and no body text pointing at any
  specific defect. This is orchestrator-vocabulary steering (README § Key
  vocabulary: "run the gauntlet #N", "rebase #N", "retcon #N"), a maintainer
  telling the pipeline what stages to run, NOT an indictment that a panel seat
  missed a bug/style/spec violation. Grounding in the PR's review history
  confirms the discrimination: the primary job (pr133-review-d1b65e59) executed
  the directive by running the full 27-seat code panel, which THEN surfaced the
  must-fix items (stale command-key comments, idx→index, $src→$source /
  $msg→$message spell-out-blocklist hits) and folded the fixes in, retconned
  per-package, and confirmed the merge. The review process WORKED the moment it
  was invoked — no seat "missed" anything, because the gauntlet had not yet run
  its final pass. It had not run because PR #133 was a deliberately-parked draft
  (per its own body: it "predates the preact confinement migration", carried an
  open design question with the maintainer about rich-error-bubble vs pending
  card, and awaited a rebase onto the relocated component "before this leaves
  draft"). Drafts/probes legitimately stay draft; the auto-gauntlet invariant is
  for mergeable-feature builds, not a draft parked pending a maintainer design
  decision. So the maintainer un-parking it with "run the gauntlet" is
  promotion/new-direction, first stated in the comment itself — nothing a panel,
  gate, or standing instruction could have anticipated, and no `process` miss
  (the automation did not fail to fire; the draft was correctly awaiting the
  maintainer's go-ahead). Same PR also produced an earlier new-direction
  dismissal (pr133-review-48633764, UI-placement taste). Recorded as a durable
  dismissal so this directive is never re-litigated; no cluster minted, no
  improvement dispatched.
---

Maintainer left a CHANGES_REQUESTED review on PR #133 whose whole content is a
workflow directive: run the gauntlet, rebase, and retcon. No inline comments, no
defect named. This is pipeline steering (orchestrator vocabulary), not feedback
the review process could have anticipated: the primary job ran the panel on the
directive and the panel itself caught the must-fix items, so nothing was
"missed." The PR was a deliberately-parked draft awaiting a maintainer design
decision and a rebase, so the gauntlet had legitimately not run its final pass —
un-parking it is new-direction/promotion, not a process failure. Dismissed as
new-direction; no cluster, no improvement. See comment_url to re-fetch verbatim.
