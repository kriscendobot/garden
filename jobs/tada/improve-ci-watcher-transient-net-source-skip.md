Pushed cleanly on the first attempt.

## Completion report

**What the job asked for:** Stop a GitHub-outage-induced `~40-FATAL/100-min` systemd restart storm in the CI and comment watchers by degrading a *transient* connectivity failure to a skipped tick, while still `die`ing loud on a *structural* failure — preserving the "never mistake a broken enumeration for no open PRs" guarantee.

**What I did:**

1. **`scripts/jobs/common.sh`** — Added a shared `is_transient_net_error <stderr-file-or-string>` classifier right after `die`. It accepts either a stderr capture file (slurped) or a literal string (matched directly), and case-insensitively matches the requested signature set: `connection timed out`, `error connecting to api.github.com`, `check your internet connection`, `read tcp .* i/o timeout`, `TLS handshake timeout`, `could not resolve host`.

2. **`scripts/jobs/ci-watcher.sh:187-190`** — Before the `die`, classify `$ERRF`: on a transient match, `log "WARN: ci PR source unreachable (transient network) — skipping tick (never guess)"; exit 0`, mirroring the per-PR "never guess a state" degrade at line ~241. Structural failures still `die`.

3. **`scripts/jobs/comment-watcher.sh`** — Applied the same classifier to its source-failure branch (the one that also died on the 10:24:57 outage), with a parallel WARN-and-`exit 0`.

**Verification:**
- `bash -n` syntax-clean on all three files.
- 12/12 unit-test cases pass: all 6 transient signatures classify as transient, and structural cases (404, 401, auth-required, JSON parse error, empty string) correctly do not — plus the file-argument mode.

**Changed:** 3 files, committed as `3cc012181` and pushed to `main2` (fast-forward, first-try CAS).

**Follow-ups:** None required. The deployed root checkout picks this up on the next deliberate deploy (`deploy-garden.sh`); no live restart is needed to land it. If future outages surface a signature not in the curated set (e.g. `502 Bad Gateway`, `503 Service Unavailable`, or `secondary rate limit`), the single `grep -qiE` alternation in `common.sh` is the one place to extend — I deliberately kept it to exactly the requested signatures to avoid swallowing genuine structural failures.
