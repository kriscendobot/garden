Pushed to main2. Job complete.

## Completion report

**What the job asked:** Add the Go JSON-decoder `unexpected end of JSON input` wording to the shared `GARDEN_TRANSIENT_GH_API_SIGNATURES` set (with rationale comment) so a truncated response body is retried/degraded instead of crashing `garden-ci-watcher`, plus a regression test.

**What I found:** The core change was already landed 20 minutes before I claimed, in commit `cd75de28f9` ("fix(gh-api): classify 'unexpected end of JSON input' as transient"), now in `origin/main2`. That commit already:
- Added `unexpected end of JSON input` to `GARDEN_TRANSIENT_GH_API_SIGNATURES` (`common.sh:3176`).
- Added a rationale paragraph in the same voice as the existing HTML-decoder / HTTP-401 / http2-stream-reset paragraphs (preserving "never guess a state", gh-api set only, `GARDEN_OFFLINE_SIGNATURES` untouched).
- Extended the classifier test in `gh-api-retry-test.sh`.

So the signature, the classifier, and the block comment were done. The one piece the prior commit did **not** cover was the job's specific ask for an **end-to-end ci-watcher regression test** proving the `is_transient_gh_source_error` gate degrades to WARN + `exit 0` rather than reaching the `FATAL: ci PR source failed` die at `ci-watcher.sh:318`.

**What I changed (commit `48e25d3d33`):** Added a `BLIP` test case to `scripts/jobs/test/ci-watcher-test.sh` (the dedicated ci-watcher harness — the natural home given its existing "GONE" source-failure section, rather than `run-test.sh` whose 401 case is actually the issue-inbox-watcher). It drives `ci-watcher.sh` with a `GARDEN_CI_PR_SOURCE` stub emitting the exact observed stderr (`…failed (definitive, rc=1); not retrying: unexpected end of JSON input`) and asserts three things: exits 0 (no crash-loop), logs the transient-blip WARN, and does **not** reach the FATAL die.

**Verification:**
- `ci-watcher-test.sh`: 52 passed, 0 failed (3 new assertions all green).
- `gh-api-retry-test.sh`: 47 passed, 0 failed (prior commit's classifier work intact).
- `bash -n` clean.

**Follow-ups:** None. The deployed root still runs the old code until the next deliberate deploy, but that is the normal deploy cadence, not a defect.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-kriscendobot-test262-gh-api-unexpected-end-of-json-transient.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 58 tokens (1903486 cached reads)
- Output: 15151 tokens
- Cost: $1.960448 (2 engagement(s) unpriced)
- Wall-clock: 301s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
