The job is already resolved. The exact hard-die it describes no longer exists in `scripts/jobs/triager.sh` on `origin/main2` — it was replaced by commit `2fc8532937 fix(triager): skip transient fetch failures` (current HEAD), which is precisely the hardening this job requests. No changes are needed.

## Completion report

**Finding: already fixed — no-op.**

The job targets `scripts/jobs/triager.sh` line ~117, describing the old body:
```sh
git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"
```
That line no longer exists on `origin/main2`. HEAD (`2fc8532937 fix(triager): skip transient fetch failures`) already replaced it with exactly the bounded-timeout + offline-classification pattern the job asks for (triager.sh:117–140):

- The fetch runs under `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` (the same bounded-timeout shape as `sync_clone`), with stderr captured to a temp file.
- On failure, transient shapes are classified and skipped cleanly: timeout rc `124`/`137`/`143`, **or** `is_transient_net_error "$ERRF"` (which matches the same offline signatures — connection timed out, could not resolve host, i/o timeout, TLS handshake timeout, etc. — as `_fetch_stderr_is_offline`) → `log "WARN: transient fetch failure…"; exit 0` (skip, retry next tick).
- `die "fetch failed for $slug"` now fires **only** for a genuinely non-transient failure, exactly as specified.

One deliberate difference from the job's suggested wording: the skip path uses `exit 0` rather than `exit "$GARDEN_OFFLINE_RC"`. For the triager oneshot this is the correct clean-skip (no systemd `Failed`, no self-heal trigger) and it matches the sibling missing-clone provision path a few lines above, which also `exit 0`s on a transient clone failure. The goal — "skip and retry next tick instead of triggering a systemd failure" — is fully met.

**Changes:** none. Working tree clean; nothing to commit or push.

**Follow-ups:** none. The self-heal that posted this job was almost certainly triggered by a network blip on a tick running the pre-`2fc8532937` code (or a not-yet-deployed root checkout); the source on `main2` is already correct. If the deployed garden root is still on the old triager, a routine deploy of `main2` clears it.
