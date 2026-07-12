scripts/jobs/pages-watcher.sh
The watcher's source-failure classifier (`run_source` block, ~lines 168–200) has only two transient buckets — `is_transient_net_error` and `is_transient_auth_error` — before it falls through to `die`. When GitHub is overloaded it serves an HTML gateway/5xx/rate-limit page and the default source `handlers/pages-runs-gh.sh` (`gh run list … | jq`) fails rc=1 with a Go-decoder/jq signature (`invalid character '<' looking for beginning of value`, `HTTP 5NN`, `HTTP 429`, `rate limit`, `EOF`, `server misbehaving`) that matches NEITHER existing bucket. So the tick hits `die`, `garden-pages-watcher.service` fails with `exit-code`, and the self-heal restarts it — observed 2026-07-12 16:03:24Z (the FATAL in this tick's journalctl tail). This is exactly the transient class commit 9cf685607d added to `GARDEN_TRANSIENT_GH_API_SIGNATURES` for `gh_api_retry`/`mirror-closer`, but the pages-watcher never consults that set.

Fix: add a third transient bucket that calls `_gh_api_stderr_is_transient "$ERRF"` (which matches `GARDEN_TRANSIENT_GH_API_SIGNATURES`, including the new HTML-instead-of-JSON signature) and, on a match, `log "WARN: pages run source hit a transient gh-api blip (5xx/HTML/rate-limit) — skipping tick"` + `exit 0` rather than `die` — on both the first attempt and the post-401 retry. Order it after the net/auth checks and before the final `die`, so a genuinely structural failure (a real 404/malformed slug) still dies loud and preserves "never guess a state." Preferably factor a single `classify_source_failure` helper so the two `die` sites (first pass and retry pass) stay in sync.

Note the sibling watchers `scripts/jobs/ci-watcher.sh` (line 262) and `scripts/jobs/comment-watcher.sh` (line 1151) carry the identical gap — they too `die` on a `gh`-served HTML/5xx page that `is_transient_net_error` doesn't catch — so the same third bucket should be applied there in the same change (or a shared helper in `common.sh`, e.g. `is_transient_gh_source_error`, that all three watchers call). Add a hermetic test mirroring `mirror-closer-test.sh` section K: a `GARDEN_PAGES_SOURCE` stub emitting the HTML-decoder stderr with rc=1 asserts a clean `exit 0` skip (no `die`, no unit failure), while a structural (404) stderr still asserts the loud die.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  claimed_at: 2026-07-12T16:21:52Z
