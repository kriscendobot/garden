Done. PR #6 is confirmed DRAFT, base `main2`, OPEN. Inbox empty, worktree torn down, local branch deleted (the branch lives on `origin` for the PR).

---

## Completion report

**Job:** `investigate-resumable-gardeners` — research + design whether gardeners should be made resumable after the 2026-06-25 stall, deliver a DRAFT garden design PR.

**What I did:** Wore researcher then designer. Grounded the analysis in the actual codebase rather than from memory — and the central finding is that **resumability is mostly already solved, some of it the very morning this job was promoted**:
- `reaper.sh` already requeues stale `doin/` claims (TTL 3600 s), hardened after 2026-06-25 to land the requeue within a tick under journal contention, batched, poison-capped — so the **job is never lost**.
- `gardener-claude.sh` landed **2026-06-27 04:40 UTC** (hours before this job): a deterministic Claude session id (`uuid5` of the job base) + `--resume` on a same-host requeue — **approach #1 already in production**. Verified the CLI supports `--session-id`/`--resume`/`--continue`/`--fork-session` (claude v2.1.193).
- `garden-pr.sh` (the gardening state machine) is already restartable by construction.

Wrote `designs/resumable-gardeners.md` weighing all four asked-for approaches (session resume, checkpointing, idempotent jobs, fleet-model interaction) with mechanism / what-it-salvages / cost / failure-modes each, plus a recommendation table, next steps, and open questions. Added the index row to `designs/README.md`. Built in an isolated worktree off `origin/main2` under bot identity (per garden infra-job discipline), then tore it down.

**Recommendation (bottom line):** Full resumability is **not worth building as new machinery**.
- **Keep** session resume (already shipped, free, but value capped by the re-doing-a-partial-side-effect risk).
- **Adopt idempotent job design** as the primary lever — cheap (a norm + a couple of `common.sh` guards), and it's what makes session resume *safe*.
- **Recommend AGAINST** a general checkpoint protocol — cost exceeds benefit, imports LLM non-determinism for free-form jobs, and the state machine already *is* the checkpoint for structured jobs.
- Fleet model: no new work; resume state is already process-external, so it's compatible with a transient `systemd-run` fleet (and idempotency matters more there).

**Deliverable:** **PR #6** (`kriskowal/garden`, DRAFT, base `main2`) — https://github.com/kriskowal/garden/pull/6

**Follow-ups (deferred to the maintainer's review, listed as the design's next steps):** land an idempotency "check-before-act" norm in `roles/gardener/AGENT.md` + `roles/COMMON.md`; add `pr_exists_for_branch`/`comment_already_posted` guards to `common.sh`; optionally record the scratch-worktree path in the work record so an approach-1 resume knows where its edits are.
