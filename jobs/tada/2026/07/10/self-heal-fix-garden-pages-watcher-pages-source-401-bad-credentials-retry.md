Pushed to main2. Done.

## Completion report

**Job:** Fix `scripts/jobs/pages-watcher.sh` so a transient GitHub `HTTP 401: Bad credentials` (returned briefly during OAuth/installation-token rotation) no longer detonates a `FATAL` + spurious systemd restart + self-heal.

**What changed (commit `a82951334` on `main2`):**

- **`scripts/jobs/common.sh`** — added `is_transient_auth_error`, the auth-side sibling of `is_transient_net_error`. Same argument contract (slurps a file or matches a string), matches `HTTP 401|Bad credentials` case-insensitively.
- **`scripts/jobs/pages-watcher.sh`** — factored the `timeout`-wrapped, reaped source invocation into a `run_source` helper, then reworked the source-failure branch: after the existing transient-net-error skip, if the stderr matches a 401 signature (and is not a net error), it retries the source **once** via the identical reaped path after a bounded backoff (`GARDEN_PAGES_AUTH_RETRY_SLEEP`, default 5s; tests set 0). A recovered 401 falls through and processes the runs normally; a **persistent** 401 on the retry `WARN`s loudly and skips the tick (`exit 0`) — surfaced every tick, never swallowed into "all green", and no restart storm. Non-401 structural failures still `die` loud as before.
- **`scripts/jobs/test/pages-watcher-test.sh`** — added case **H**: a stub source emitting `HTTP 401: Bad credentials` once then a valid TSV, asserting the tick exits 0, posts the shepherd job, and invokes the source exactly twice.

**Verification:** full test suite passes 12/12 (including H). `bash -n` clean on both scripts; shellcheck shows only the pre-existing SC2034 for `GARDEN_TAG` (read by `common.sh`'s `log`).

**Follow-ups:** none. The chosen persistent-401 behavior is WARN+skip (per the job's stated option), which avoids restart storms while keeping the failure loud each tick.
