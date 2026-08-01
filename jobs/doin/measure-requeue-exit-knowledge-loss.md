---
role: builder
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-30T16:18:04Z cleared=deadline-overrun=1 -->

---
role: builder
---
# Measure and close the cross-host gap in requeue session-resume

Quantify what a worker exit actually costs the garden, then close the one gap the
measurement is expected to expose.

## The mechanism, as built

`scripts/jobs/handlers/gardener-claude.sh` pins a **deterministic** Claude session
id derived from the job base, so a reaper requeue can `--resume <sid>` and carry
the dead session's transcript forward. The per-job worktree is preserved across the
requeue, so uncommitted edits survive too. This is a real answer to per-exit
knowledge loss and it works — but the handler's own comment states the limit
plainly:

> Resume is best-effort and same-host: a transcript lives under
> `~/.claude/projects/<encoded-cwd>/<sid>.jsonl` on the host that wrote it. If the
> requeue is claimed on another host (or the transcript was pruned) `$resuming` is
> false, `ensure_worktree` recreated a fresh worktree, and we fall back to a fresh
> session.

A **cross-host requeue therefore loses everything** — transcript and worktree
both — and the resumed worker is told it is resuming a session "carried forward
intact" that it does not in fact have. The garden is a leader/follower multibot
fleet in which gardeners run on every host and race-claim, so a cross-host requeue
is not a hypothetical.

## Part 1 — measure (do this first, and report it even if part 2 is deferred)

From the journal alone:

- Requeue rate. Baseline measured 2026-07-28: **26 of 3659** `jobs/tada/` reports
  carry a `garden-reaped:` marker (~0.7%), with a reap-count distribution of
  13×1, 2×2, 2×3, 3×4 (plus 7 with an empty value — find out why the marker is
  written without a count, and fix it if it is a bug).
- **The number that matters:** of those reaped jobs, how many were re-claimed on a
  **different host** than the original claim? Job files carry `claim: host:`, so
  compare the claim host across requeues. That fraction is the true
  total-loss rate.
- Where recoverable, whether the resumed run actually resumed: the handler logs
  `resuming session <sid> for requeued job '<base>'`. Report the resume-success vs
  fresh-fallback split and say how confident the log evidence is.

Report these as a small table. If the cross-host loss rate turns out to be zero or
near-zero in practice, **say so and stop** — part 2 is then not worth building, and
that is a legitimate and valuable outcome.

## Part 2 — close the honesty gap, and optionally the capability gap

Two changes, in order of cost:

1. **Cheap and unconditionally worth doing: stop asserting a false resume.**
   `worker_job_prompt` (`scripts/jobs/handlers/worker-common.sh`) emits the same
   `resume` framing — "carried forward to you intact" — regardless of whether
   `--resume` actually attached. On a fresh-session fallback that statement is
   false, and it actively misleads the worker into trusting a memory it does not
   have and into expecting uncommitted work in a worktree that was recreated.
   Split the framing: a **true resume** keeps today's text; a **fallback** says
   plainly that the prior session's transcript and working tree were lost, that
   only committed work and the journal survive, and that the worker should re-derive
   state rather than assume it.

2. **Conditional on part 1's number: make the requeue host-affine or the
   transcript host-portable.** Options to weigh in the tada, not to pick blindly —
   a claim preference for the original host on a requeue (cheap, weakens the
   race), or draining the transcript to the already-armed `transcripts2` archive
   eagerly enough that another host could fetch it (expensive, and the archive
   sweeps only on a 6h idle timer today). Recommend; do not build the expensive
   option without maintainer sign-off.

## Verification

- Part 1: the table, with the query method stated so it is reproducible.
- Part 2.1: a test asserting the two prompt framings differ on the resuming vs
  fallback path. `scripts/jobs/test/gardener-worktree-test.sh` already distinguishes
  `--resume` from `--session-id` and is the natural place.

## Why now

Posted from issue #62 follow-up (`issue-garden-62-jcorbin-cross-analysis`).
@jcorbin's devoker cross-analysis flagged that the garden's TerraLingua
self-assessment was silent on what a worker's exit costs — its architecture
(persistent lanes, requeueing board) abstracts death away, where devoker's
burst sessions live it. The machinery here turned out to be better than that
critique assumed; the gap is that it has never been measured and that it lies to
the worker when it fails.

<!-- garden-reaped: 4 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T11:43:15Z
