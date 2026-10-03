I fixed the cleric startup failure and landed a guard on main2 (commit `288829c8196`). Clerics are running jobs again, and all nine named jobs are back in `todo/`, or already claimed.

**Root cause (confirmed on endolin-garden-ece02cb4):** `~/.codex/config.toml` held a saved `[mcp_servers.minion-town]` entry pointing at the minion.town URL, with OAuth settings. Codex merges the handler's inline `-c` stdio settings into a saved entry with the same name; it doesn't replace it, even when the whole table is overridden. The merged entry has both a URL and a command, so codex rejects the config ("url is not supported for stdio") and every cleric died at startup. I reproduced this against the installed codex 0.156.

**What I did:**
1. **Host config:** backed it up to `~/.codex/config.toml.bak-20261003-minion-town-url` and removed only the minion-town entries. Auth files were not touched.
2. **Handler change:** `minion_mcp_codex_args` in `scripts/jobs/minion-mcp-lib.sh` now checks `$CODEX_HOME/config.toml` and the worktree's `.codex/config.toml` for a saved minion-town entry. If it finds one, it disables that entry (`enabled=false`) and attaches the minion.town connection under the name `minion-town-garden` instead. If that name is also saved, the job starts without the connection and logs one warning, so the standing order still fails open. `handlers/cleric-codex.sh` and `context/operations/minion-town-mcp.md` are updated to match.
   - **Tests:** I added 7 cases to `scripts/jobs/test/minion-mcp-test.sh`, including one that runs the real codex CLI against a saved URL entry. The test now uses its own `CODEX_HOME`, so the host config can't affect it. `minion-mcp-test` passes 53/53, and the two existing codex tests still pass (21/21 and 7/7).
   - **Other harnesses:** the Kimi and OpenCode handlers don't have this problem, because each job gets its own private config home. Claude's `--mcp-config` is passed as a whole server definition, not merged key by key.
3. **Smoke runs with real `codex exec` and the handler's args:**
   - With the cleaned host config, the job attached as `minion-town` and called the `status` tool successfully (exit 0).
   - With a saved URL entry put back temporarily, the old args reproduced the error. The new args attached as `minion-town-garden` and the `status` call succeeded (exit 0).
4. **Budget pool:** restored with `set-budget-pool.sh codex-endolin 100 codex-cli-rate-limit --kind percent` (journal `139be966e41`). Both clerics then claimed jobs and kept codex running well past the old ~10s failure point. `kriscendobot-garden-book-pr3-review-dcb68a02` ran on a cleric and reached `tada/`. No new "url is not supported" or non-transient failures have appeared since.
5. **Revived jobs:**
   - Promoted from `plan/` (go-ahead gate) with `promote-plan.sh --maintainer`:
     - `garden-book-supervisor-20261003`, already re-claimed and in `doin/`
     - `resume-halted-gauntlets-20261003`
     - `garden-upkeep-watchers-provenance-20261003`
     - `ebfb-pr1380-panel-summary-20261003`
     - `build-confined-application-makers-p2-split-20261003`
   - Already back in `todo/` after a reaper requeue, no action needed:
     - `ebfb-pr1409-panel-summary-20261003`
     - `book-codex-illustrations`
     - `minion-town-claude-cli-provider-conduct-20261003`
     - `fu-endojs-endo-but-for-bots-pr1348-shell-command-grammar-2`
   - None had disappeared from the board, so nothing was re-posted.
   - I didn't touch any `kriscendobot-garden-book-pr*` job. The reaper had already put several back in `todo/` (pr1-conduct, pr1-review, pr3-conduct), and a cleric ran pr3-review to `tada/` on its own claim. If those should stay parked for the book supervisor, someone needs to re-park them.

**Follow-ups:**
- The deployed root checkout still runs the old handler until the next rolling deploy. Until then, the host is protected only because the saved entry is gone; the deploy picks up `288829c8196`.
- Someone, likely an interactive `codex mcp add` or login for minion.town, created the saved entry. If that's run again, the guard now handles it without breaking jobs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-cleric-codex-mcp-url-conflict-20261003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2797625 cached reads)
- Output: 20151 tokens
- Cost: $1.701489
- Wall-clock: 392s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
