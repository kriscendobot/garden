Done. Pushed to `main2`.

## Completion report

**What I did:** Dropped the `2>/dev/null` redirect on the `gh_pr_view_retry` command substitution at `scripts/jobs/handlers/ci-rollup-gh.sh:56`, exactly as the job specified.

**What changed:**
```
-json="$(gh_pr_view_retry "$pr" -R "$repo" --json state,statusCheckRollup 2>/dev/null)" \
+json="$(gh_pr_view_retry "$pr" -R "$repo" --json state,statusCheckRollup)" \
```

**Verification:**
- `bash -n` passes.
- Confirmed in `common.sh` that `gh_pr_view_retry` (lines 1503–1535) captures gh's **raw** stderr into its own tempfile (`$errf`) and never leaks it — instead emitting its own classified reason WARN via `log` (definitive rc / transient blip / attempts-exhausted, each with the captured stderr).
- Confirmed `log` (line 232) writes to fd 2. The removed redirect was silencing the whole command-substitution subshell's fd 2, discarding exactly those reason WARNs while suppressing no raw-gh noise. Now the reason flows to the handler's stderr, into `ci-watcher.sh`'s `$rerr` capture. Because `gh_pr_view_retry` emits its WARN *before* line 57's generic fallback log, the reason line lands first and survives `ci-watcher.sh:251`'s `head -n1 "$rerr"`, so the single-script change is sufficient — no widening of the `head -n1` needed.

**Result:** The recurring `#N rollup unreadable (rc=1)` WARNs (#612, and the #503/#313/#463/#286 history) will now carry the real cause — throttle vs. expired-auth vs. closed/deleted-PR 404 race — instead of an opaque rc=1.

**Follow-ups:** None required. The optional `head -n1` → last-non-empty-line widening remains available if a future change wants both the reason WARN and the generic fallback preserved, but it is not needed for this fix.

Committed and pushed to `main2` (rebase CAS loop, first attempt clean).
