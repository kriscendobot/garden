Pushed to `main2` as `22a80a67db`.

## What I did

Fixed `scripts/jobs/library-source-drift-scan.sh` so a drifted source can be refreshed more than once, ever. Both tada-counting guards moved together, as the job required:

- **`post_refresh()` now carries a directive identity** — `library-source-drift:<slug>:<recorded>..<upstream>`. With an identity, `post-job.sh` stops counting `tada/` for the basename and defers to the `jobs/index/<hash>` map, which is keyed on the *drift*, so a new drift of an already-refreshed source is a new directive and posts. I keyed on the recorded sha as well as the upstream one so a refresh that only *partially* advanced the row yields a fresh identity next tick rather than reading as settled.
- **`refresh_present()` → `refresh_live()`**, counting `plan/todo/doin` only — exactly the set `post-job.sh` still treats as blocking for an identity-carrying post. (Added `plan/` so the pre-check matches post-job's live set rather than under-counting.)
- **Basename deliberately left fixed** at `scholar-refresh-<slug>` rather than made per-drift-unique: that keeps post-job's basename check as the authoritative "at most ONE open refresh per source" guard, so a source that drifts twice while its refresh is still queued can't spawn two agents re-ingesting the same slug. This is why I chose the identity route (the spec's #1) over the sha-in-basename route (#3), which would have dropped that guard.
- **New `refresh_settled()`** names the one case post-job would otherwise dedup to a silent no-op: a refresh for *this exact drift* that completed without advancing the recorded file-commit. Logged and counted as `refresh-already-completed=` instead of inflating `posted=`.
- Rewrote the header's § 4 to record why the identity is load-bearing, with the endo error-assert incident as the worked example.

## Verification

Two new cases in `scripts/jobs/test/library-source-drift-scan-test.sh`: a completed refresh drained to `tada/` must not suppress the next drift, and an identical drift whose refresh completed is named rather than re-posted. Ran both ways — old script: **18 passed, 6 failed** (the `SECOND DRIFT` case reproduces the reported bug exactly: `refresh already in lifecycle … posted=0`); new script: **23 passed, 0 failed**. `directive-identity-dedup-test.sh` still passes (19/0), confirming the post-job semantics I'm relying on. shellcheck shows no new findings.

## Notes / follow-ups

- The fix reaches a host only when the deliberate deploy advances its root checkout; the scan runs from there, not from a dev tree. Once deployed, `endo--packages-ses-src-error-assert-js` (`bfa149b4` → `0594e99f`) auto-posts on the next tick — no manual repost needed. Anything else suppressed since each source's first refresh will likewise flush on that tick, so expect a one-time burst of low-priority `scholar-refresh-*` jobs.
- I checked the sibling `library-link-scan.sh` for the same hazard class: it already avoids it with a content-derived basename (`scholar-fix-dangling-nav-links-<hash>`), and its comment explicitly warns against "a fixed name that would post only once ever". No change needed there.
- Residual, now visible rather than silent: a drift whose refresh completes without advancing the recorded file-commit is reported each tick and never re-posted. If that recurs in practice, an escalation after N ticks (a maintainer message rather than a log line) would be the natural next step.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-drift-scan-refresh-once-per-source.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 88 tokens (3477984 cached reads)
- Output: 26393 tokens
- Cost: $3.2715689999999995
- Wall-clock: 405s

<!-- garden-usage-end -->
