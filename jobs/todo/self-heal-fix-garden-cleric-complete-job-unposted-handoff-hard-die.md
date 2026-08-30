---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/complete-job.sh

A declared-but-unposted handoff successor kills the whole worker process instead of leaving the job in `doin` for the reaper. Failure signature, from `garden-cleric` work item 1:

```
<3>[done/1] FATAL: handoff successor 'ironhorse-fuzz-ab889c8f6184c60d-gauntlet' is not durably posted on the board
<3>[cleric/1] FATAL: complete-job failed for 'ironhorse-fuzz-ab889c8f6184c60d-repair' (rc=1)
```

`complete-job.sh:157` calls `die` when `handoff_successor_posted` is false; `gardener.sh:699` treats every non-`GARDEN_OFFLINE_RC` return as `die`, so the cleric exits 1 and systemd restarts it. Because the reaper requeues the job and the handler deterministically re-declares the same handoff, this is a crash loop: ~2.5 min of builder work, then a dead worker, per cycle. `jobs/doin/ironhorse-fuzz-ab889c8f6184c60d-repair.md` already carries `<!-- garden-reaped: 1 -->`, and eight sibling `ironhorse-fuzz-*-repair` jobs share the handler.

This exact condition is a *soft* block everywhere else: `assert-followup-posted.sh:96` uses the same `handoff_successor_posted` predicate and returns rc 1, which `gardener.sh:666-669` converts into "leaving in doin for retry" without killing the worker; `auto-gauntlet-handoff.sh:9` states the same convention. Make the two agree, in both directions:

1. **Primary — close the gate gap.** `assert-followup-posted.sh` only reaches its handoff check when the report has a substantive `## Follow-ups` section (its lines 67-70 exit 0 otherwise). Verify a declared handoff **unconditionally** whenever `report_handoff_successor` matches, independent of the follow-ups section, so the soft gate catches this before completion is attempted. This is what the script's own lines 44-45 already claim it does. Preserve the existing inconclusive-on-offline-clone behaviour (lines 83-87) so an outage still cannot wedge a completion.

2. **Belt and braces — stop `complete-job.sh` crashing a worker on a semantic verdict.** Replace the `die` at line 157 with an exit on a distinct, named soft rc (a `GARDEN_HANDOFF_UNPOSTED_RC` beside `GARDEN_OFFLINE_RC` in `common.sh`), and handle it in `gardener.sh` alongside the existing `GARDEN_OFFLINE_RC` branch at lines 692-698: log, leave the job in `doin`, back off, `continue`. A missing successor is a job-level fault; it must never be a process-level one. Genuine infrastructure failures from `complete-job.sh` should keep dying as they do now.

Both changes are deterministic and no-LLM. Add coverage for the specific shape that escapes today: a completion report carrying `<<<GARDEN-JOB-HANDED-OFF: X>>>` with **no** `## Follow-ups` section and `X` absent from the board — assert the worker survives and the job stays in `doin`.

Separately, note the nine `ironhorse-fuzz-*-repair` jobs currently in `doin`: their handler declares a `-gauntlet` handoff it apparently never posts. Fixing the disposition stops the crash loop but not the underlying non-post; worth naming in the job so whoever picks it up checks whether the repair handler's gauntlet post is failing silently.
