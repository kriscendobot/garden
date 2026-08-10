---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (this repo, `main2` branch)
role: designer

This is a garden-infra design, not a fork/PR design: the garden's own repo
takes no PR workflow (per CLAUDE.md § Conventions — both main2 and journal2
push directly to origin). Land the deliverable as `designs/<slug>.md`
committed straight onto `main2` from an isolated per-job worktree
(`roles/COMMON.md` § the one correct shape for a garden-infra job) — no
branch, no PR. Ignore the designer role's default fork/roadmap-branch/PR
mechanics; they don't apply to the garden's own repo.

## Task

Design a deadline-approaching nudge for the garden's job runners.

Every claimed job already runs against a wall-clock deadline (the reaper's
claim-TTL / deadline-overrun machinery in `scripts/jobs/common.sh` —
`GARDEN_CLAIM_TTL`, the `<!-- garden-deadline-overrun: N -->` marker,
`DEADLINE_OVERRUN_MARKER_RE`). Working agents (gardeners wearing any role)
already read their own inbox (`skills/message-bus/SKILL.md`,
`inbox/<doer>/{unread,read}/`). We want a mechanism that, as a claimed job's
attempt approaches its deadline, delivers a message into the working agent's
own inbox nudging it to either wrap up now or pivot to writing up a
follow-up job (the existing `## Follow-ups` convention that
`garden-follow-up` already consumes) rather than being cut off mid-work by
the reaper.

Design questions to resolve (write into `## Open questions` whatever isn't
resolvable from the existing code — do not guess):

- **Who sends the nudge, and when.** A candidate is a small deterministic
  (no-LLM) timer/watcher — in the spirit of the sysop and the foreman brake —
  that computes "this claim's age is within X of its deadline" and writes
  the doer's inbox directly, vs. piggybacking on the reaper's own tick.
  Consider both a fixed lead time and a fraction of the claim TTL.
- **How the message reaches a *running* Claude session mid-job**, not just a
  future poll. Establish whether a gardener's job-execution loop (`gardener.sh`
  / the handler invoking `claude -p`) already checks its own inbox
  mid-attempt, or whether this requires a new hook (e.g. the CLI's own
  Monitor-equivalent, a wrapper that tails the inbox and interrupts/redirects
  the running turn, or delivering it as part of the next prompt turn only).
  If genuinely running-process delivery isn't feasible today, say so plainly
  and scope the design to the best available mechanism instead of assuming
  one.
- **Idempotency and repeat sends.** One nudge per claim attempt, or
  repeated as the deadline keeps approaching? Must not duplicate across the
  reaper's normal retry/requeue cycling.
- **Interaction with the doom/reap-now/deadline-overrun cycle markers** —
  the nudge must not itself perturb `<!-- garden-reaped: N -->` /
  `<!-- garden-deadline-overrun: N -->` counting, and must fail safe (silent,
  not blocking) if the message-bus write fails.
- **Message content/shape** the nudge carries — enough for the agent to act
  (time remaining, a pointer to the follow-up convention) without bloating
  context.
- **Scope**: which roles/jobs get this by default — all gardener jobs, or
  opt-in per role? Note any role whose deadline is already tight enough that
  a nudge adds little value.

## Deliverable

`designs/deadline-nudge.md` (or a better slug if one already exists nearby —
check `designs/` first for related lever/control docs, e.g. the recent
foreman-brake design, before choosing) committed directly to `main2`,
following the garden's own `designs/` conventions. Flag anything genuinely
blocking implementation as an open question rather than picking silently.
