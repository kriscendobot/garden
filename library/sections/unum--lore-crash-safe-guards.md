---
title: Crash-safe automated-lifecycle guards — write ordering, source-gated clears, resume guards
source: LORE/ (safety-guard cluster)
source_repo: jcorbin.tngl.sh/unum
source_commit: 1834abac9b27e517d0ffd2bf20625e33e9a05028
source_date: 2026-06-21
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-durability]
status: current
notes: |
  Consolidates the LORE safety-guard cluster: durable_state_ordering_breadcrumb_before_killswitch,
  killswitch_source_guard_on_auto_clear, session_resume_model_guard,
  context_exhaustion_recap_and_keep_claimed. The unifying theme: an automated
  lifecycle path must fail toward the safe state and prove ownership before undoing a
  human's deliberate act.
---

## Abstract

An autonomous agent fleet reboots, self-restarts, resumes sessions, and pauses itself
without a human in the loop, so every automated lifecycle transition is a chance to
**silently undo something a human deliberately did** or to **brick itself across a
crash**. unum's safety-guard lessons share one discipline: *fail toward the safe
state, and prove ownership before reversing a deliberate act.* Four composable
guards — durable-write ordering, source-gated killswitch clears, model-guarded session
resume, and context-exhaustion roll-forward — encode it.

## Write the recovery precondition before the kill-switch

Two durable writes have a dependency: a **kill-switch** disables operation, and a
**breadcrumb** is the precondition a post-reboot self-heal reads to re-enable. Write
order matters under crash. Writing the kill-switch *first* opens a hard-reboot window
where the kill-switch is durable but the breadcrumb is not — and the system comes back
**disabled with nothing on disk to trigger the auto-clear**, bricked until a human
intervenes. The rule:

> **The recovery precondition must be made durable first.** Commit the breadcrumb,
> then the kill-switch. A crash in the new window leaves a breadcrumb with no
> kill-switch (benign) instead of a kill-switch with no breadcrumb (stuck).

A reorder-only fix is **insufficient**: state written by the pre-fix code already
exists on disk in the bad shape, so the fix must also add a **source-gated self-heal**
that recognises and clears pre-fix on-disk state, or already-bricked hosts never
recover. (Greenfield state needs only the reorder.)

## An automated killswitch clear must guard on the source tag

The killswitch is the operator's master pause. An automated lifecycle path that clears
it blindly will **silently un-pause work the operator deliberately paused** — the worst
class of safety regression, because it looks like a normal resume. The pattern: every
killswitch write stamps a **`source` tag** naming who set it (`reboot-watcher`,
`telegram_*`, `manual`). Any *automated* clear reads the live source first and clears
**only when the source matches the tag it itself stamped**; a foreign source falls
through untouched. If the auto-clearer cannot prove it owns the pause, it leaves it. So
a reboot-watcher pause clears on resume, but an operator pause set before the reboot
*survives*. Scope: automated clears only — an operator-initiated `/resume` clears
regardless of source, because the human is the authority the guard exists to protect.
An *inconclusive* post-reboot classification follows the same instinct: clear the stale
breadcrumb but leave the killswitch untouched (fail toward stay-paused).

## Guard session resume on the recorded model

Resuming a session under a *different model* than it was created with silently mixes
incompatible context. Make the model a **first-class part of session identity**: record
`session_model` alongside the session ID at creation, compare on resume, and on
mismatch **auto-clear and start fresh** rather than resuming. Two boundary rules keep
the guard safe:

- A **missing legacy record** (a session predating the field) is treated as a
  **mismatch** — the conservative choice: when in doubt, start fresh.
- The empty string `""` is a **legitimate vendor-default model value**, not a sentinel
  for "unset" — do not conflate `""` with absence; `""` recorded against `""` current is
  a *match*.

The guard is intentionally conservative: the only cost of a false-positive mismatch is a
discarded resume, never mixed context.

## At context exhaustion: recap and keep claimed — do not re-ready

The naive context-exhaust behaviour — commit a WIP checkpoint, set the task back to
*ready*, exit — causes **unbounded re-claim loops**: a fresh worker claims with no memory
of what was tried and redoes the same investigation until it too hits the limit (unum saw
6 re-claim cycles on one task). The WIP commit signals "I got cut off" but carries no
findings, so the next session cannot tell mid-investigation from investigated-and-found-nothing.
The pattern, before exiting near the limit:

1. **Write a `## Session N recap` stanza** into the task file — what was tried, what was
   learned, what failed, and the concrete next step.
2. **Keep `status: claimed`** (increment a reentry counter) — do *not* re-ready — when
   there is a clear next step a fresh session can execute directly.
3. Use a `question`/operator-decision status **only** when the next step genuinely needs
   a human, not as a generic "ran out of context" signal.

Re-ready is correct only when the task genuinely has *no* clear next step for a fresh
session. (The garden's own analogue: a gardener that runs out of turns keeps the job
claimed and does *not* emit its completion signal, so the job is resumed rather than
falsely recorded done — the same "keep claimed, hand off a recap" instinct.)

Source: LORE `durable_state_ordering_breadcrumb_before_killswitch`,
`killswitch_source_guard_on_auto_clear`, `session_resume_model_guard`,
`context_exhaustion_recap_and_keep_claimed` at
[jcorbin.tngl.sh/unum](https://tangled.org/jcorbin.tngl.sh/unum) commit `1834aba`.
