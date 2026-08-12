---
role: builder
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Land on main2 (no PR — CLAUDE.md
§ Conventions).

# Fix two orchestrate-watcher defects: progress-blind stall detection, and concurrent promotion in SERIAL runs

**Maintainer directive (kriskowal, 2026-08-12).** Both defects are in
`scripts/jobs/orchestrate.sh`. Fix them in ONE job — they touch the same file, and
splitting them would create exactly the concurrent-writer race defect B is about.

## DEFECT A — any requeue is read as failure, ignoring the progress signal that already exists

In `child_state()`:

    if { [ -n "$prev" ] && [ "$n" -gt "$prev" ] 2>/dev/null; } \
      || [ "$n" -gt "$GARDEN_ORCH_STALL_REQUEUE_LIMIT" ] 2>/dev/null; then
      printf 'failed\n'; return 0
    fi

**Any rise above the promotion baseline means `failed`.** The tunable
`GARDEN_ORCH_STALL_REQUEUE_LIMIT` exists but the baseline-rise clause fires first, so
the limit never applies. A long-running child that is reaped and re-claims — the
NORMAL path for a shepherd waiting on CI, or a 35-seat panel — is declared stalled on
its first requeue.

**THE FIX THE MAINTAINER ASKED FOR: honor the productive-cycle hint the reaper already
honors.** The fleet already distinguishes "requeued but progressing" from "requeued
and failing", and the orchestrate watcher is simply not consulting it:

- `gardener.sh:512` snapshots `job_worktree_heads` before the handler runs.
- `gardener.sh:603-604` stamps the hint when a per-job worktree HEAD advanced:
  *"reaper will RESET its doom counter, not increment"*.
- `reaper.sh:764` consumes it via `has_productive_cycle_hint`.

So the semantics are already defined and shipped — **the orchestrate watcher must use
the same predicate.** A requeued child that advanced a worktree HEAD is making
progress: do NOT mark it failed, and advance the stored `child-<c>-reap-count`
baseline so the next tick compares against the new floor. A requeued child with NO
progress hint counts toward `GARDEN_ORCH_STALL_REQUEUE_LIMIT` and fails only when it
exceeds that limit — which is what the tunable was for.

This is the maintainer's "edge trigger for jobs that exceeded their deadline but
finished anyway to preserve progress", implemented by reusing the existing
mechanism rather than inventing a second one. Do not invent a parallel signal.

Apply the same reasoning to `child_failure_detail()`, which duplicates the two
requeue checks and must not disagree with `child_state()`.

**Evidence — 5 halts, all on live children:**

    08-06  ebfb-pr600-health-merge-orch        3/5   shepherd alive, driving CI
    08-06  pr910-panel-response                9/10  verify-repanel alive
    08-08  ironhorse-test262-…-completion      5/29  js-05 alive; it had DELIBERATELY
                                                     yielded to avoid racing js-04
    08-12  ironhorse-test262-…-completion-resume 6/29 js-06 alive
    08-09  minion-town-weblet-publish-completion 3/6  swept a deploy-verify

The 08-08 case is the sharpest: js-05 detected that its predecessor was still running,
refused to race, and exited without a completion signal — **exactly right** — and the
watcher punished that by tearing down 23 remaining children. As it stands the watcher
rewards racing and punishes yielding.

## DEFECT B — SERIAL orchestrations promote children concurrently

A `order: serial` run must have at most ONE child in flight. Observed 2026-08-08 on
`ironhorse-test262-implementation-completion`: **five children live at once**
(`js-01`…`js-05` all in `jobs/doin/`), all editing overlapping Rust sources and
pushing to ONE shared PR branch (`feat/ironhorse-262-language-completion`, ~39
commits in a day). Also observed 08-06 on `ebfb-pr600-…`, where final-weave was
promoted while the rebase child was still in `doin`.

Find why the serial gate lets this happen and close it. Candidate causes to check,
not conclusions: the gate may test only `tada` presence rather than "no sibling in
`todo`/`doin`"; two hosts' watcher ticks may race (this is a leader-only timer — verify
that holds); or a child that is requeued back to `todo` may not count as in-flight.

**Consequences this caused, so the fix can be validated against them:** #970's branch
churn, the js-02 collision where 88 cases moved skipped→failing "post-rebase", and the
conflict that now blocks the whole Ironhorse arc.

## Scope discipline

- Do NOT change the reaper's or gardener's half of the productive-cycle mechanism —
  they work. Only teach the orchestrate watcher to consult it.
- Keep the watcher deterministic and LLM-free.
- Keep it leader-only-gated.
- Do NOT re-post or promote any halted orchestration as part of this job; recovering
  them is separate work.

## Verify

Hermetic tests for: (1) a requeued child WITH a productive-cycle hint stays `active`
and advances the baseline; (2) a requeued child WITHOUT the hint stays active until
`GARDEN_ORCH_STALL_REQUEUE_LIMIT` and then fails; (3) a serial orchestration never
promotes child N+1 while child N is in `todo` or `doin`. Run the existing
`orchestrate-test.sh` and keep it green. `bash -n` on every edited script.

## Report

The landed main2 revision, the root cause you found for defect B (not just the fix),
and confirmation that the productive-cycle predicate is now shared rather than
duplicated between reaper and orchestrator.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T04:55:23Z
