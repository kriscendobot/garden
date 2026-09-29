# pty-lane self-validation — PR #81 — COMPLETION REPORT

**Final outcome: PASSED** (both required assertions held). Job did no tracked-file
edits, opened no PR, posted no comment — deliverable is this report only.

## 1. Host + deployed SHA
- Worker GARDEN identity: `endolin-garden2-5bcdff64` (`hostname -s` fallback) — matches the pinned `requires: host=`.
- `deployed_sha` (from deployed `common.sh`): `65f0c2e4414d68f9325066014b1bb27b18566ae8`.
- Ancestry: `git merge-base --is-ancestor 4767705b28d 65f0c2e4414…` → **PASS**. PR #81's merge commit `4767705b28d` ("Merge pull request #81 from kriscendobot/feat/pty-context-introspection-lane") is an ancestor of the deployed SHA, so the `lane: pty` branch is live in the deployed tree. (git run only inside the per-job worktree after `git fetch origin main2`.)

## 2. Interactive pty lane proof (REQUIRED) — PASS
- `GARDEN_JOB_BASE=pty-lane-assay-rev5119818493-r1` (lane discriminator, exported by spine).
- `GARDEN_STATE=/home/kris/garden2/.garden-state`.
- `GARDEN_PTY_REPORT_FILE=/home/kris/garden2/.garden-state/pty-context/pty-lane-assay-rev5119818493-r1.report` — **non-empty**; this var is exported only by `pty-lane/run.sh`, so its presence is strong evidence of the lane.
- `GARDEN_PTY_LANE` is **unset** — expected; the deployed lane does not export it, and per `designs/pty-context-introspection-lane.md` the discriminator is `GARDEN_JOB_BASE` and the proof is a fresh reader figure. Not a failure.
- Definitive behavioral proof: the statusLine fired (step 4 reader returned a fresh exit-0 figure) — that channel exists only inside a driven interactive TUI, never under headless `claude -p`.

## 3. Useful work — deployed source inspection + hermetic test
Lane sources (deployed `$root/scripts/jobs/`):
- `pty-lane/run.sh` — the opt-in replacement for a monk's headless `claude -p`; writes a per-session `--settings` layer pointing statusLine at `statusline.sh` (invoked via `bash` to survive a noexec mount), pre-accepts workspace trust in `~/.claude.json` under flock, appends the completion-signal protocol to the prompt, exports `GARDEN_PTY_REPORT_FILE`, then hands off to `run.py`.
- `pty-lane/run.py` — encloses `claude` in a pseudo-terminal, answers the one-time trust dialog, types in the prompt, and detects completion by reading the marker as the last line of the worker's report from the clean signal file (transcript/ANSI screen are fallbacks only).
- `pty-lane/statusline.sh` — the statusLine side channel: on each refresh it extracts `.context_window.*`/`.session_id` from the JSON Claude pipes on stdin, atomically writes a per-job `$GARDEN_STATE/pty-context/<base>.env` state file, and prints a short status line.
- `pty-context-read.sh` — the reader half: reads this job's `.env` back, enforcing freshness (epoch within `GARDEN_PTY_CONTEXT_MAX_AGE=120s` and matching job_base); exit 0 fresh, 2 absent, 3 stale/owner-mismatch.

Hermetic test `test/pty-context-test.sh`:
- **16 passed, 0 failed**, exited **0**.
- Final summary line: `pty-context-test: 16 passed, 0 failed`.

## 4. Live context figure through the reader (REQUIRED) — PASS
- `pty-context-read.sh "$GARDEN_JOB_BASE" --format json` → **exit 0**, output:
  `{"job_base":"pty-lane-assay-rev5119818493-r1","session_id":"dfe6d6fc-399a-5445-8444-a61b7b7a1511","epoch":1790649651,"iso":"2026-09-29T02:40:51Z","age_seconds":1,"used_percentage":"5","remaining_percentage":"95","input_tokens":"51389","output_tokens":"6","context_window_size":"1000000","model":"Opus 4.8"}`
- `--format env` fields: `used_percentage=5`, `input_tokens=51389`, `output_tokens=6`, `context_window_size=1000000`, `epoch=1790649651`, `age_seconds=1`.
- Fresh figure (age_seconds=1, exit 0) on the first attempt — no polling needed.

## 5. Summary
- Worker host: `endolin-garden2-5bcdff64`; deployed SHA `65f0c2e4414d68f9325066014b1bb27b18566ae8`.
- pty lane genuinely selected: **YES** — `GARDEN_PTY_REPORT_FILE` present + reader fresh exit-0 figure (statusLine fired).
- `pty-context-test.sh`: **16 passed / 0 failed**, exit 0 — PASS.
- context-reader: exit 0, fresh figure (5% used, 51389 in / 6 out, 1,000,000 window, age 1s).
- **Final outcome: PASSED** — both required assertions held; no assertion failed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pty-lane-assay-rev5119818493-r1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 7347s

<!-- garden-usage-end -->
