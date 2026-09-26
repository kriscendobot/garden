Pushed cleanly. Done.

## Completion report

**Job:** Stop `scripts/jobs/triager.sh`'s steady-state clone refresh from treating a fetch failure as fatal (`die`, exit 1), which was crash-looping the `garden-triager@<slug>` unit and triggering self-heal churn on any breakage.

**What I found:** The file had already evolved since the job was written. Two recent commits (`a17694d` "bound steady-state fetch with retries", `2fc8532` "skip transient fetch failures") replaced the original one-liner at line 117 with a bounded `timeout`+retry loop, and already classified *recognized* transient failures (rc 124/137/143 or a matched net error) as skip-and-`exit 0`. The specific observed signature (a reaped/`Terminated` fetch → rc 124/137/143) is thus already handled.

**What remained (and what I changed):** The fall-through for an **unclassified** failure still ended in `die "fetch failed for $slug"` (line 152) — so any breakage the transient matcher didn't recognize still failed the unit. I replaced that `die` with the self-provision path's pattern:
- `log "WARN: ..."`,
- `alert_maintainer "triager-fetch-failed-${slug//[^A-Za-z0-9._-]/_}" "$fmsg"` — throttled per-slug dedup key, so a *persistent* breakage (deleted fork, firewall, malformed remote) still surfaces at most once per window,
- `exit 0` to skip this tick and retry next cadence.

The message includes the last line of the captured `$ERRF` diagnostic when present. Net effect: a single blip no longer fails the unit or triggers self-heal, while a real persistent breakage stays visible.

**Verification:** `bash -n` passes; the only shellcheck note (SC2034 on `GARDEN_TAG`) is pre-existing and consumed via env in `common.sh`'s `alert_maintainer`.

**Committed & pushed** to `main2` (rebase CAS, first attempt).

**Follow-ups:** none.
