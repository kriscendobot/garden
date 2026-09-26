The job is already complete on `main2` — landed by a peer while I worked.

## Completion report

**Task:** Make the triager's steady-state bare-clone fetch failure non-fatal (WARN + `exit 0` + retry next tick) instead of hard-`die`, mirroring the self-provision clone path, with optional persistent-failure escalation.

**Outcome: already satisfied on `origin/main2` by a concurrent peer** — no push needed from me.

While I was implementing this, a peer landed two commits addressing the identical issue:
- `b20e03ff3c` fix(triager): a non-transient steady-state fetch failure skips, not dies
- `fae75ed3d3` fix(triager): steady-state fetch failure skips+alerts, never dies

Their landed fix does everything the job asked:
- The last `die "fetch failed"` is gone — **every** fetch-failure class (transient, timeout kill, and structural/unclassified) now logs a WARN and `exit 0`s to retry next tick, mirroring the `bounded_clone`-failed branch. The activity cursor is untouched on skip, so nothing is dropped.
- A persistent outage escalates via the throttled `alert_maintainer` under the `triager-fetch-failed-<slug>` dedup key (at most once per window).
- `triager-test.sh` case M was rewritten to match; **`main2` runs 94/0 green**.

**Independent corroboration:** My own investigation found a deeper latent bug that the peer fixed too — the `a17694d0` retry-loop refactor captured `fetch_rc=$?` *after* the `if … fi`, where `$?` is the `if`-statement's status (0 when the condition is false and there's no `else`), so **every failed fetch read as `fetch_rc=0`**, sailed past the failure classification, and triaged a stale clone (then died 75 in `cursor-get`). The tests were red at HEAD (83/7) because of it. The peer's `|| fetch_rc=$?` form fixes exactly this; my parallel version used the `else fetch_rc=$?` form for the same effect.

**Difference vs. my discarded local version:** I additionally gated escalation behind a host-local consecutive-fetch-failure counter (so a single blip doesn't alert at all, only persistent failure does). The job marked that counter "optional," and the peer's throttle-only approach matches the job's primary wording ("escalates … via a throttled `alert_maintainer`"). Given the file was just landed and green, I did **not** force a competing rewrite over it — that would only churn.

**Changes I made:** none persisted. My local commit was reset to `origin/main2`; scratch debug dirs cleaned up.

**Follow-ups:** none required — the job's requirements are met on `main2`. (A possible future refinement, if maintainers want to silence single-blip alerts entirely, is the consecutive-failure counter, but the current throttle already bounds alerts to once per window.)
