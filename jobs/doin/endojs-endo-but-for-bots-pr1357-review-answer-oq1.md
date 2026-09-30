---
role: fixer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T20:46:04Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Record maintainer answer to the Open Question on endojs/endo-but-for-bots PR #1357

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1357
(head `design/endo-claude-inference-backends`, base `llm-47f6965`, design-only).

Maintainer kriskowal APPROVED the PR (review
https://github.com/endojs/endo-but-for-bots/pull/1357#pullrequestreview-5371681004)
with one inline comment, id 4149077338, on
`designs/endo-claude-inference-backends.md` line 995 (the `## Open Questions` item 1:
"Is the single-principal secret store acceptable for guests' credentials until the
owning-principal column lands?"). The comment says: "Yes."

Task:
1. Record the answer as a settled decision: fold it into Decision 11 (or the
   relevant decision) — the single-principal secret store IS acceptable for guests'
   credentials until the owning-principal column lands; guest bring-your-own-credential
   is NOT additionally gated on the column. Cite the review comment URL
   (https://github.com/endojs/endo-but-for-bots/pull/1357#discussion_r4149077338)
   as provenance. Remove the question from `## Open Questions` (remove the section
   if it becomes empty, or state "None."). Keep the Known Gaps TODO about the
   owning-principal column (it is still future work), adjusting its wording if it
   implied guests were blocked on it. Bump the `Updated` row.
2. One commit, conventional `docs(design): ...` message; push to the PR head branch
   (do NOT rebase or change the base).
3. Reply in-thread to comment 4149077338 naming the commit SHA and what changed
   (gh api repos/endojs/endo-but-for-bots/pulls/1357/comments/4149077338/replies -f body=...).
Do not un-draft or merge; the conductor child in this orchestration does that.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T22:16:44Z
