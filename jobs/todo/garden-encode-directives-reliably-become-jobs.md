<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-01T23:57:31Z -->

# Widen the comment-watcher: actionable maintainer directives reliably become JOBS (not just replies)

**Builds on** `garden-encode-acknowledged-comment-needs-reply` (blocked on it — both edit the
comment-watcher verb-gate / comment-claude handler, so they must not run concurrently). That
sibling guarantees a **reply** floor; this job guarantees the **action** floor.

**The gap (2026-06-30 backlog):** a run of maintainer directives slipped — some got a 👀 with no
job at all. The PR enumeration is NOT the cause (the comment-source already paginates over all open
PRs authoritatively). The cause is the **verb-gate**: it recognizes some directives but drops others,
so a clear ask never becomes a job.

**Regression cases to cover (each must deterministically post the right job):**
- **#442** — *"…assume @endo/daemon-cas stands on @endo/platform … refactor accordingly. But first,
  rebase."* — a **multi-part direction** (rebase THEN refactor) that became no job.
- **#58** — *"What's the status of this effort?"* with acceptance criteria — a **question that
  warrants continued work**, which got only a reactji.
- **#277 / #284 / #7** — bare **"Shepherd." / "conduct"** directives: these DID post jobs but their
  reply was missing (the sibling's domain) — keep them posting jobs here.

**Task:** broaden the verb-gate (`scripts/jobs/comment-watcher.sh`) and its triage handler
(`scripts/jobs/handlers/comment-claude.sh`) so every clear actionable maintainer directive —
shepherd, conduct/merge, rebase, retcon, refactor, build/continue, and **multi-part directions** —
reliably posts the corresponding job (deterministic, idempotent by comment-id), in addition to the
reply the sibling guarantees. A directive must not be silently slid to "not-actionable." Add tests
under `scripts/jobs/test/` using the #442 / #58 shapes (a multi-part direction; a status question
with criteria) asserting a job is posted, plus the self-comment / re-poll no-ops.

Land on `main2` via an isolated worktree off origin/main2 (explicit pathspecs; push HEAD:main2).
