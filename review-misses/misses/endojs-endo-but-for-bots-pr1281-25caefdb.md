---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1281-25caefdb
verdict: miss
category: style-convention
pr: 1281
cluster: filler-phrase-concision
cluster_pattern: Garden-authored prose carries empty filler phrases the maintainer asks struck; no seat enforces concision on prose bodies.
review_at: 2026-09-17T00:00:14Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1281#discussion_r4031852490
identity: endojs/endo-but-for-bots#1281:comment:4031852490:retro
producing_role: fixer
producing_job: ses-node26-lockdown-permits-gauntlet-fix-5
missed_by: copyeditor and pruner in panel round 6
severity: minor
grounds: >-
  The round-5 fixer introduced an empty emphatic metaphor into a URL test
  comment, and the immediately following round-6 panel left it in place. This
  was already a known garden prose convention rather than a first-stated
  preference: PR #825 had produced a durable miss in this cluster after the
  maintainer asked that the same load-bearing filler be struck and not reused.
  The #1281 panel ran six rounds, including copyediting and pruning lenses, so
  the phrase passed through an active evaluator rather than around one. The
  linked comment asks for the concrete occurrence to be rewritten; its parent
  separately directs the systemic thesaurus mechanism. Live PR inspection
  confirms that the primary delivered commit d14b52fd68 and that the current
  squashed head retains the plain replacement. A separate maintainer-directed
  builder has since landed deterministic Botese detection, a thesaurus seat,
  and a deslopper loop in garden commit e21884be41.
---

The final gauntlet fix added a stock emphatic phrase to a test comment after five
review rounds, and the sixth panel did not flag it even though an earlier review
had already established the garden's convention against that filler. The primary
loop replaced the phrase with a direct description. The linked comment remains
the source for the untrusted verbatim text.
