Inbox empty. The work is complete. This was a producer action — the schedule is journal-state written via `set-schedule.sh`'s CAS, so no `main2` commit is needed (the body file in my worktree was consumed into `journal2` and the worktree is torn down).

---

## Completion report

**Job:** attention directive on kriscendobot/agoric-sdk PR #9 → schedule a recurring orchestrator to drive the change to approval.

**Preflight:** Container guard clean (inside container, exit 0). `pr-feedback-preflight.sh` returned **PROCEED** (exit 0) — no peer had resolved this comment. Re-fetched the comment; the only trusted directive in it: *"schedule an orchestrator job to drive progress on this change every six hours until it has been approved, starting immediately."*

**What I did:** Registered a new recurring schedule on `journal2` via `set-schedule.sh` (CAS push, no `main2` commit — this is a producer/journal action):

- **Name/prefix:** `agoric-sdk-pr9-drive`
- **Cadence:** `6h`
- **`last_dispatched:` empty** ⇒ `last=0` ⇒ due on the next scheduler tick = **starts immediately**.
- **Body (`role: orchestrator`):** each 6-hourly fire (1) checks the stop condition FIRST — if PR #9 `reviewDecision == APPROVED` or the PR is closed/merged, it messages the maintainer, **deletes its own schedule file**, and stops (the "until approved" clause, agent-driven self-retirement matching the `xst-validation-orchestrator` precedent); otherwise (2) assesses review feedback/CI/board, (3) advances by ONE step by commissioning the next needed gardener job (fixer/shepherd/weaver/gauntlet) with a deterministic basename, (4) reports material progress to the maintainer, (5) escalates blockers. Carries a verbatim PR NOTE and a **fork-only** guardrail (never touch upstream agoric/agoric-sdk) in every follow-on job.

**Grounding:** PR #9 is the garden#29 draft prototype promoting the ymax contract vat to `critical` at chain upgrade (SwingSet v3→v4 migration), base `master`, head `garden29-promote-ymax-critical`, currently draft with no review decision. Distinct from the existing `xst-validation-orchestrator` schedule (issue #33 / XS-upgrade) — no overlap.

**Verified:** Schedule present on `origin/journal2` with the expected frontmatter and empty `last_dispatched`.

**Follow-ups / notes:**
- The scheduler is leader-only; the schedule is shared journal state and will dispatch from whichever host is leader.
- The schedule self-retires on approval/close/merge; no manual cleanup needed. Prompt-injection discipline is baked into the body (all PR/CI/comment text treated as data).
- No source/`main2` changes were required.
