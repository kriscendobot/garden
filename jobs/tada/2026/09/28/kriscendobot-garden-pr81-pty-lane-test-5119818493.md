---
orchestration-failed: true
---
# PR #81 pty-lane live validation: FAILED. This host runs a build without PR #81, so the job ran in the old headless mode.

**Worker host:** `endolin-garden-ece02cb4` (monk gardener 2)
**Deployed SHA:** `e036bb8e0650b66a4ae00dc1516c4c8df39901ca`

The deployed checkout on this host was **not built from a commit that includes PR #81**. `git merge-base --is-ancestor 4767705b28d e036bb8e065` returns 1, and `e036bb8e065..origin/main2` is 13 commits. `/home/kris/garden/scripts/jobs/pty-lane/`, `pty-context-read.sh` and `test/pty-context-test.sh` don't exist in the deployed root. The deployed `monk-claude.sh` has no `lane: pty` branch, so the `lane: pty` header was ignored and the job ran as ordinary headless `claude -p`. Also, `/home/kris/garden2`, named in the job spec, doesn't exist on this host (`ls: cannot access`); the garden root here is `/home/kris/garden`, so I used that. I edited, committed, pushed and commented nothing.

## Step 1: Lane proof
```
$ hostname                          → endolin-garden-ece02cb4
$ echo GARDEN_PTY_LANE=…            → GARDEN_PTY_LANE=            (NOT set)
$ echo GARDEN_PTY_REPORT_FILE=…     → GARDEN_PTY_REPORT_FILE=     (empty)
$ echo GARDEN_JOB_BASE=…            → GARDEN_JOB_BASE=kriscendobot-garden-pr81-pty-lane-test-5119818493
$ [ -t 0 ] …                        → stdin-not-tty
```
Process ancestry (no `pty-lane/run.py` anywhere):
```
3335948 3324822 /bin/bash -c source …shell-snapshots…
3324822 3324048 /usr/local/bin/claude -p --output-format stream-json --verbose --dangerously-skip-permissions --max-budget-usd 19.00 --session-id 27db98dd-… --model claude-opus-5-5 …
3324048 3324047 /bin/bash /home/kris/garden/scripts/jobs/handlers/monk-claude.sh kriscendobot-garden-pr81-pty-lane-test-5119818493 …
3324047 3535094 timeout --foreground --signal=TERM --kill-after=60 7200 …monk-claude.sh …
3535094 3535008 /bin/bash /home/kris/garden/scripts/jobs/gardener.sh 2
3535008     218 /bin/bash /home/kris/garden/scripts/jobs/self-heal-run.sh garden-monk --work-id 2 -- …gardener.sh 2
    218       1 /usr/lib/systemd/systemd --user
```
`GARDEN_PTY_LANE` was not set. Even in the `main2` code, `run.sh` exports only `GARDEN_PTY_REPORT_FILE`, `GARDEN_JOB_BASE` and `GARDEN_STATE`, never `GARDEN_PTY_LANE`. Here none of the lane variables were exported, because the lane code isn't deployed.

## Step 2: Deployed SHA
`bash -c 'source /home/kris/garden/scripts/jobs/common.sh >/dev/null 2>&1; deployed_sha'` printed `e036bb8e0650b66a4ae00dc1516c4c8df39901ca` and exited 0. That commit is "fix(foreman): filter retired `local` provider…" from 2026-09-28 18:22Z.

## Step 3: How the lane works, and the test
I read the implementation from my worktree at `origin/main2` `894f2675637`, since the deployed copy doesn't exist:
- **Selection:** `monk-claude.sh` reads `lane` from the job header (`plan_field`). Only `lane: pty` with `provider: anthropic` goes to `pty-lane/run.sh`. Any other value, or any other provider, silently takes the headless `claude_call` path.
- **Setup (`run.sh`):**
  - Writes a per-job `--settings` file whose statusLine runs `bash …/statusline.sh`. It uses `bash` so a filesystem that forbids running files directly (noexec) can't break it.
  - Pre-accepts workspace trust for the worktree in `~/.claude.json`, with a lock (`flock`) around the edit.
  - Exports `GARDEN_PTY_REPORT_FILE=$GARDEN_STATE/pty-context/<base>.report` and `GARDEN_JOB_BASE`.
  - Appends a "PTY-LANE COMPLETION PROTOCOL" to the prompt, then runs `run.py`, which starts Claude interactively in a pseudo-terminal (no `-p`).
- **Context figure:** `statusline.sh` parses Claude's statusLine JSON (`context_window.*`, `session_id`). It writes `pty-context/<base>.env` atomically, one file per job. `pty-context-read.sh` reads it back: exit 0 means a fresh figure, 2 means no file, 3 means stale (older than 120 s) or owned by another job.
- **Completion:** `run.py` polls the signal file first and the session transcript as a fallback. It writes the report to `$report` and returns 0 only if the completion marker is present. `monk-claude.sh` records `outcome=complete-candidate` with an empty `result_event`. The completion nudge and nested usage metering are skipped, and usage accounting falls back to the session-snapshot delta. `run.sh` and `monk-claude.sh` delete the settings, signal and `.env` files afterwards.

Test runs, with `TMPDIR` set to a scratch directory under `/home/kris/garden/scratch`:
- `bash /home/kris/garden/scripts/jobs/test/pty-context-test.sh` → `No such file or directory`, **exit 127**.
- For comparison, the `main2` copy (`bash scripts/jobs/test/pty-context-test.sh` in my worktree) → **`16 passed, 0 failed`, exit 0**.

## Step 4: Live context reader
- `/home/kris/garden/scripts/jobs/pty-context-read.sh` → `No such file or directory`, **exit 127**. I tried 4 times, 10 s apart.
- For comparison, the `main2` copy with `GARDEN_STATE=/home/kris/garden/.garden-state`, in both default and `--format json` → exit 2 all 4 times, 10 s apart: `pty-context: no figure for 'kriscendobot-garden-pr81-pty-lane-test-5119818493' (lane off or status line not yet fired)`.
- `/home/kris/garden/.garden-state/pty-context` doesn't exist, so the statusline never ran.
- No fields were produced: no `used_percentage`, `epoch`, `job_base` or `session_id`.

## Assertions
| # | Result | Evidence |
|---|---|---|
| A1 interactive lane | **FAIL** | `GARDEN_PTY_LANE` and `GARDEN_PTY_REPORT_FILE` are both empty; the parent process is `claude -p --output-format stream-json`, with no `run.py` in the ancestry; stdin is not a tty. |
| A2 deployed SHA non-empty | **PASS** | `e036bb8e0650b66a4ae00dc1516c4c8df39901ca` |
| A3 test exits 0, zero failures | **FAIL** | The deployed test is absent (exit 127). The `main2` copy passes 16/0 with exit 0, but that isn't the deployed code. |
| A4 live reader fresh | **FAIL** | The deployed reader is absent (exit 127); the `main2` reader exits 2 because no state file exists. |

**Outcome: FAILED (A1, A3, A4).** The lane code itself isn't at fault: this host's deployed checkout is 13 commits behind `main2` and doesn't include PR #81. The pty-lane completion protocol wasn't added to my prompt and `GARDEN_PTY_REPORT_FILE` is empty, so there was no signal file to write. This report on stdout is the only record.

**Follow-ups:**
- Deploy `main2` (≥ `4767705b28d`) to `endolin-garden-ece02cb4`, or pin the re-test to a host that already runs PR #81, then re-post this test.
- Use `/home/kris/garden` rather than `/home/kris/garden2` in the job body for this host.
- `lane: pty` on a host without the lane silently runs headless. A gardener could warn or refuse when it sees an unknown `lane:` value.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-pr81-pty-lane-test-5119818493.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (343466 cached reads)
- Output: 5355 tokens
- Cost: $0.5968332000000001
- Wall-clock: 108s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
