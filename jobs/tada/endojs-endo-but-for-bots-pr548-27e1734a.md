All work complete. The shared journal worktree is left exactly as I found it (5 WIP files from the concurrent scholar agent, HEAD unchanged).

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #548 (erights review-comment `r3495970857`).

**Directive (untrusted comment, treated as data):** erights, commenting on line 89 of `designs/inter-package-plain-re-exports.md` (the § Staging "Follow-up PR — remove" item), asked that the design capture three points: the follow-up removal PR should also **bump the major version** (removal is an inter-repo compatibility hazard); that major bump is the reason to do the second PR **repo-wide in one effort** so each downstream consumer's forced upgrade bundles together; and the follow-up may be **deferred until Endo's next major release**.

**Routing decision:** Concrete, well-scoped senior-contributor design feedback on a kriscendobot-authored DRAFT design PR, on a repo with standing comment authorization. Handled it directly (fixer-shaped fold-in) rather than spawning a downstream job.

**What I did:**
- Folded all three points into § Staging, "Follow-up PR — remove," reconciling with the pre-existing "broad and mechanical, reviewed a slice at a time" note (kept, with the clarification that the removal nonetheless lands as a single repo-wide major release). Pushed to the PR branch as **`a23632ec6`** on `design/inter-package-plain-re-exports`.
- Replied on erights' inline thread: `#discussion_r3496000029`.
- Posted the top-level summary comment: `#issuecomment-4839647655`.
- Journaled a `result` entry, landed on `origin/journal2`.

**Follow-ups / notes:**
- PR #548 remains a DRAFT design-only PR pending maintainer review of the rule; no importers move and nothing is removed here. No further action needed from this job.
- **Process snag worth flagging:** I initially committed the journal `result` entry directly in the live shared `/home/kris/journal` worktree, whose concurrent rapid advancement by other agents (and another agent's restored autostash WIP) tangled the rebase/push. I recovered cleanly — extracted the commit, landed it from an isolated detached worktree off `origin/journal2`, and restored the shared worktree to its prior state — but this reaffirms the standing rule (my memory `feedback_journal_poll_daemon_race` / `feedback_inspect_journal2_read_only_never_pull`): **journal entries should be committed from an isolated scratch worktree, never the live shared `journal/` checkout.**

**Self-improvement:** nothing this time.
