---
orchestration-failed: true
---
# pty-lane assay (garden PR #81): FAILED, because the pty lane was never selected

The lane never ran. This host's deployed code is older than the PR #81 merge, so the handler ignored the job's `lane: pty` header and started a headless `claude -p` session. With no interactive session the status line never fired, and the context reader never returned a figure.

## 1. Host and deployed version
- `GARDEN` = `endolin-garden-ece02cb4` (matches `hostname -s`).
- `deployed_sha` = `e036bb8e0650b66a4ae00dc1516c4c8df39901ca` ("fix(foreman): filter retired `local` provider…", 2026-09-28 18:22Z). I read this from the deployed `/home/kris/garden/scripts/jobs/common.sh`.
- `/home/kris/garden2` does not exist on this host. I used the real deployed root, `/home/kris/garden`.
- `git merge-base --is-ancestor 4767705b28d e036bb8e065` fails, so the deployed version does not include PR #81. It is 13 commits behind origin/main2 (`894f2675637`).

## 2. Was the pty lane selected? No (required assertion: FAIL)
- `GARDEN_JOB_BASE=pty-lane-assay-rev5119818493`
- `GARDEN_STATE` is empty.
- `GARDEN_PTY_REPORT_FILE` is empty, so this session did not come from `pty-lane/run.sh`.
- `GARDEN_PTY_LANE` is unset, which is expected either way.
- The parent process is `/usr/local/bin/claude -p --output-format stream-json …`, started by `/home/kris/garden/scripts/jobs/handlers/monk-claude.sh`. The deployed handler has no `lane:` branch at all (`grep 'lane'` finds only one unrelated comment), and `/home/kris/garden/scripts/jobs/pty-lane/` does not exist. So `lane: pty` was silently ignored and the job ran headless.

## 3. Lane sources and hermetic test: PASS, but only from origin/main2
The deployed root has no lane files, so I read them and ran the test from this job's worktree, which is at origin/main2 `894f2675637`.
- **What the pieces do:** `pty-lane/run.sh` prepares an interactive session: it marks the workspace trusted, adds a `--settings` layer that points the status line at `statusline.sh`, and sets session-persistence environment variables. It then hands off to `run.py`, which runs Claude Code inside a pseudo-terminal and drives it until the completion marker. `statusline.sh` receives the status-line JSON (`context_window.*`, `session_id`) and saves it to a per-job state file. `pty-context-read.sh` reads that file back for a job and reports the figure as present (exit 0), absent (exit 2) or stale (exit 3).
- `bash scripts/jobs/test/pty-context-test.sh` exited 0. Summary line: **`pty-context-test: 16 passed, 0 failed`**.
- **Caveat:** the test at `/home/kris/garden/scripts/jobs/test/pty-context-test.sh`, as the job specified, does not exist on this host. This pass shows the code on main2 works; it says nothing about the deployed version.

## 4. Context reader: exit 2 (absent) (required assertion: FAIL)
- `pty-context-read.sh pty-lane-assay-rev5119818493 --format json` exited 2 with: `pty-context: no figure for 'pty-lane-assay-rev5119818493' (lane off or status line not yet fired)`.
- `--format env` gave the same result, exit 2. None of the fields were produced (used_percentage, input_tokens, output_tokens, context_window_size, epoch, age_seconds).
- I polled every 10s for 90s (9 polls). It was still exit 2 at the end. That is expected: a headless `claude -p` session never runs the status line.

## Tally
| Check | Result |
| --- | --- |
| Host and SHA identified | PASS |
| Pty lane selected / fresh reader figure (required) | **FAIL** (not in the lane; reader exit 2) |
| `pty-context-test.sh` all pass (required) | PASS (16/0), run from origin/main2 because the deployed root lacks the test |

**Final outcome: FAILED.** The pty-lane assertion failed. The cause is a deploy gap on this host, not a defect in the lane code. I changed no files, opened no PR and posted no comments.

## Next steps
- **Redeploy, then re-run:** `endolin-garden-ece02cb4` needs to roll forward to include `4767705b28d` or later before a `lane: pty` assay can succeed here. Then re-post this assay under a new `-rev` suffix.
- **Wrong path in the job spec:** it refers to `/home/kris/garden2`, but this host's root is `/home/kris/garden`. Future assay bodies should use `$GARDEN_ROOT`.
- **Silent fallback:** an out-of-date handler runs `lane: pty` jobs headless without any warning. Only the assay's own reader check caught it. It may be worth having the claim step refuse, or log a warning for, a `lane:` value the deployed handler doesn't support.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pty-lane-assay-rev5119818493.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (299489 cached reads)
- Output: 3553 tokens
- Cost: $0.5454218000000001
- Wall-clock: 125s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
