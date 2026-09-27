---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1304-review-96879182
verdict: miss
category: style-convention
pr: 1304
cluster: filler-phrase-concision
cluster_pattern: Garden-authored prose carries empty filler phrases the maintainer asks struck; no seat enforces concision on prose bodies.
review_at: 2026-09-18T04:25:37Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1304#pullrequestreview-5244218260
identity: endojs/endo-but-for-bots#1304:review:5244218260:retro
producing_role: fixer
producing_job: endojs-endo-but-for-bots-pr1304-gauntlet-fix-3
missed_by: fixer authoring discipline; pruner and archivist in code-panel round 4
severity: minor
grounds: >-
  This review bundled two different judgments. The placement question about
  whether the new daemon-specific view helper belonged in a lower-level package
  was new architectural direction and was reasonably answered in-thread; it is
  not counted as a miss. The requested deletion of a five-line implementation
  comment was a miss. The comment narrated why the newly used standard
  own-property predicate avoids prototype walking, immediately above the
  predicate itself. Garden house style already required concise, load-bearing
  code comments through skills/gricean-maxims/SKILL.md, whose scope explicitly
  includes project code comments, and the pruner seat already owned
  over-documented obvious code. The round-3 fixer introduced the comment while
  addressing a panel finding. Although the maintainer review arrived while the
  next panel was still running, code-panel round 4 then reviewed the same
  ca11576479b head and still approved the prose: the archivist called the
  implementation comments accurate and the pruner limited its scan to Markdown
  padding. Thus the active review cycle demonstrably had both the standing rule
  and the exact diff, yet did not catch the needless explanation. The primary
  loop's deliverable exists in the world: commit 0005176282f removed the comment,
  the inline resolution replies exist, and the PR is merged.
---

While fixing a shared help lookup, the gauntlet added a multi-line code comment
that explained mechanics already evident from the standard predicate directly
below it. The maintainer asked for that comment to be removed. The architectural
placement question in the same review was a new-direction discussion and is not
part of this miss. The linked review remains the source for the untrusted
verbatim feedback.
