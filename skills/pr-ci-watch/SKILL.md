---
created: 2026-05-12
updated: 2026-06-24
author: gardener
---

# Skill: pr-ci-watch

Watch a single pull request's CI status check rollup, emit one line per check transition, and stop when every check has settled. Called from the gardening gauntlet's CI-watch / shepherd step (the gardening state machine's loop-on-CI decision, per [`designs/gardening-state-machine.md`](../../designs/gardening-state-machine.md)). Pair with [github-activity-poll] when you also want a polite "anything moving on this repo?" cadence gate, but the rollup query below is the source of truth, because `check_run` and `check_suite` events do **not** appear on the `/repos/<repo>/events` feed.

## Inputs

- `repo`: `owner/name`.
- `pr`: PR number (integer).
- `state_dir`: directory to read/write polling state. Default: `<worktree>/.garden-monitor/<owner>-<repo>-pr<pr>/`.
- `also_poll_activity` (optional, default false): if true, run the [github-activity-poll] skill against `<repo>` in the same tick for repo-wide situational awareness. The activity poll has no effect on the rollup logic; it just emits one extra line on change.

The skill assumes `gh auth status` succeeds (i.e. the `gh` CLI is authenticated for the target repo). Token via `$GITHUB_TOKEN` is also honored by `gh`.

## State files

Inside `state_dir`, all writes atomic (write `*.tmp`, then `mv`):

- `prev_rollup.txt`: one line per check from the previous tick, sorted, format `<name>\t<status>\t<conclusion>`. Missing fields written as `-`.
- `terminal.txt`: sentinel created the first tick we see every check `COMPLETED`. Records `total=<n> failed=<m> sha=<commit>` of the rollup's head commit. Subsequent ticks short-circuit to a one-line report and exit.

## Procedure

1. `mkdir -p <state_dir>`. If `terminal.txt` exists, emit `terminal repo=<repo> pr=<pr> $(cat terminal.txt)` and stop. The watch is done.

2. (Optional) If `also_poll_activity`, run [github-activity-poll] for `<repo>` and emit its single-line report alongside the rollup output. Do not gate the rollup query on its result.

3. Fetch the rollup:

   ```
   gh pr view <pr> --repo <repo> --json statusCheckRollup,headRefOid \
     --jq '.statusCheckRollup[] | [.name, (.status // "-"), (.conclusion // .state // "-")] | @tsv' \
     | LC_ALL=C sort > "$state_dir/cur_rollup.txt"
   ```

   - `statusCheckRollup` mixes GitHub Actions `CheckRun` (which has `.status` + `.conclusion`) and legacy `StatusContext` (which has only `.state`). The `--jq` above normalizes both shapes.
   - If `gh` errors (network, auth, repo gone), abort the tick. Do **not** overwrite `prev_rollup.txt`. Report the failure and exit non-zero so a `/loop` driver (or the gardening loop decision) can decide whether to keep ticking.

4. Diff against `prev_rollup.txt`. For each line in `cur_rollup.txt` whose tuple `(name, status, conclusion)` differs from the previous tick (including names not seen before), emit:

   ```
   check: <name> status=<status> conclusion=<conclusion>
   ```

5. Atomically replace `prev_rollup.txt` with `cur_rollup.txt`.

6. Compute terminal state from `cur_rollup.txt`:

   - `total`: line count.
   - `pending`: lines whose `status` is **not** `COMPLETED`. Note: a status of `QUEUED`, `IN_PROGRESS`, `WAITING`, or `PENDING` is still pending; only `COMPLETED` is terminal at the per-check level.
   - `failed`: lines whose `conclusion` (or `state`) is one of `FAILURE`, `CANCELLED`, `TIMED_OUT`, `ACTION_REQUIRED`, `STARTUP_FAILURE`, `ERROR`. `NEUTRAL` and `SKIPPED` do **not** count as failures.

7. If `pending == 0`:

   - Write `terminal.txt` atomically with `total=<n> failed=<m> sha=<headRefOid>`.
   - Emit:

     ```
     rollup-terminal repo=<repo> pr=<pr> total=<n> failed=<m> sha=<headRefOid>
     ```

   Else, if no transition was emitted in step 4, emit:

   ```
   no-change repo=<repo> pr=<pr> pending=<k> total=<n>
   ```

8. Exit 0.

## Output shape

Per tick, in order:

- 0 or 1 `activity: ...` line (only if `also_poll_activity`).
- 0..N `check: <name> status=<s> conclusion=<c>` transition lines.
- Exactly one terminal line of one of:
  - `no-change repo=<repo> pr=<pr> pending=<k> total=<n>`: checks still running, nothing changed.
  - `rollup-terminal repo=<repo> pr=<pr> total=<n> failed=<m> sha=<sha>`: every check settled, this tick or a previous one.
  - `terminal repo=<repo> pr=<pr> total=<n> failed=<m> sha=<sha>`: short-circuit from a prior `terminal.txt`.

This shape is line-oriented so a `Monitor` driver (or the gardening script's loop step) can route each line as a single notification, and `grep`/`awk` can extract progress in batch use.

## Cadence

- Roughly one tick per minute is the sweet spot. CI runs on GitHub are 5–30 minutes; faster polling wastes API calls without revealing transitions any sooner. The activity feed is server-cached for ~60 s; the rollup query reads from a different cache but is similarly bounded.
- The rollup query costs 1 GraphQL point against the authenticated user's hourly budget (5000/hr), regardless of how many checks the PR has. The activity poll, when it 304s, costs nothing. So a watch that runs for hours is comfortably within limits.
- For long watches, drive from `/loop`, a cron routine, or the gardening state machine's loop-on-CI decision. The skill itself does one tick and exits.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-05-12_: `check_run` and `check_suite` activity does **not** surface on `/repos/<repo>/events`, even with auth. The events feed is push/PR/issue-scoped. So a watch that only If-Modified-Since's the activity feed will sleep through a full CI cycle. Always poll the rollup directly; treat the activity feed as a separate, optional signal.
- _2026-05-12_: on macOS the system `bash` is 3.2. Combining `set -u` with `"${arr[@]}"` on an **empty** array raises "unbound variable" and the curl line silently produces no output. If you write the tick in shell, either drop `set -u` or use `"${arr[@]+"${arr[@]}"}"`. The symptom is a notification line like `activity-feed http=` with a blank code.
- _2026-05-12_: `mergeStateStatus: BLOCKED` together with `reviewDecision: REVIEW_REQUIRED` and an all-green rollup is the normal "waiting for human review" end state. Do not treat as a CI failure; the watch is done at `rollup-terminal failed=0`.
- _2026-05-12_: when a PR force-pushes (rebase, amend), all check IDs change and you will see transitions for the same names back to `QUEUED`. The skill handles this naturally because it diffs on `(name, status, conclusion)` not on check id. The `sha=` field in `terminal.txt` records which commit settled, so a downstream "is this still the same head?" check is cheap.
- _2026-05-12_: per-job logs are available via `gh api repos/<repo>/actions/jobs/<job_id>/logs` as soon as that job finishes, even while the parent run is still in progress. `gh run view --log-failed` refuses until the whole run is done. To fetch a specific failure's log mid-run, keep `.detailsUrl` in the rollup query (form `.../actions/runs/<run>/job/<job_id>`) and extract the `<job_id>` from it.
- _2026-05-12_: GitHub Actions matrix jobs fail-fast by default. When one shard fails (e.g. `test-boot (node-new, 2, 4)`), siblings on the same shard index across the other matrix dimensions get CANCELLED in the same tick. A CANCELLED that lands alongside a sibling FAILURE is a downstream consequence, not an independent failure; the original FAILURE is the actionable one. Report both, but do not pursue the cancellation as its own bug.
- _2026-05-12_: rollups grow during a run. Downstream jobs register as checks only once their prerequisites complete (a green build job spawns its test jobs, etc.). A PR that starts at ~15 checks can settle at 70+. The procedure's diff on `(name, status, conclusion)` handles new names naturally; do **not** snapshot the initial check set and assume it is the complete set.
- _2026-05-15_: when a reader of this skill sees a `check: <name> ... conclusion=FAILURE` whose check name matches a known operational-flake ignore-broadcast, and no CI re-run on this PR has fired since the ignore was set, the reader re-runs the failed job (`gh run rerun <run-id> --failed`) before treating the failure as gating. This defensive re-run protects against the gap when an ignore-broadcast omitted its companion re-run.
- _2026-05-18_: when a PR's `statusCheckRollup` is `[]` indefinitely after a push (zero workflow runs visible in `gh api repos/<o>/<r>/actions/runs?head_sha=...`), query `mergeable_state` before assuming a GitHub Actions queue delay, workflow-approval gate, or first-time-contributor gate. A `CONFLICTING` / `DIRTY` PR cannot dispatch `pull_request` workflows because GitHub does not create the synthetic merge ref while the conflict exists. One-liner: `gh pr view <N> -R <repo> --json mergeable,mergeStateStatus`. Remediation is a rebase / [conflict-resolution](../conflict-resolution/SKILL.md) gardening step, not a CI re-run. Precipitating case: PR #286 on `endojs/endo-but-for-bots` had zero CI runs for ~25 minutes; cause was a `designs/README.md` conflict against `llm`.
- _2026-06-24_: migrated from v1. Re-pointed the shepherd / steward framing at the gardening gauntlet's CI-watch step; the conflict-remediation references now link [conflict-resolution](../conflict-resolution/SKILL.md). The line-oriented output is unchanged.
