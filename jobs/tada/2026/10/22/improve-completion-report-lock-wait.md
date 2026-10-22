I fixed `scripts/jobs/claude-on-minion-town-completion-report.sh` and pushed it to `main2` as `b526b1d84d8`. A stub test passed, but I have not run it against the real journal.

**What changed:**
- **Longer lock wait:** the wrapper now exports `GARDEN_REPO_LOCK_WAIT` with a 240s floor and keeps any larger value the caller already set. I didn't use `: "${GARDEN_REPO_LOCK_WAIT:=240}"` as the job suggested. That form would keep the 10s default if a caller had already exported it after sourcing `common.sh`, which is the case it needs to cover. The wrapper never sources `common.sh` itself; its git calls go through the fleet git wrapper (`scripts/jobs/bin/git`), which reads this variable from the environment.
- **Retry once on rc 124:** the wrapper used to `exec` `completion-window-report.py`. It now runs it, and if it exits 124 the first time, it logs a line to stderr and runs it once more. Output is held in a temp file, so a failed first attempt can't leave partial JSON ahead of the retry's report. The final exit code is passed through.

**Testing:** I ran a copy of the wrapper against a stub report script. With an inherited 10s it raised the wait to 240s, and with 600 it kept 600. When the stub failed once with 124, the wrapper retried and printed only the second attempt's output, exit 0. When it failed twice, the wrapper exited 124 with no extra retry. With no failure it ran once, exit 0.

**Follow-ups:** none required. Other scheduled report wrappers that go through the fleet git wrapper could hit the same 10s lock timeout; they weren't in scope here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-completion-report-lock-wait.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (358726 cached reads)
- Output: 3690 tokens
- Cost: $0.4645772
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
