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
- `gate: awaiting-maintainer` records a pending `maintainer_question:` and the
  issue/PR/comment URL in `asked_at:`. The foreman never selects it. After the
  answer lands, promote it only with the explicit maintainer path below.
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

For an `awaiting-maintainer` job, read the linked answer before clearing the gate:

```sh
scripts/jobs/promote-plan.sh --maintainer <job>
```

Without `--maintainer`, the primitive refuses this gate. To park new work, use
`post-plan.sh --awaiting-maintainer --question '...' --asked-at https://...`.
To repair a wrongly deferred job atomically, use the same three options on
`annotate-plan.sh`; this prevents the foreman from racing a two-step edit.
