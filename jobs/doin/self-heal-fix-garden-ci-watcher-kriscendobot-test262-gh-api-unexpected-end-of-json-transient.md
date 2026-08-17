---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Add the Go JSON-decoder truncated-body wording to the shared gh-api transient signature set so a partial response is retried instead of crashing the caller.

Failure signature (observed 2026-08-17 13:30:32 on `garden-ci-watcher@kriscendobot-test262`, exit 1):
`gh api repos/kriscendobot/test262/pulls?state=open&per_page=100 failed (definitive, rc=1); not retrying: unexpected end of JSON input` → `ci-watcher.sh:318 FATAL: ci PR source failed for kriscendobot/test262`.

Change: in `scripts/jobs/common.sh`, extend `GARDEN_TRANSIENT_GH_API_SIGNATURES` (the `: "${GARDEN_TRANSIENT_GH_API_SIGNATURES:=…}"` default, ~line 3164) with an alternative matching `unexpected end of JSON input` (regex-safe, e.g. `unexpected end of JSON( input)?`). Confirm it is genuinely unmatched today: `_gh_api_stderr_is_transient 'unexpected end of JSON input'` returns 1, because `\bEOF\b` and `invalid character '<' looking for beginning of value` both miss this wording.

Rationale to record in the block comment above the variable, in the same voice as the existing HTML-decoder / HTTP-401 / http2-stream-reset paragraphs: Go's `encoding/json` emits `unexpected end of JSON input` when the response body is empty or cut short mid-document — the stream ended before a complete response existed, so no state was observed and a retry is no more hazardous than the 5xx already retried here. It preserves "never guess a state": a body that stays truncated past `GARDEN_GH_API_ATTEMPTS` still fails loud (nonzero, empty stdout). This is the gh-api set ONLY (a Go-decoder string, never git's curl/SSH transport, so `GARDEN_OFFLINE_SIGNATURES` stays untouched).

Blast radius is intentionally both call sites that read this one set: `gh_api_retry` gains the bounded retry, and `ci-watcher.sh`'s `is_transient_gh_source_error` gate (line 308) then degrades to WARN + `exit 0` (skip the tick) instead of reaching `die` at line 318 — which is the correct degrade, identical to the existing 5xx/HTML-page path. `gh_pr_view_retry` inherits it for free. Do not touch `repo_is_definitively_gone`; a real missing repo returns `HTTP 404` and must keep dying loud.

Add a regression test alongside the existing signature cases in `scripts/jobs/test/run-test.sh` (see the `HTTP 401: Bad credentials` case near line 3340 for the established shape): drive a `GARDEN_GH` stub whose stderr is `unexpected end of JSON input`, and assert the watcher logs the transient-blip WARN and exits 0 rather than emitting `FATAL: ci PR source failed`.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T13:53:15Z
