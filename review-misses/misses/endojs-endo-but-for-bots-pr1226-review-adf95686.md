---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1226-review-adf95686
verdict: miss
category: process
pr: 1226
cluster: post-gauntlet-fixer-change-unreviewed
cluster_pattern: A substantive fixer change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head, leaving newly introduced state invariants for the maintainer to reconstruct.
review_at: 2026-09-22T00:12:49Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1226#pullrequestreview-5273006881
identity: endojs/endo-but-for-bots#1226:review:5273006881:retro
producing_role: designer
producing_job: design-endo-guest-stdio-mcp-revise-20260917
missed_by: post-revision review process; the critic, skeptic, decomplector, copyeditor, and security-design lenses never ran on the redesigned head
severity: moderate
grounds: |
  The six recorded design-panel rounds all ran on 2026-09-08, with the final
  panel reviewing commit 4e1696a4. The later designer revision substantially
  replaced that reviewed architecture: it removed the harness-owned broker and
  per-guest socket, moved the ordinary daemon connection into a server spawned
  by Claude, made formula-id secrecy part of cross-guest isolation, and changed
  the configuration carrier. The revision job's durable report explicitly says
  that it posted no new gauntlet. The next panel-like scrutiny of that new head
  was therefore the maintainer's 2026-09-22 review.

  The maintainer then identified consequences visible in the revised design:
  the confined process could not itself retain arbitrary access to the shared
  daemon socket, all calls needed an explicit one-guest boundary, the config
  carrier still needed a settled design, and revision-history prose obscured
  the present-tense specification. The corrective commit restored an
  out-of-sandbox daemon connection for the confined topology, retained both
  topologies instead of collapsing them, pinned the config carrier, stated the
  one-guest dispatch boundary, and removed the revision narrative. Those are
  reviewable architectural and editorial consequences of the post-panel delta,
  not requirements knowable only from the review. The logging choice and the
  decision to retain both topologies include maintainer direction, but those
  new-direction elements do not erase the unreviewed confinement contradiction.

  This is the third instance of the existing lifecycle gap. As in PRs #475 and
  #858, a substantive producer change landed after the last gauntlet and reached
  maintainer review without a fresh review over the introducing head. Here the
  producer was a designer responding to review, showing that the control must
  cover post-gauntlet revisions generally rather than only fixer or shepherd
  commits. This is not evaluator gaming: the redesign did not manipulate a
  metric or route around a required automatic panel; the manual-trigger regime
  simply left the changed head without a freshness check.
---

The review is paraphrased as requiring the revised design to restore a real
confinement boundary around daemon access, dispatch exclusively through the
selected guest, settle its configuration carrier, keep legitimate topologies
distinct, remove revision-history narration, and expose logging without
over-specifying its source. See `comment_url` for the untrusted original text.

The miss is the absence of a fresh design review after a substantial post-panel
rewrite, not the maintainer's new choices about topology or logging.
