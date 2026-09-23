The job's requested fix is already fully present in `origin/main2` (HEAD `03833819f7`). No code changes are needed — I verified this rather than blindly re-implementing.

## What I found

The job describes `triager.sh:117` still hard-dying on fetch failure:
```
git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"
```

But that line no longer exists. The current `scripts/jobs/triager.sh:117-128` already implements exactly the transient-skip treatment the job asks for:

```sh
if ! bounded_fetch "$BARE" --all --prune; then
  fmsg="triager: fetch failed for $slug (unreachable/offline?); skipping this tick, retry next"
  log "WARN: $fmsg"
  alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}" "$fmsg"
  exit 0
fi
```

Every requirement is satisfied:
- **WARN log + throttled alert + `exit 0`** instead of `die` — present.
- **Exact dedup key** `triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}` requested by the job — matches verbatim.
- **Bounded fetch** — `bounded_fetch` (`common.sh:712`) wraps the fetch in `timeout --kill-after=$GARDEN_FETCH_KILL_AFTER $GARDEN_FETCH_TIMEOUT` with SIGKILL escalation, bounded retries, and backoff, so a hung `git fetch --all` is reaped cleanly rather than by an external SIGTERM — this is the optional bounding the job suggested, already done.
- **Cursor not advanced on skip** — the `exit 0` (line 127) runs before the activity-cursor block (`CURSOR_KEY="activity/$slug"` at line 167), so a skipped tick leaves the cursor in place to re-triage once the network recovers.

## History

The fix landed across a series of prior commits now in `main2`, notably `a335cf0aca fix(triager): skip and alert on every fetch failure`, `457ba8a795 fix(triager): skip failed refresh ticks`, and `0c940939e7 fix(triager): share bounded fetch helper`. This self-heal job was posted from a flap captured against an older triager, but the underlying flaw was already remediated by the time the job was claimed.

## Changes / follow-ups

- **Changes:** none — no commit made, since the working tree already matches the desired state and an empty commit would add noise.
- **Follow-ups:** none. The `garden-triager@<slug>` unit will no longer flap on a killed/hung agoric-sdk fetch; a persistent outage surfaces once per throttle window via `alert_maintainer`.
