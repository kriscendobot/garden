---
ts: 2026-05-29T20:35:22Z
kind: result
role: gardener
host: endolinbot
to: liaison
prs:
  - repo: kriskowal/garden
    pr: 3
    role: opened
refs:
  - https://github.com/kriskowal/garden/pull/3
---

# Result: garden design PR #3 opened (driver design)

## Maintainer directive (this session)

> I would like to improve the reliability of the PR creation workflow
> by pivoting from claude-on-top to claude-under-script. […] Let's
> start with a garden design doc PR.

Plus follow-ups: "Let's use driver for the new role name instead of
confusing the name shepherd. Create the state diagram from the current
workflow. Role specific boards are good. Create a PR that introduces
designs. We can remove the untracked spackle.md."

And: "I have enabled pull requests on the garden."

## Deliverable

**PR**: <https://github.com/kriskowal/garden/pull/3> (DRAFT, base `main`,
head `design/driver`).

## Branch + commit

- Branch `design/driver` off `origin/main` (`f952ef01`, the
  upstream-mirror-retirement commit from earlier today).
- Single commit `d6efe0d3`: `design(driver): script-orchestrated
  PR-creation flow`.
- Files: `designs/README.md` (30 lines, garden-meta-design convention),
  `designs/driver.md` (285 lines, the substantive design). Plus the
  untracked `spackle.md` removed from the garden root.

## Design content shape

- **Motivation** — claude-on-top pain shape with concrete 2026-05-29
  evidence (28-min PR #376 gap; 50-min PR #357 weaver hand-off; 5-cycle
  quiet streak burning per-cycle LLM tokens).
- **Principle** — claude-under-script; LLM invoked only where judgment
  is needed.
- **Architecture** — worker pool of bash daemons; role-specific job
  boards at `journal/jobs/<role>/{open,claimed,done,abandoned}/`; one
  driver per active PR.
- **State machine** — derived from the existing PR-creation-flow chain
  (build → clean → panel → verdict → fixer-loop → appellate → un-draft
  → await-maintainer → conductor → merged) with deterministic transition
  predicates and named LLM-escalation surfaces.
- **Prompt-on-failure capture** — `git hash-object -w --stdin` for the
  log, the resulting SHA in the prompt, `git cat-file blob $SHA` for
  on-demand read. Identical failures hash identically; recurring
  operational flakes can be short-circuited on known-SHA.
- **Prompt continuity** — four-slot brief (PR, design, role, state) in
  every LLM invocation.
- **What changes** — new `roles/driver/AGENT.md`, three new skills,
  modifications to `roles/steward/AGENT.md` (PR-creation-flow scan
  marked for retirement), `roles/general-contractor/AGENT.md`
  (re-scoped or retired), `skills/job-board/SKILL.md` (generalized to
  per-role).
- **5-phase migration plan** — scaffold → design-only on
  endo-but-for-bots → source-touching → retire scan → cross-repo.
- **10 open questions** — worker pool sizing, LLM-availability fallback,
  observability, credentials, tooling boundaries, state-machine
  determinism threshold, monitor relationship, liaison/steward
  retention, driver supervisor shape, capture blob lifecycle.

## PR-open path

The first attempt at `gh pr create` against `kriskowal/garden`
returned `kriscendobot does not have the correct permissions to
execute CreatePullRequest`. Forking via `gh repo fork kriskowal/garden`
created `kriscendobot/garden` (the fork persists; harmless), but the
cross-fork PR-create also returned the same permission error. The
maintainer enabled PR permissions on the garden mid-session ("I have
enabled pull requests on the garden"), and the retry from
`origin/design/driver` (direct, same-repo) succeeded as PR #3.

The `kriscendobot/garden` fork is now a no-op; it can be deleted at
the maintainer's discretion (no current dependency on it).

## Out of scope (not in this PR; queued for separate work if approved)

- Implementation of any driver code (`roles/driver/AGENT.md`, `skills/`
  scripts, `journal/jobs/<role>/...` directories). The design is the
  deliverable; phase-1 scaffolding follows if accepted.
- Migration of existing roles/skills (steward AGENT.md scan
  retirement; general-contractor re-scoping). Each lands as a separate
  PR or commit after the design is accepted.
- The endo-side `spackle.md` draft: removed from the garden root in
  this PR, not preserved in any tree. If the maintainer wants it
  retained as an endo design, a separate designer dispatch on
  `endo-but-for-bots` carries it.

Self-improvement: `designs/README.md` and `designs/driver.md` introduce a
new pattern (PR-against-garden for substantial designs); the convention is
codified in `designs/README.md` so future garden-meta proposals follow
the same shape rather than re-litigating the no-PR rule each time.
