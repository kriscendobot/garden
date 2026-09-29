# pty-lane assay (round 2): garden PR #81, review 5119818493

**Outcome: PASSED.** Every required assertion held. No tracked files were edited, no PRs opened, no comments posted.

1. **Host and deployed SHA.** `hostname -s` = `endolin-garden2-5bcdff64`. `deployed_sha` = `d5fb51b1440b29619d93088703426c364eeee80e`. In the per-job worktree, after `git fetch origin main2`, `git merge-base --is-ancestor 4767705b28d d5fb51b1440` returned rc=0, so the PR #81 merge is part of the deployed tree.

2. **Pty lane selected: PASS.**
   - `GARDEN_PTY_LANE` is unset, as expected: the deployed lane does not export it.
   - `GARDEN_PTY_REPORT_FILE=/home/kris/garden2/.garden-state/pty-context/pty-lane-assay-rev5119818493-r2.report` is non-empty. Only `pty-lane/run.sh` exports it.
   - `GARDEN_JOB_BASE=pty-lane-assay-rev5119818493-r2`, `GARDEN_STATE=/home/kris/garden2/.garden-state`.
   - The Bash tool's subprocess reports `[ -t 0 ]` false, `[ -t 1 ]` false, and `tty` = "not a tty". That is expected, because tool subprocesses are not attached to the terminal. The parent `claude --session-id 6a8d7234…` process is on **pts/1**, so the session itself runs inside a pty.
   - With the non-empty report file and a fresh rc=0 figure from step 4, the assertion passes.

3. **Useful work.**
   - `pty-lane/run.sh` (132 lines): replaces the monk's headless `claude -p` call for `lane: pty`. It sets up workspace trust, a `--settings` layer with the noexec-safe statusLine command, and session env, then runs `run.py`. It never passes `-p`, and it exits 0 only if the completion marker appears.
   - `pty-lane/run.py` (227 lines): runs claude inside a pty, answers the trust dialog, types in the prompt, and waits for the completion marker. It checks the signal/report file first and falls back to the transcript and then the ANSI-stripped screen. It extracts the report and exits.
   - `pty-lane/statusline.sh` (83 lines): the statusLine command. It prints the status line and saves the context figures (`used_percentage`, tokens, `context_window_size`, `session_id`, epoch) to `$GARDEN_STATE/pty-context/<base>.env`, keyed per job.
   - `pty-context-read.sh` (74 lines): reads that file back in env, percent or json format. It exits 0 for a fresh figure, 2 if there is no file, and 3 if the figure is stale or belongs to another job or session (default freshness window 120s).
   - `handlers/monk-claude.sh` (around line 480): when `lane = pty` and `provider = anthropic`, it writes the prompt to a file and calls `pty-lane/run.sh`. Any other provider falls back to headless. On completion it deletes `<base>.env` and `<base>.settings.json`.
   - `bash scripts/jobs/test/pty-context-test.sh`: **16 passed, 0 failed, exit 0.**

4. **Live context reader: PASS, first attempt.**
   - Read 1, `--format json`, rc=0: `{"session_id":"6a8d7234-4098-5ac0-8d10-df0cf160d95f","epoch":1790706752,"age_seconds":2,"used_percentage":"5","input_tokens":"49680","output_tokens":"6","context_window_size":"1000000"}`
   - Read 1, `--format env`, rc=0, same fields.
   - Read 2, json, rc=0: epoch 1790706761, age_seconds 0, input_tokens 54723, output_tokens 8, used_percentage 5. The figure was live and still updating.

5. **Summary.**

| Item | Result |
|---|---|
| Worker host | endolin-garden2-5bcdff64 |
| Deployed SHA | d5fb51b1440 (contains 4767705b28d) |
| Pty lane genuinely selected | Yes: report file set, claude on pts/1, fresh statusLine figures |
| Tests | 16/0, rc=0 |
| Reader | rc=0 fresh, used 5% of a 1M-token window |
| Final outcome | **PASSED** |
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pty-lane-assay-rev5119818493-r2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 38s

<!-- garden-usage-end -->
