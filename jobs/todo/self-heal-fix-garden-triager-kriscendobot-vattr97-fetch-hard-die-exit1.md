In `scripts/jobs/triager.sh` line 117, the routine fetch of an already-provisioned bare clone hard-dies on failure:

```sh
git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"
```

A transient `git fetch --all --prune` failure (network blip / DNS / a half-open connection reaped by SIGTERM — observed signature: a `Terminated` line immediately followed by `FATAL: fetch failed for kriscendobot-vattr97`) makes the unit `exit 1`, so systemd restart-loops it and the self-heal responder fires on every blip. This contradicts the script's own documented invariant (header lines 47–72: "a missing clone must never be a hard die — that drove an every-tick systemd failure/restart") and the self-provision path (lines 94–105) which already treats a failed fetch/clone as skip-cleanly-and-retry.

Fix: replace the `die` on line 117 with the same graceful-skip pattern used for the provisioning-fetch failure — on non-zero fetch exit, `log "WARN: ..."`, call `alert_maintainer` with a deterministic per-slug dedup key (`triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}`) so a *persistent* failure surfaces at most once per window, then `exit 0`. The durable journal cursor (`activity/$slug`, lines 139–142) guarantees the next tick resumes from the last committed sha, so skipping loses no work. Keep the message distinct from the provisioning one so a maintainer can tell "existing clone can't fetch" from "clone missing and couldn't self-provision". No behavior change for the success path.
