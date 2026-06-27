# Design: resumable gardeners — salvaging in-flight work when an agent stalls or dies

| Created | 2026-06-27 |
| Author  | gardener (researcher → designer) |
| Status  | Proposed |

> **Design only. DRAFT for maintainer review.** Per `CLAUDE.md` § Conventions the
> garden opens no PRs against itself; this is the deliberate exception (a
> reviewable design PR, base `main2`). Nothing in the live fleet is changed by
> this document.

## The problem

On **2026-06-25** a model quota/availability blip left **12 gardener agents
hung**. Their in-progress work was lost, the jobs were requeued, and the work was
**re-done from scratch** — re-spending tokens on reasoning and edits that had
already partly happened. The maintainer asked whether gardeners can be made
**resumable**: a stalled/killed/crashed agent's work picked up where it left off
rather than restarted.

The maintainer also flagged, correctly, that **this may be more complexity than
it is worth** and asked for an honest weighing — including a recommendation
_against_ if the cost exceeds the benefit.

**Bottom line up front:** most of the problem is **already solved**, and two of
the three remaining levers are cheap. A general checkpointing protocol is **not
worth building**. The recommendation is: keep what shipped, invest a small amount
in **idempotent job design**, and decline to build heavy checkpoint machinery.

## What already exists (the baseline this design must not re-invent)

Resumability is not a greenfield question. Between the 2026-06-25 incident and the
writing of this design, three layers already landed:

### 1. The job is never lost — the reaper (`scripts/jobs/reaper.sh`)

A gardener that dies mid-job leaves its claim in `jobs/doin/`. The reaper scans
`doin/` and moves any claim older than `GARDEN_CLAIM_TTL` (default **3600 s**)
back to `jobs/todo/`, stripping the claim stamp, so a fresh gardener re-claims it.
The reaper was hardened directly in response to 2026-06-25 (three jobs had been
stranded 15–19 h because the single per-tick CAS push lost the journal-contention
race _every_ tick): it now **retries the requeue within the tick**, **batches all
reaps into one push**, strips only the trailing claim block, and **poison-caps** a
job after `GARDEN_REAP_POISON_THRESHOLD` (default 5) requeue cycles, surfacing it
to the maintainer instead of looping forever.

So the **work item** is already durable. What 2026-06-25 actually lost was the
**in-flight reasoning and uncommitted edits** of the dead session — not the job.

### 2. The session is best-effort resumed — `scripts/jobs/handlers/gardener-claude.sh`

Landed **2026-06-27 04:40 UTC** (hours before this very job was promoted), this is
a first cut of **approach #1 below, already in production**. The handler derives a
**deterministic** Claude session id from the job base:

```
session_id = uuid5(NAMESPACE_URL, "garden-job:" + base)
```

- A **fresh** claim runs `claude -p --session-id <sid> …`, pinning the session.
- A **requeued** job derives the _same_ id (the base is unchanged). If that
  session's transcript is present on this host
  (`~/.claude/projects/<encoded-cwd>/<sid>.jsonl`), the handler runs
  `claude -p --resume <sid> …` with a "you are RESUMING; continue from where you
  left off" prompt, carrying the interrupted session's transcript forward.

Determinism is the elegant part: **no session id is plumbed through the board** —
the base alone reproduces it, so the reaper stays a dumb requeue. All gardener
instances on a host launch from the same cwd (the unit sets no `WorkingDirectory`,
so PWD is the user-manager default), so the encoded-cwd matches across gardener
ids and a _different_ gardener can find the dead one's transcript.

### 3. The work substrate — scratch worktrees and the gardening state machine

Per-job worktrees live under `$GARDEN_SCRATCH/<base>-<rand>/`, GC'd after 24 h, so
a dead session's uncommitted edits survive on disk for a day. PR jobs run through
the **gardening state machine** (`scripts/jobs/gardening/garden-pr.sh`): a
deterministic script that does mechanical steps itself and shells to `claude -p`
only for decisions. It is **already restartable by construction** — re-running it
re-senses the worktree and re-derives where it is, rather than trusting in-process
state.

**Net:** the durable-job + deterministic-session-id + restartable-state-machine
stack already addresses the _job-loss_ half of 2026-06-25. The open question is how
much further to go on the _work-salvage_ half.

## The four approaches, weighed

### Approach 1 — Claude session resumption — **already shipped; keep it**

**Mechanism.** Deterministic session id + `--resume` (see baseline §2). The Claude
Code CLI (v2.1.193 on this host) supports `--session-id <uuid>`, `-r/--resume
[value]`, `-c/--continue`, and `--fork-session`; `--resume` with `--print` is the
headless path the handler uses.

**What it salvages on a stall.** Claude's **reasoning/context transcript** of the
interrupted attempt — what it had figured out, what it had decided, what it
believed it had done. This is the expensive-to-recompute part and the most
valuable thing to carry forward.

**Cost.** Effectively nil — ~15 lines already in the handler, no board changes, no
new service.

**Failure modes.**

- **Same-host only.** The transcript lives on the host that wrote it. A cross-host
  requeue falls back to a fresh session (pinned to the same id, so the _next_
  death on that host is resumable). Acceptable; the fleet is small-host today.
- **Transcript pruning.** If Claude Code GCs the `.jsonl`, resume silently
  degrades to fresh. Acceptable (correctness preserved, only the salvage is lost).
- **Loose coupling to the actual filesystem work.** The transcript is the
  session's _memory_, not its edits. Uncommitted edits sit in a scratch worktree
  with a _random_ suffix; a resumed session must rely on Claude _remembering_ that
  path (still on disk until the 24 h GC) and `cd`-ing back. This is the weakest
  link and is **not** tightened by session resumption itself.
- **Re-doing a partial side effect — the central risk.** A resumed session knows
  what it _intended_ but not reliably what it _completed_. It may re-post a
  comment, re-push a branch, or re-open a PR. **Session resumption does not solve
  this** — idempotent design (approach 3) does.

**Verdict.** Cheap, done, genuinely useful — but its value is **capped** by the
side-effect-idempotency problem and the loose worktree coupling. **Keep it; do not
expand it.** The two small hardening ideas worth a follow-up (not this design):
record the scratch worktree path in the work record so a resume is told exactly
where its edits are, rather than trusting recall.

### Approach 2 — Job-state checkpointing — **recommend AGAINST (as a general protocol)**

**Mechanism.** The agent periodically persists progress: intermediate commits to
the work branch plus a checkpoint record in the journal ("stage N of M done, head
SHA, what remains"). A resuming agent reads the checkpoint and continues from the
last completed step.

**What it salvages.** A **structured**, host-independent, LLM-independent resume
point — strictly more robust than a transcript.

**Cost.** This is where the honesty matters:

- For **free-form `claude -p` jobs** (the common case — like _this_ job), the cost
  is **high**. There is no deterministic step structure to checkpoint against; you
  would have to get the **LLM itself** to reliably emit and then honor checkpoints.
  That re-introduces exactly the non-determinism the gardening state machine was
  built to keep _out_ of the LLM. You would be trusting the stalled component to
  have correctly described its own progress before it stalled.
- For **state-machine-driven jobs** (`garden-pr.sh`), the cost is **low** — the
  stages are already deterministic and explicit, and intermediate commits already
  happen. But the benefit is _also_ low, because the state machine is **already
  restartable**: re-running it re-senses and re-derives state. An explicit
  "last completed stage index" marker would only save the cost of re-running the
  cheap deterministic prefix (rebase-check, sense gates) — which is small and
  side-effect-free by design.

**Failure modes.** **Stale checkpoint** (records "tests passed" but the base has
since moved — a resume that trusts it skips a now-needed check, the
false-negative the state machine explicitly forbids); checkpoint/reality
divergence; added journal-push contention from periodic writes.

**Verdict.** **Do not build a general checkpoint protocol.** The reaper already
preserves the job; approaches 1 + 3 cover salvage and safety. For free-form jobs
the cost exceeds the benefit and imports non-determinism; for state-machine jobs
the state machine already _is_ the checkpoint. If future profiling ever shows that
re-running deterministic prefixes is genuinely expensive (it is not today), a
**trivial** "last completed stage" marker can be folded into `garden-pr.sh` as a
local optimization — but that is a micro-optimization, not the resumability
strategy, and should respect the false-negative asymmetry (a checkpoint may let
you _skip_ a step only if skipping can never hide a regression).

### Approach 3 — Idempotent / restartable job design — **adopt as the primary lever**

**Mechanism.** Structure jobs so a **fresh** run cheaply detects work already done
and skips it: the branch already has the commits, the test already passes, the PR
is already open, the comment is already posted, the reactji is already there.
"Check before act."

**What it salvages.** It makes "requeue + re-run" **nearly free without any true
resumption** — and, crucially, it is **the thing that makes approach 1 safe**: an
idempotent step is harmless to re-run, which neutralizes approach 1's central
"re-doing a partial side effect" risk. The two compose: resume carries the
_thinking_, idempotency makes re-execution of any _action_ a no-op.

**Cost.** Low-to-moderate, and mostly **discipline rather than machinery**:

- A short norm in `roles/gardener/AGENT.md` and `roles/COMMON.md`: before any
  outward or hard-to-reverse action (open PR, push, post comment/reactji), **check
  whether it is already done** and skip if so.
- A few reusable guard helpers in `scripts/jobs/common.sh` for the common side
  effects (`pr_exists_for_branch`, `comment_already_posted <marker>`), so the
  check is one call, not bespoke each time. The garden already leans this way —
  the bulletin loop's change-gated push, the reaper's verify-after-push, the
  comment-watcher's dedup markers, and `sense.sh`'s gating are all this same
  check-before-act philosophy applied elsewhere.

**Failure modes.** An idempotency check that is _wrong_ — but the asymmetry favors
safety: a false "not done yet" merely re-does a cheap step; only a false "already
done" can skip needed work, so guards must be written to **err toward re-running**
(the same false-positive-OK / false-negative-bad rule the eval gate already
follows).

**Verdict.** **The highest-value, lowest-risk approach, and the recommended
primary direction.** It is cheap, it has no new service or state, it subsumes
approach 1's main risk, and it makes the existing reaper-requeue path (which we are
keeping regardless) genuinely cheap to re-run.

### Approach 4 — Relationship to the fleet model (`systemd-run` transient worker vs. resident loop)

The in-flight fleet-model question is whether a gardener is a **resident loop**
(today: `gardener.sh` claims job after job) or a **transient-per-job worker** (a
`systemd-run` / `GARDEN_ONESHOT` timer-rearmed short-lived process per job, which
the code already half-supports via `GARDEN_ONESHOT`).

Resumability **interacts cleanly with either**, and the current design is already
on the right side of the interaction: **nothing about resume lives in the gardener
process.** The session id is derived from the base, the job lives on the board, the
transcript lives on disk, the worktree lives in scratch. So a transient model — in
which every job is, by construction, a fresh process and every "stall" is just a
process that did not come back — needs **no extra resumability work**; it simply
makes the reaper-requeue path the _normal_ path rather than the exceptional one.

The one implication worth recording: **a transient fleet makes approach 3
(idempotency) more important, not less**, because re-execution from a cold process
is routine there. This is another reason to invest in idempotency over
checkpointing: idempotency pays off under _both_ fleet models, while a
process-resident checkpoint cache would be wasted by a transient model.

## Recommendation

| Approach | Recommendation | Why |
| --- | --- | --- |
| 1 — session resumption | **Keep (already shipped)** | Free, carries the reasoning forward, but value capped by side-effect risk; do not expand. |
| 2 — general checkpointing | **Do not build** | Cost exceeds benefit; imports LLM non-determinism for free-form jobs; the state machine already _is_ the checkpoint for structured jobs. |
| 3 — idempotent job design | **Adopt as the primary lever** | Cheapest, lowest-risk, makes re-run free and makes approach 1 safe; mostly discipline + a couple of guards. |
| 4 — fleet-model interaction | **No new work; note the dependency** | Resume state is already process-external; idempotency (approach 3) is what pays off under a transient fleet. |

**The honest bottom line the maintainer asked for:** full gardener resumability is
**not worth building as new machinery** — and largely does not need to be, because
the durable board + reaper + deterministic-session resume already returned most of
the value, cheaply, and the 2026-06-25 failure (jobs stranded by a lost requeue
race) was already fixed in the reaper itself. The remaining gap — re-running a job
safely and cheaply — is best closed by **idempotent job design**, a discipline-led
change measured in a norm paragraph and a few guard helpers, not a checkpoint
subsystem. A checkpointing protocol would add a service, journal contention, and a
new class of stale-state bug to buy a marginal improvement over what resume +
idempotency already deliver.

### Suggested next steps (if accepted)

1. Land the idempotency norm in `roles/gardener/AGENT.md` + `roles/COMMON.md`
   ("check-before-act" for every outward/hard-to-reverse side effect, err toward
   re-running).
2. Add `pr_exists_for_branch` / `comment_already_posted <marker>` guard helpers to
   `scripts/jobs/common.sh` and adopt them in the gardening state machine's
   PR-open and summary-comment steps.
3. (Optional, low priority) Record the scratch worktree path in the work record so
   an approach-1 resume is told where its edits are instead of trusting recall.
4. Explicitly **decline** the general checkpoint protocol; revisit only if
   profiling shows deterministic-prefix re-execution is a real cost.

## Open questions for the maintainer

- Is the **same-host** limitation of session resume acceptable long-term, or is a
  cross-host transcript shuttle ever worth it? (This design assumes _no_ — the
  fallback-to-fresh is fine.)
- Should the idempotency norm be **enforced** (a juror seat or pre-push gate that
  checks for check-before-act on side-effecting steps) or left as **discipline**?
- Does the maintainer want the optional approach-1 hardening (worktree-path in the
  work record) folded in now, or kept as a separate follow-up?
