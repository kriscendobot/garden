# Fix the reaper: it never wins the requeue race, so stranded claims sit forever

Wear the **mentor** role. Observed 2026-06-25: three jobs (`finish-ebfb-pr96`,
`scholar-ingest-cask`, `scholar-ingest-cask-13`) sat **stranded in `jobs/doin/` for
15–19 hours** with no live worker (dead claims from a pause + a handler failure). The
reaper IS active and the claims are far past TTL, but every tick it logged
**"requeue of '<base>' lost a race; will retry next reaper tick"** and the requeue
**never landed** — so the jobs were never recovered. They had to be force-requeued by
hand. Infrastructure on `main2` (bot identity; isolated worktree off `origin/main2`).

## Root cause

`scripts/jobs/reaper.sh` attempts each requeue **once per tick** (one `commit_and_push`,
no retry loop) and gives up on a lost push race until the next tick. Under steady
journal contention (the bulletin loop, comment-watcher, and other producers push
`journal2` constantly), the reaper loses that single race **every tick**, so a stale
claim is requeued **never**, not "next tick". The watchdog that exists to recover
stranded work cannot actually recover it.

## Fixes

1. **Retry the requeue within a tick** — like `post-job.sh` does (a bounded
   sync→stage→commit→push loop, ~20–50 attempts with backoff), so the reaper actually
   lands the requeue instead of conceding the first race. Reuse the hardened
   `commit_and_push` (verify-after-push) so a "succeeded but didn't land" push also
   retries.
2. **Batch the tick's reaps into one commit** where practical (move all stale
   doin→todo in a single commit+push), so N stale claims cost one race, not N.
3. **Strip the claim block robustly.** The current `sed '/^---$/,$d'` deletes from the
   FIRST `---` line — which truncates the job body if the body itself contains a `---`
   (markdown rule / frontmatter). Strip only the **trailing** claim block (everything
   from the LAST `^---$` line, or the `---` immediately preceding `claim:`).
4. **Surface persistent strands.** If a claim has been reaped/requeued repeatedly and
   keeps coming back (a job whose handler fails every time, e.g. the
   `scholar-ingest-cask-13` that failed at 00:34), don't requeue it forever silently —
   after K requeue cycles, surface it to the maintainer inbox as a poison job rather
   than looping.

## Tests & verification

- Simulate contention (a competing pusher) and assert the reaper's requeue **lands
  within a tick** rather than perpetually losing. Assert the claim-strip preserves a
  body containing an internal `---`. `shellcheck`/`bash -n` clean.

## Definition of done

The reaper retries requeues within a tick and reliably lands them under contention,
batches reaps, strips only the trailing claim block, and surfaces poison jobs after K
cycles — committed and pushed to `origin/main2`. Report the SHA and the retry/poison
parameters. If blocked, report the diagnosis and ready-to-apply change rather than
claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 47
  claimed_at: 2026-06-25T15:20:46Z
