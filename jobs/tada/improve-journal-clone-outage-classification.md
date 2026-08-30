Inbox is empty. The job is complete.

## Completion report

**Job:** `improve-journal-clone-outage-classification` — route `reclone_clone` through the bounded, stderr-capturing clone path and classify transient SSH rc=255 diagnostics as EX_TEMPFAIL.

**Root cause.** `reclone_clone` used a naked `git clone … || die`. During the shared-journal outage, a fresh journal clone/claim over SSH that failed transiently (ssh rc 255 + `Could not read from remote repository`) went **fatal** — marking the systemd unit Failed and spawning a self-heal responder every tick across hermits, the sysop, inbox readers, the scaler, and the watchers — instead of cleanly skipping until connectivity recovered.

**Changes (committed `08966639b0` on `origin/main2`):**
- `scripts/jobs/common.sh`
  - `bounded_clone` now captures the final attempt's git stderr into a new module var `GARDEN_CLONE_STDERR` (the clone analog of `journal_fetch`'s `GARDEN_FETCH_STDERR`, via the same `if VAR="$(...)"` set-e-safe idiom) and accepts optional trailing `git clone` flags, defaulting to `--bare` so the existing bare-clone callers (clone-keeper, triager) are unchanged.
  - `reclone_clone` now routes through `bounded_clone` (gaining its timeout+retry discipline and sibling-temp atomic-rename, which it previously lacked) and classifies the captured stderr exactly like `sync_clone`'s fetch path: an offline signature (`_fetch_stderr_is_offline`, which matches the SSH-255 `Could not read from remote repository` / DNS / reset / timeout wording) exits `GARDEN_OFFLINE_RC` (75, EX_TEMPFAIL); only a genuine non-transient failure still dies loud.
- `scripts/jobs/inbox-read.sh` — its retry loop wraps `ensure_clone` in a subshell that *contains* the exit, so it now observes the EX_TEMPFAIL rc and skips the drain cleanly instead of retrying into a hard `die` (the "inbox readers" case the incident named).
- `scripts/jobs/test/fetch-timeout-test.sh` — new SUBTEST 10 guards both directions: a transient SSH-255 clone outage exits 75, a non-transient clone failure still dies 1.

**Verification:** `fetch-timeout-test.sh` 18/18 pass (including the two new assertions); `panel-run-record-test.sh` 27/27 pass (its clone-failure best-effort path still WARNs and exits 0). shellcheck on the touched files surfaced only pre-existing findings outside my edited regions.

**Note:** I initially edited the files under the deployed garden root by mistake; I recovered by restoring the deployed root to its committed content (no git run in the root) and reapplying the edits in this job worktree. Deployed root and journal are clean.

**Follow-ups:** none. The EX_TEMPFAIL now propagates cleanly through the bare `ensure_clone` callers (claims, sysop, scaler, watchers, foreman, reaper) and, via the companion fix, the subshell-wrapping inbox reader.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-clone-outage-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4692738 cached reads)
- Output: 46810 tokens
- Cost: $4.850526
- Wall-clock: 688s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
