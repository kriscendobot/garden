---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Add the Go `net/http2` stream-reset class to `GARDEN_TRANSIENT_GH_API_SIGNATURES` (line 3059), so a server-side HTTP/2 stream reset is retried instead of crashing the caller.

Failure signature (garden-ci-watcher@kriscendobot-minion.town, exit 1, 08:04:32-33):
  [ci-pr-source] WARN: gh api repos/kriscendobot/minion.town/pulls?state=open&per_page=100 failed (definitive, rc=1); not retrying: stream error: stream ID 1; CANCEL; received from peer
  [ci-watcher/kriscendobot-minion.town] FATAL: ci PR source failed (rc=1)

Verified: sourcing common.sh and passing that exact stderr to `_gh_api_stderr_is_transient`, `is_transient_gh_source_error`, and `is_transient_net_error` returns definitive from all three, so `gh_api_retry` spent 0 of its 4 attempts and `ci-watcher.sh:318` died.

Change: extend the signature alternation with the http2 transport class, e.g. `stream error: stream ID [0-9]+` plus `http2: (server sent GOAWAY|client connection (lost|force closed))` and `INTERNAL_ERROR`. Add to the **gh-api set ONLY** — never `GARDEN_OFFLINE_SIGNATURES` (line 2909), which classifies git's curl/SSH transport and must not absorb Go-only wording, per the standing rule in the block comment at 3040-3058. Extend that same comment with this third occurrence (date, unit, exact stderr) so the next reader sees the pattern.

Both degrade gates are fixed by the one edit: `gh_api_retry` gains its bounded retry, and `is_transient_gh_source_error` (which defers to the same set) lets `ci-watcher.sh:308` WARN-and-skip the tick instead of `die`ing — preserving "never guess a state", since a reset that outlives `GARDEN_GH_API_ATTEMPTS` still fails loud with empty stdout.

Note on scope: `gh_api_retry` also serves non-idempotent calls, but this matches existing policy exactly — the set already retries `HTTP 5[0-9][0-9]` and `EOF` regardless of method, and a peer-sent `CANCEL`/`GOAWAY` means the stream was torn down, so a retry is no more hazardous than the 5xx retry already in place. Do not add a method guard as part of this fix.

Add a case to `scripts/jobs/test/gh-api-retry-test.sh` asserting the exact `stream error: stream ID 1; CANCEL; received from peer` stderr is classified transient and retried (mirroring the existing definitive-404 and transient cases), so this third regression of the same gap is the last one.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-14T08:05:58Z
