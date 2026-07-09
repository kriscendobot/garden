---
order: serial
children: endojs-endo-but-for-bots-pr123-rebase endojs-endo-but-for-bots-pr123-retcon endojs-endo-but-for-bots-pr123-conduct
on-child-failure: halt
state: pending
created_by: gardener
created_at: 2026-07-09T18:35:56Z
---

Serial finalization of endojs/endo-but-for-bots PR #123 in response to the
maintainer's APPROVED review (kriskowal, review 4659604460): "Please rebase,
retcon, and conduct." Three ordered steps on the same PR branch
(`fix/lal-transcript`), strictly serial because each mutates that one branch:

1. rebase  — weaver: rebase head onto a fresh `llm-<sha>` frozen base.
2. retcon  — fixer: regroup the net diff into per-package + lockfile commits.
3. conduct — conductor: un-draft (n/a), unfreeze base to live `llm`, merge.

Decomposed from review job endojs-endo-but-for-bots-pr123-review-7a525e60. No
inline comments were tied to the review; the review body was the whole ask.
Halt-on-failure so a failed rebase/retcon does not merge a broken branch.
