# Encode: an acknowledged comment gets at least a reply comment, not just a reactji

**Maintainer directive** (kriskowal, 2026-06-30, re endo-but-for-bots PR #58 comment
4848100199 — *"What's the status of this effort?"*, which got only a 👀):
> I would like to see an active job on an acknowledged comment. In general, I would like
> at least a comment on an acknowledged comment, short of a feedback loop.

**The gap:** `scripts/jobs/comment-watcher.sh` reactji-acknowledges (👀) a trusted comment,
then posts a job **only if** the comment trips the actionable-verb gate. A maintainer comment
that doesn't map to a clear verb — a **question / status request** like "What's the status of
this effort?" — currently gets the 👀 and **nothing else**: no job, no reply comment. The
maintainer is left staring at a silent reactji wondering if anything is happening (observed on
PR #58, and the "verb-gate:not-actionable → slide cursor" path on #15).

**Encode this behavior:** every **acknowledged trusted comment** must get **at least a reply
comment**, not just the reactji.
- **Actionable comment** → post the job **AND** a brief reply comment naming what's being done
  (so the maintainer sees the *active job*, e.g. "On it — posted a job to <X>; will report here").
- **Non-actionable-but-acknowledged** (a question, a status request, a comment with no clear
  build/fix verb from a trusted MAINTAINER) → do **not** silently slide the cursor. Engage with
  at least a reply comment (answer the question / state the plan), which may itself spawn a job
  (as the PR #58 status question did). The reactji alone is not a response.

**Guard against the feedback loop** (the "short of a feedback loop" clause):
- Reply **once per comment**, idempotent by comment-id (never double-reply on re-poll).
- **Never reply to the garden's / kriscendobot's own comments** (keep the existing self-comment
  drop) — that's the spiral to avoid. Engage human/trusted comments only.
- One substantive reply; do not auto-reply to the maintainer's reply-to-our-reply.

**Where:** `scripts/jobs/comment-watcher.sh` (the verb-gate / slide path), its triage handler
(`scripts/jobs/handlers/comment-claude.sh`), and the `skills/reactji-acknowledgment/SKILL.md`
doc — so the rule lives in both the code and the always-read procedure. Add a test under
`scripts/jobs/test/` that a trusted non-actionable maintainer comment produces a reply
(not a silent slide) and that self-comments / re-polls don't.

**Land** on `main2` via an isolated worktree off origin/main2 (commit explicit pathspecs, push HEAD:main2).

---
claim:
  host: endolinbot2
  gardener: 92
  claimed_at: 2026-06-30T22:52:13Z
