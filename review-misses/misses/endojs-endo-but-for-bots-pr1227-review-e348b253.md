---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1227-review-e348b253
verdict: miss
category: process
pr: 1227
cluster: post-gauntlet-fixer-change-unreviewed
cluster_pattern: A substantive fixer change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head, leaving newly introduced state invariants for the maintainer to reconstruct.
review_at: 2026-09-27T07:26:50Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1227#pullrequestreview-5329319726
identity: endojs/endo-but-for-bots#1227:review:5329319726:retro
producing_role: fixer
producing_job: endojs-endo-but-for-bots-pr1227-review-5194e7b0
missed_by: post-revision review process; the design-panel critic, decomplector, novice, and copyeditor lenses never ran on the implementation-aligned head
severity: moderate
grounds: |
  The six durable design-panel rounds ended on 2026-09-09. Their last review
  covered commit 6d5e94915, before the design was replaced with an
  implementation-aligned account of the wake-on-message pin mechanism. The
  rewritten head reviewed by the maintainer was 5cc4af213. The PR review history
  contains no panel between those heads, so the maintainer was the first reviewer
  of the new design rather than the consumer of a current panel verdict.

  Both inline notes were reviewable from that head and the repository. The
  status summary described two pin directories generically even though the same
  document's formula section already named `guestPins` and `hostPins`, explained
  their different visibility, and the implementation exposed both through
  formula introspection. A consistency and novice-readability pass should have
  made the summary use the document's own precise names. Separately, the design
  presented a shared agent-directory options surface containing pins and
  networks but omitted the already-landed sibling `planes` directory and
  `@planes` namespace. A decomplector pass tracing the complete sibling surface
  should at least have surfaced whether `planes` belonged in the proposal. The
  eventual correction names both pin directories throughout and adds `planes`
  while accurately recording that the option itself remains deferred.

  The review body's request to conduct and build is lifecycle direction, not a
  review defect, and the maintainer's preference to expose `planes` as a future
  option contains design direction. Those elements do not erase the process
  miss: a substantive rewrite advanced from the last panel-reviewed head to
  maintainer review without any fresh design panel. This is the same mechanism
  as the cluster's prior fixer, shepherd, and designer members, not evaluator
  gaming. The current exact-head freshness rule and sensor were committed only
  after this review, so this member predates the improvement and should be
  treated as backlog-drain evidence rather than a post-fix recurrence.
---

The maintainer's inline feedback is paraphrased as asking the implemented-status
summary to distinguish the guest-visible pin namespace from the host-only pin
directory, and asking the proposed agent directory-option surface to account for
the sibling planes directory. See `comment_url` for the untrusted original text.

The miss is that the implementation-alignment rewrite was never reviewed on its
actual head before maintainer presentation; the conduct/build directive itself
is new lifecycle direction.
