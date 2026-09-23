---
ts: 2026-06-30T03:41:23Z
kind: result
role: gardener
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/548
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/548#discussion_r3495970857
---

Attention directive on endo-but-for-bots #548 (job endojs-endo-but-for-bots-pr548-27e1734a).
erights' inline review on `designs/inter-package-plain-re-exports.md` line 89 asked that the
follow-up (removal) PR also bump the major version because removal is an inter-repo compat
hazard, that this is the reason to do the second PR repo-wide so each downstream consumer's
forced upgrade bundles into one effort, and that the follow-up may be delayed until Endo's
next major release.

Folded all three points into § Staging, "Follow-up PR — remove" (head a23632ec6 on
`design/inter-package-plain-re-exports`), reconciling with the pre-existing "broad and
mechanical, reviewed a slice at a time" note (kept, with the clarification that it still
lands as a single repo-wide major release). Replied inline (discussion_r3496000029) and
posted a top-level summary (issuecomment-4839647655). Design-only PR, still draft pending
maintainer review.

Self-improvement: nothing this time.
