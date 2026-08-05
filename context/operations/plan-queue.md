# Promoting parked work

How to tell why a job in `jobs/plan/` has not started and move an authorized job
onto the claimable board. The gate model's rationale and record shape live in
`designs/job-board.md` § 2.5; worked cases are in the
[control-surface gallery](../control-surface-gallery.md#the-plan-queue).

## Read the gate before acting

```sh
sed -n '1,/^---$/p' journal/jobs/plan/<job>.md
```

- `gate: go-ahead` is **awaiting explicit maintainer authorization**. Nothing
  auto-promotes it. Do not interpret the label, the passage of time, available
  credentials, or an idle board as authorization.
- `gate: deferred` is pre-approved work the foreman may select when its active
  target has room. It may also be promoted explicitly.
- `gate: blocked` belongs to the unblock watcher and its `blocked_on` condition.
- `gate: orchestrated` belongs to its orchestration record.

For a `go-ahead` job, the maintainer's “go ahead on <job>” direction is the
authorization and the liaison performs the scheduling act explicitly:

```sh
scripts/jobs/promote-plan.sh <job>
```

Confirm that the record moved from `jobs/plan/` to `jobs/todo/`. If it remains
in `plan/`, it is not scheduled and no gardener can claim it. The foreman's
ranked selector filters for `deferred` only; there is no background retry or
timer for `go-ahead` jobs.

