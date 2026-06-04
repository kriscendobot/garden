---
created: 2026-06-04
updated: 2026-06-04
author: gardener
---

# Skill: design-poller

The contract for the `garden-design-poller` systemd service: a deterministic single-instance daemon that walks a project's roadmap branch on a cadence, identifies design documents that are *ready to be built*, and posts a `build` job to the role-specific job board for a driver lane to claim. Reconstructs the design-queue-walk + slot-refill function of the retired `general-contractor` posture as deterministic infrastructure that the driver lanes consume.

## Purpose

The maintainer's framing on 2026-06-03: *"I have dismantled the contractor. The role has not been working and I would like to reconstruct it on the driver. That is, that there will be a new, deterministic systemd service in the driver container that will poll the llm branch for new designs that are ready to be built and then post a job for a driver."*

The contractor's slot machinery used an LLM-in-the-loop per-cycle scan to identify ready-to-build designs and dispatch builders. The pattern was unreliable in practice; replacing the LLM-in-the-loop scan with a deterministic bash daemon and routing the work to the driver pool keeps the function but removes the failure modes.

## Inputs

- `project_slug`: the short project name (today: `endo-but-for-bots`). The poller's instance is configured for one project per service unit; running multiple projects means multiple service instances (`garden-design-poller@<project>.service` is a templated future variant; the initial unit is single-instance for `endo-but-for-bots`).
- `roadmap_branch`: the branch carrying the design queue (today: `llm` on `endojs/endo-but-for-bots`).
- `cadence_seconds`: poll interval. Default 600 seconds (10 minutes). The cadence is generous because the design queue moves slowly (a new design lands maybe once a day at peak); the cost of polling more often is wasted `git fetch` traffic.
- `target_role`: the role-specific board the poller posts to. Default `builder` (jobs land at `journal/jobs/builder/open/`).
- `state_file`: path to the poller's last-known-state file. Default `~/.local/state/garden-design-poller/<project>.md`. Carries the last-posted design slugs so the poller does not re-post the same design across runs.

## State

The state file at `~/.local/state/garden-design-poller/<project>.md`:

```yaml
---
project: <slug>
roadmap_branch: <branch>
last_poll_at: <ISO>
last_roadmap_sha: <commit>
posted_designs:
  - slug: <design-slug>
    posted_at: <ISO>
    job_path: journal/jobs/<role>/open/<filename>
    job_short_id: <hex>
  - ...
---

# garden-design-poller state for <project>
```

The state file is committed and pushed to `origin/journal` after every state change. Concurrent pollers on sibling hosts share the same project's `posted_designs` list, so a design that one host already posted is not re-posted by another. The git push to `origin/journal` is the serialization point.

## Procedure

The service unit runs `scripts/daemons/design-poller.sh <project_slug>` in a loop with `Restart=on-failure`. Each iteration:

1. **Fetch the roadmap branch.** `git -C worktrees/<owner>-<repo>.git fetch --quiet origin <roadmap_branch>`. Cheap; no working tree write.
2. **Check whether the roadmap advanced.** Compare `git rev-parse origin/<roadmap_branch>` against the state file's `last_roadmap_sha`. On no advance, sleep `cadence_seconds` and continue. (The state-file update is itself a no-op when the SHA is unchanged.)
3. **Walk the design queue.** Use `skills/design-queue-drift-check/SKILL.md`'s eligibility filter to classify designs in `designs/` on the roadmap branch as `eligible` / `blocked-on-design-revision` / `blocked-on-dependency` / `blocked-on-maintainer-decision`. The filter is deterministic; the poller runs it as a sub-script invocation.
4. **Diff against `posted_designs`.** The set of designs the poller should post jobs for is `eligible ∩ NOT posted_designs`. Designs whose dependencies have completed (per `skills/design-dependency-walk/SKILL.md`) and whose status advanced from `blocked-on-dependency` to `eligible` re-enter the post set.
5. **Post one `build` job per newly-eligible design.** Use `skills/job-board/post-job.sh build draft-initial-pr-<design-slug> --repo <owner>/<repo> --design designs/<design-slug>.md --eligible builder` to land the job. The job body names the design path, the project, the roadmap branch, and the eligibility-filter's classification rationale so the claiming driver has the full context. The posted file's path is recorded back into `posted_designs[].job_path`.
6. **Update state and push.** Commit the state file change (the bumped `last_poll_at`, `last_roadmap_sha`, and any new `posted_designs` entries) and push to `origin/journal` via the standard journal-sync retry-on-rejection pattern.
7. **Sleep.** `sleep <cadence_seconds>` and loop.

The poller does **not** consume work, dispatch subagents, or interact with project worktrees beyond the bare-clone fetch in step 1. Its job is purely to produce jobs.

## Idempotency

The `posted_designs[].slug` list is the canonical record of what the poller has already posted. A poller restart re-reads the state file and resumes; it does not re-post designs whose slugs are already in the list. A design that was posted, claimed, and completed by a driver lane stays in `posted_designs` (the slug does not roll out); a design whose builder dispatch failed and was abandoned re-enters eligibility only after the maintainer or a fixer explicitly clears the slug from the state file. The clear step is manual today; a future automation could roll the abandoned-claim job's `abandoned/` file back into a re-post, but the current shape is conservative.

## When a design's status changes

The eligibility filter classifies designs by reading the project's roadmap README (today `designs/README.md` on `llm`) plus per-design `Status:` metadata. When a design moves from `blocked-on-dependency` to `eligible` because its blocking PR merged, the poller's next iteration re-classifies it and posts a job; the state file's `posted_designs` list does not need a manual edit.

When a design moves from `eligible` back to `blocked-on-design-revision` because the maintainer is reworking it, the poller does not re-post (the slug is already in `posted_designs` from the earlier post) and the in-flight claimed job continues. If the maintainer wants the in-flight build cancelled, that is a separate action via `gh pr close` on the resulting draft PR; the poller is not involved.

## Composition with neighbouring skills

- [`skills/design-queue-drift-check/SKILL.md`](../design-queue-drift-check/SKILL.md) — the canonical eligibility filter. The poller invokes it once per iteration.
- [`skills/design-to-pr-pipeline/SKILL.md`](../design-to-pr-pipeline/SKILL.md) — the procedure for the *initial PR* shape the driver lane produces. The poller's posted-job body cites this skill so the claiming driver follows it.
- [`skills/design-dependency-walk/SKILL.md`](../design-dependency-walk/SKILL.md) — the cross-design dependency walk that the eligibility filter consults.
- [`skills/job-board/SKILL.md`](../job-board/SKILL.md) — the post-job mechanism the poller invokes.
- [`skills/journal-sync/SKILL.md`](../journal-sync/SKILL.md) — the state-file commit-and-push procedure.

## Systemd unit

The unit file lives at `scripts/systemd/garden-design-poller.service`. Single-instance (one poller per driver container; today the only configured project is `endo-but-for-bots`, hard-coded in the unit). The unit's `ExecStart` invokes `scripts/daemons/design-poller.sh endo-but-for-bots`; the daemon script reads `cadence_seconds` from `config.sh` and runs the loop above. Restart on failure with a 30-second back-off.

## Notes

- **Why one project per service unit.** Each project has its own roadmap branch, its own bare clone, and its own state file. Templating the unit with the project slug as `%i` is the natural future shape, but today the only active project is `endo-but-for-bots` and the unit is single-instance for simplicity.
- **Why the state file is journal-side, not local-only.** Pollers on sibling hosts compete for the same posted-designs space. The `posted_designs[].slug` list is the canonical record across hosts; committing it to `journal/` lets every host's poller see what every other host's poller has already posted. Local-only state would race.
- **Why the poller does not claim its own posted jobs.** The poller is the producer; driver lanes are the consumers. Mixing the two would re-introduce the contractor's failure mode (one process tracking both ends of the work). The boundary is the role-specific job board; everything before the board is the poller, everything after is a driver lane.
- **Liveness.** The unit's `Restart=on-failure` covers transient crashes. Long silence (e.g. the daemon hangs without crashing) is surfaced via the per-poll state-file bump that lands on `origin/journal`; if `last_poll_at` falls more than two `cadence_seconds` behind wall time, the daemon's `systemd --user status garden-design-poller` shows the stall and the operator (or a future health-check daemon) restarts the service.

## Notes from the field

- _2026-06-04_: skill landed by gardener after the maintainer dismantled the `general-contractor` posture on 2026-06-03 with the directive *"reconstruct it on the driver. That is, that there will be a new, deterministic systemd service in the driver container that will poll the llm branch for new designs that are ready to be built and then post a job for a driver."* The skill is the contract; the actual bash daemon at `scripts/daemons/design-poller.sh` and the systemd unit at `scripts/systemd/garden-design-poller.service` land in a separate builder dispatch. This skill is the dispatch's reference brief.
