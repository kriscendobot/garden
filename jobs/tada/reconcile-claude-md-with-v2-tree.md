Pushed to `main2` on the first attempt. The job is complete.

## Completion report

Reconciled `CLAUDE.md` against the actual v2 tree. Every edit was grounded by verifying the referenced files/verbs exist (or don't) before changing; a full link-check confirms every relative link and bare-script reference now resolves.

**The four flagged items:**

1. **"the gamut" → "run the gauntlet."** Confirmed the live verb in `scripts/jobs/comment-watcher.sh`, README, and the rename note in `designs/judicial-workflow.md`. Replaced the vocabulary entry and noted the retired name inline.
2. **Dead vocabulary pointers.** Removed the `roles/liaison/AGENT.md § Vocabulary` and `roles/steward/AGENT.md § Vocabulary` pointers (neither exists; there's no `roles/steward/` at all). Repointed at **README § Key vocabulary** and `comment-watcher.sh`, the live references.
3. **Nonexistent skills in the inventory.** Regenerated the roles and skills rosters directly from `roles/`/`skills/`. Dropped `self-improvement`, `inbox-drain`, `scheduling`, `design-poller`, `velocity-recalibration`, `roadmap-projection`, `groom-open-questions`, `design-queue-drift-check` (skills) and `steward`, `review-queue`, `scout`, `major-general`, `evaluator`, `groom`, `investigator`, `timekeeper` (roles) — none exist. Added the ones that were missing (`foreman`, `judge`, `mentor`, `proxy`, `triager`, `watchman`; `message-bus`, `self-healing-wrapper`, `schedule`, `panel`, `oauth-use-case-patterns`, etc.) and the 34 juror seats.
4. **General v1→v2 pass.** Replaced the v1 "Dispatch contract" (worktree triples via the `Agent` tool + steward) with "How work reaches workers": the liaison posts jobs to the board; gardeners claim and run them in per-job worktrees. Fixed branch names (`journal`→`journal2`, `main`→`main2`), the inbox path (`journal/inboxes/<host>/<role>`→`inbox/<doer>/{unread,read}/`), the `GARDEN` shard-identity resolution, the identity-pin mechanism, the ferry/host-preconditions framing, and the `steward` references in the monitoring-safety constraint. Replaced the drift-prone annotated inventory with plain, regenerable name lists pointing at `roles/`/`skills/` as the source of truth.

**What changed:** one file, `CLAUDE.md`. Committed as `b76c79bfd` and pushed to `origin/main2`.

**Follow-ups:** `WORKTREES.md` still carries the same v1 machinery (per-dispatch worktree triple as the default route, steward as orchestrator) — CLAUDE.md now links to it for "worktree shapes," so a parallel WORKTREES.md reconciliation would be worth a separate job. Not done here to keep this change scoped to CLAUDE.md.
