The host environment became unrecoverable mid-job and I have exhausted recovery attempts. Delivering my report.

---

**Completion report — `improve-reactji-failure-diagnostic-surfacing`**

**Status: BLOCKED — work complete on disk but NOT committed/pushed. Needs a re-run.** The host shell went unrecoverable partway through and I could not run the tests or commit. Because an uncommitted worktree is torn down, this change must be re-applied by a re-run. Full details below for trivial reproduction.

**What I did (complete and correct in the worktree, uncommitted):**

1. `scripts/jobs/handlers/comment-reactji-gh.sh` (lines 47–48) — applied exactly the asked change:
   - `gh_api_retry -X POST "$path" -f content="$content" >/dev/null 2>&1` → `>/dev/null` only (stdout/JSON payload still suppressed; gh_api_retry's curated WARN diagnostic on stderr now reaches the journal).
   - Fallback `log "reactji POST failed on $path"` → `log "WARN: reactji POST failed on $path"` (so it journals at `<4>` warning priority and survives `journalctl -p warning`). Added a short comment explaining both.

2. `scripts/jobs/test/comment-reactji-diagnostic-test.sh` (new) — drives the handler against a stub `gh` scripted to fail definitively (HTTP 404) and asserts: the `HTTP 404` gh diagnostic reaches stderr, it carries the `<4>` warning prefix, the fallback `WARN: reactji POST failed on …/pulls/comments/999/reactions` line is present and warning-prefixed and names the endpoint, and the reaction JSON payload stays out of both stdout and the journal.

**Important gotcha discovered (cost me the environment):** `common.sh` prepends `$GARDEN_ROOT/scripts/jobs/bin` (the fleet `gh` identity wrapper) to `PATH` when the handler sources it — *ahead* of a plain PATH stub. My first test version put the stub only on `PATH`, so the handler invoked the **real** `gh` wrapper, which made a live GitHub call that hung the foreground shell and wedged the host. I fixed the test by pointing `GARDEN_ROOT` at a throwaway tree and placing the stub at `$TR/scripts/jobs/bin/gh` so the prepend resolves to the stub. **Any future test of this handler must do the same** — a bare PATH stub loses to the fleet wrapper. By the time I fixed it, the host could no longer fork/exec (every Bash call — foreground, background, sandboxed or not — returned exit 1 with no output; even fresh background processes produced no output file), consistent with fork/PID or /tmp exhaustion on this ~100-gardener leader, aggravated by the hung live `gh`.

**What was NOT done:** ran `comment-reactji-diagnostic-test.sh`; re-verified `issue-inbox-watcher-test.sh:268` (its assertion targets the *watcher's* own `WARN: reactji failed` log via `issue-inbox-watcher.sh:188`, unaffected by my handler change, so it should still pass — but I could not execute it to confirm); `git add`/`commit`/`push origin HEAD:main2`.

**Follow-up / re-run guidance:** re-apply the two-line handler edit and the new test (both as above), run both tests, then commit and push to `main2`. Also worth a separate infra note: a host-`gh`-wedge from a test that accidentally calls the real wrapper is a recurring footgun — consider a `GARDEN_BIN`-aware test helper or a guard in the wrapper that no-ops under a test marker.
