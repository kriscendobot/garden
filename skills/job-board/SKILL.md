# Skill: job-board

The journal-backed job board: how producers post, how concurrent consumers
claim safely, and how jobs complete. Full architecture in
[`designs/job-board.md`](../../designs/job-board.md).

## Purpose

Coordinate many gardeners across many hosts on one shared queue without a lock
service, using the `git push` to `origin/journal2` as a compare-and-swap.

## Inputs / state

The journal branch `journal2` (directory `journal/`): `jobs/{todo,doin,tada}/`,
`work/<base>`, and per-job `inbox/<base>/`. Per-instance journal clones live
under `GARDEN_STATE` (never a shared worktree). Scripts under `scripts/jobs/`.

## Procedure

- **Post** (`post-job.sh <base> [body]`): write `jobs/todo/<base>`, push;
  idempotent on the basename; retry-with-backoff on contention.
- **Claim** (`claim-job.sh <id>`): fetch+reset to tip, `git mv todo→doin`, stamp
  claim metadata, create `work/<base>` + `inbox/<base>/`, commit, **push — the
  accepted push is the claim**. On rejection, re-sync; if the job already moved,
  **back off to another candidate (never blind-retry a claim)**.
- **Complete** (`complete-job.sh <id> <base> <report>`): remove
  `doin/<base>`/`work/<base>`/`inbox/<base>`, write `tada/<base>`, push. Touches
  only your own basename, so **retry with backoff until it lands**.
- **Reap** (`reaper.sh`): requeue `doin/` claims older than `GARDEN_CLAIM_TTL`.

## Output

A completed job leaves exactly one `tada/<base>` report; `doin`, `work`, and the
inbox for that basename are gone.

## Notes

Claims back off; completions/posts retry — because a retried claim could steal a
job, but a completion/post only ever fast-forwards its own files. Randomized
`backoff` breaks lockstep livelock (a fixed no-backoff retry stranded a job under
8-way contention; see the design doc's test section).
