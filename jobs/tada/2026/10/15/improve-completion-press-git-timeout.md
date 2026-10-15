Pushed to `main2` as `d4ef628b85d`. Job complete.

## Completion report

**Job:** `improve-completion-press-git-timeout` — fix the completion-press first-pass report that blew the 120s fleet git bound (rc 124).

**Finding (re-derived on a clean start):** The job named `scripts/jobs/arc-status-report.sh`, which does not exist. The script that actually builds the completion-press first-pass report is **`scripts/jobs/completion-window-report.py`**, invoked via `--schedule claude-on-minion-town-completion-press` (confirmed by `claude-on-minion-town-completion-report.sh` and the `claude-on-minion-town-completion-press-` prefix handling inside the Python). No prior attempt had committed anything for this job; `main2` was at `8e62adabbbc`.

**Changes (one commit, `d4ef628b85d`):**
1. **Timeout floor** — added `os.environ.setdefault("GARDEN_REPO_GIT_TIMEOUT", "540")` at module load, before any git subprocess. The report's git calls run through the fleet wrapper (`scripts/jobs/bin/git`), which bounds each call by `GARDEN_REPO_GIT_TIMEOUT` (default 120s in `common.sh`). The setdefault gives the report a 540s floor (≥300 as required, matching the known-good manual rerun) while still letting an explicit caller override win.
2. **Cheapen the path-limited log** — added `--no-renames` to the `git log … --name-status --- jobs` call in `history_events()`. Rename detection across every jobs/ churn commit in the window was the bulk of the 82s walk. The loop keys on the **Add** of the destination path (todo→doin→tada moves still surface as an `A` of the new location), so dropping rename pairing is behaviour-preserving.

**Verification:**
- `python3 ast.parse` syntax check: ok.
- `completion-window-report-test.sh`: PASS, before and after the change.
- `accountant-arc-apportionment-test.sh`: 3 failures, confirmed **pre-existing** (same two named failures — `step-reserve lacks arc: unallocated`, `agent invoked while all held` — reproduce with my change stashed out), unrelated to this fix.

**Follow-ups:** The 3 pre-existing failures in `accountant-arc-apportionment-test.sh` are out of scope here but worth a separate look.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-completion-press-git-timeout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1326337 cached reads)
- Output: 13542 tokens
- Cost: $1.6273784999999998
- Wall-clock: 480s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
