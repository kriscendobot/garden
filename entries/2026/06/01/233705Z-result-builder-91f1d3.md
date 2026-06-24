---
ts: 2026-06-01T23:37:05Z
kind: result
role: builder
host: endolinbot
repo: kriskowal/garden
project: garden
to: steward
dispatch_root: /home/kris/dispatches/builder--91f1d3
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - entries/2026/06/01/232900Z-dispatch-steward-91f1d3.md
  - https://github.com/kriskowal/garden/pull/3
---

# result: builder — kriskowal/garden#3 CI job + driver.sh self-improvement loop

Addressed kriskowal's 2026-06-01T23:26:59Z CHANGES_REQUESTED review on PR #3
(review id 4405327036). Both asked-for changes land in a single commit on
`design/driver`. PR remains DRAFT; no PR comments posted; no review threads
resolved; no other branch touched.

## New head

`design/driver` at `0ba1aedfe9a82727efdcc79386f09b0f75135e26` (was
`48afa742`).

## Files

- new `.github/workflows/driver-tests.yml` (the CI job).
- new `tests/driver/test_loop_capture_and_self_improve.sh` (the new test).
- modified `roles/driver/driver.sh` (per-tick capture + agent invocation).
- modified `.gitignore` (carve back `.github/` from the top-level
  dotfile blanket; that blanket exists to keep bot SSH / oauth tokens
  out of the repo, so the negation is explicit and commented).

## CI workflow

Path: `.github/workflows/driver-tests.yml`.

Triggers:
- `push` to `main` and `design/driver`.
- `pull_request` targeting `main`.

Job `driver-tests` on `ubuntu-latest` runs, in order:

1. `actions/checkout@v4`.
2. A git-identity config step (the driver tests build a mock journal
   that runs `git init` and `git commit`, and GitHub runners have no
   default identity).
3. `bash tests/driver/run.sh`.
4. `bash skills/cleaner/test-cleaner.sh`.

The shepherd that follows this builder should watch the `driver-tests`
job on the workflow named `driver-tests` for the `design/driver` push
at SHA `0ba1aedf...`.

## driver.sh self-improvement loop

Each loop iteration in `main` now:

1. Allocates a per-tick capture file under `$TRANSCRIPT_DIR` (the same
   `mktemp` location as the rolling transcript).
2. Runs `( set -x; run_once )` redirecting stdout+stderr into the
   per-tick capture only. After the tick returns, the per-tick capture
   is appended to the rolling transcript so the existing trap path
   still has the full history if anything goes wrong.
3. Calls `capture_and_self_improve <tick-capture> <tick-rc>`. That
   function hashes the capture via
   `git -C "$GARDEN_JOURNAL" hash-object -w --stdin` (the same pattern
   `skills/gardener-inbox-error-reporting/report-error.sh` uses), then
   forks `_self_improve_invoke_async` into the background so the next
   tick is not blocked.
4. Removes the per-tick capture tempfile (its content is already a blob
   in the journal object DB; the background analyzer carries only the
   SHA, not the path).

The background analyzer:
- Builds a four-slot prompt (PR id, workflow, driver state, tick rc,
  capture SHA) and pipes it to `claude -p` from PATH. The prompt
  instructs the agent to read the transcript on demand via
  `git -C <journal> cat-file blob <sha>` rather than expecting it
  inlined.
- A test stub hook (`SELF_IMPROVE_CLAUDE_STUB`) lets tests inject a
  deterministic agent without depending on claude's shape.
- Appends a section to
  `$GARDEN_JOURNAL/drivers/<host>/<lane>.improvements.md` naming the
  ISO timestamp, state, tick rc, capture SHA, PR, workflow, and the
  agent's response body. The file is created with frontmatter
  (`host`, `lane`, `kind: driver-self-improvement-log`) on first
  tick.
- `SELF_IMPROVE_SYNC=1` makes the test harness join the background
  analyzer with `wait` so the test can assert the improvements file
  is written before the driver returns.
- All branches of the capture and analyzer ORs with non-fatal
  fallbacks: missing journal git dir, empty capture, hash-object
  failure, claude not on PATH all return cleanly. Self-improvement is
  best-effort and must not crash the driver.

## Test results

`bash tests/driver/run.sh`: 4 suite(s) passed, 0 failed.

- `test_skeleton.sh`: 20 / 20 passed (unchanged).
- `test_design_only_happy_path.sh`: 17 / 17 passed (unchanged).
- `test_trap_fires_on_error.sh`: 4 / 4 passed (unchanged).
- `test_loop_capture_and_self_improve.sh`: 18 / 18 passed (new).

The new test exercises:

- one oneshot tick produces an improvements file with the expected
  frontmatter (`lane: 1`, `host: mock-host`), a `## tick at` section
  header, the workflow name (`design-only-pr`), and the stub's response
  body;
- the capture SHA the stub records is a real blob in the mock
  journal's object DB (verified via `git cat-file -e <sha>` and a
  content assertion that the blob carries the `+ run_once` -x trace);
- a second oneshot tick appends rather than overwrites (file size
  grows; `## tick at` section count grows);
- a third oneshot tick with `SELF_IMPROVE_CLAUDE_STUB` unset exercises
  the production path where the driver invokes `claude` from PATH;
  the mock-garden harness's PATH-stubbed `claude` records the
  invocation to `claude.log` (`claude invoked with -p`), and the
  improvements file is still written with the stub's default response.

`bash skills/cleaner/test-cleaner.sh`: passes (`pass cleaner skeleton
handles both board shapes`); unchanged.

## Clarifying questions raised

The maintainer's directive was generic ("feeds this to an agent for
analysis and self improvement"). Concrete interpretation decisions
this builder made, each open to maintainer course-correction:

1. **Per-lane improvements file vs. per-PR vs. per-tick file**. Chose
   per-lane (`<lane>.improvements.md`) for symmetry with the existing
   per-lane state file (`<lane>.md`) and subscription file
   (`<lane>.subscriptions`). A long-lived driver lane that handles
   many PRs over its lifetime accumulates one improvements file; a
   per-PR file would fragment and a per-tick file would explode.
2. **Synchronous vs. asynchronous agent invocation**. Chose
   asynchronous (background subshell) as the default; tests opt in to
   synchronous via `SELF_IMPROVE_SYNC=1`. The design's prose said the
   capture-and-analyze step should not block the next tick.
3. **Agent invocation shape**. `printf '%s' "$prompt" | claude -p`,
   matching the `pr-creation-flow` and `prompt-on-failure-capture`
   patterns. No `--output-format json`; the response is appended as
   plain text. If the maintainer wants structured output, the analyzer
   helper is the one knob to turn.
4. **Capture vs. journal entry**. The per-tick blob is unreferenced
   in the journal object DB (no commit, no ref). The improvements
   file is the navigable index. The blob will be collected by
   `git gc` after the grace window unless an agent or operator
   anchors it with `refs/captures/...` per the design's
   prompt-on-failure-capture pattern. This matches the design's
   stated lifecycle for non-recurring captures.
5. **`.gitignore` change**. The repo's `.gitignore` has a deliberate
   `/.[!.]*` blanket to keep bot SSH and oauth tokens out of the
   repo. I added explicit negation rules `!/.gitignore`, `!/.github/`,
   `!/.github/**` with a comment explaining the carve-back, since
   CI workflows are the first tracked dotfile path in the garden. If
   the maintainer prefers a different shape (e.g. a top-level
   `workflows/` dir symlinked from `.github/workflows/`), the workflow
   file moves and the negation can come back out.

## PR-side actions: none

Confirmed:
- PR #3 remains DRAFT (no `gh pr ready` call, no `--ready` flag).
- No PR comments posted (no `gh pr comment`, no API POST to issues
  endpoint).
- No review threads resolved (no `gh api graphql` mutation, no
  resolve thread call).
- No other branch touched (single commit pushed to `design/driver`
  only).
- No other PR touched.

Self-improvement: nothing this time.
