Repo: garden (kriskowal/garden), file `scripts/jobs/triager.sh`, line 117.

Failure signature (garden-triager@kriscendobot-agoric-3-proposals, exit 1): a SIGTERM-reaped `git fetch` prints bash's `Terminated`, then the trailing `|| die "fetch failed for $slug"` hard-fails the oneshot — marking the unit Failed and waking the self-healer on a merely transient network blip.

Change: `scripts/jobs/triager.sh:117` runs a raw, unbounded, non-offline-classifying fetch:
```
git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"
```
This bypasses the fleet's stuck-fetch hardening in `scripts/jobs/common.sh` (§ "bounded git network operations", ~L194-242; the `sync_clone`/`journal_fetch` bounded-timeout + offline-classification pattern at ~L2483-2511). Replace it with the same discipline the rest of the fleet uses:
1. Bound the fetch with `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` and `GARDEN_FETCH_RETRIES` bounded attempts (git has no default IO timeout, so a half-open connection can stall forever — the `GIT_HTTP_LOW_SPEED_*`/`GIT_SSH_COMMAND` env belts already set in common.sh are not a hard bound). Prefer reusing an existing helper (e.g. a `bounded_fetch`/`sync_clone`-style path) rather than open-coding a new `timeout` loop; if none is directly reusable for an arbitrary `--git-dir` bare clone, factor one out of the `journal_fetch`/`sync_clone` code so both callers share it.
2. On a **transient/offline** failure (rc 124 or 137, or stderr matching the offline signature via the existing `_fetch_stderr_is_offline`/`is_transient_net_error` helper), take the clean-skip path — `log "offline; skipping tick"; exit 0` (retry next timer tick) — instead of `die`. This mirrors both the triager's own provisioning branch (triager.sh:95-104, which already skips cleanly on a transient clone-fetch failure) and `sync_clone`'s EX_TEMPFAIL handling. Only a **structural** fetch failure (auth, deleted fork, wrong ref) should still `die`/escalate.

Rationale: dying on a transient fetch failure provides no recovery benefit (a Type=oneshot timer re-runs the same fetch next tick either way) and only produces a Failed unit plus a self-heal invocation per network blip. Add/adjust a triager test to assert that a fetch killed at the timeout (simulated rc 124/137) results in a clean skip (exit 0), not a die.
