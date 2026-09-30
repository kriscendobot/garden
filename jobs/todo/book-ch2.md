---
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T03:46:16Z cleared=none -->

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book, chapter 2: Architecture and operation

One chapter of a multi-part "book" (orchestration `garden-book-orch`). Write
to `journal/projects/garden-book/ch2-architecture-operation.md` as Markdown
(the assembly job converts to HTML).

## Ground this in real sources

- `CLAUDE.md` § Layout, § How work reaches workers, § Job system (the whole
  section, including Starting the garden, Leader and follower hosts, the
  sysop, Capacity and the foreman brake, Deliberate deploy).
- `skills/job-board/SKILL.md` in full — the todo/doin/tada lifecycle, the
  plan category and its gates, claim/complete mechanics, the basename
  idempotency rules, handler budgets.
- `skills/message-bus/SKILL.md` — the inbox/broadcast/role-channel shape.
- `WORKTREES.md` — the worktree shapes (bare clones, per-job worktrees, the
  journal worktree).
- `designs/job-board.md` and `designs/gardening-state-machine.md` for the
  architectural rationale behind the mechanics above.

## What this chapter should cover

1. **The journal as job board and message bus.** How `journal2` (the orphan
   branch, checked out at `journal/`) serves double duty, and why a `git
   push` to it is the concurrency-control primitive (compare-and-swap) that
   lets many gardeners race safely with no lock service.
2. **The job lifecycle**, exactly: `todo/` → claim (the accepted push IS the
   claim) → `doin/` → `tada/` on completion, plus the `plan/` category
   (parked, not claimable) and its five gates (`go-ahead`, `deferred`,
   `awaiting-maintainer`, `blocked`, `orchestrated`) and who promotes each.
3. **The gardener fleet**: what a gardener is (the shared worker posture),
   how a job's `role:` field picks which posture it wears, per-job worktrees
   and why the deployed garden root is never used for job work.
4. **The message bus**: per-doer inboxes vs. the maintainer inbox vs.
   role/broadcast channels — what each is for and who reads it.
5. **Fleet topology**: leader vs. follower hosts, which services are
   leader-only singletons and why (double-pumping, double-dispatch hazards),
   and the sysop as the deliberate every-host exception.
6. **The deliberate deploy model**: why the root checkout is a *deployed
   version*, not a development tree, and how the rolling-deploy/canary
   mechanism advances it.

Write precisely — this chapter is read by someone who needs to actually
understand the mechanics, not get a vibe for them. Name real script paths and
real file locations.
