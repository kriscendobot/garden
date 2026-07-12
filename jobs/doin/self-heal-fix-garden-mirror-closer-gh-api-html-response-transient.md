In `scripts/jobs/common.sh`, the `GARDEN_TRANSIENT_GH_API_SIGNATURES` set does not cover the case where GitHub returns an HTML error page (a 5xx gateway / overload / maintenance / rate-limit page) instead of JSON. `gh`'s JSON decoder then emits `invalid character '<' looking for beginning of value`, which `_gh_api_stderr_is_transient` classifies as DEFINITIVE, so `gh_api_retry` does not retry, the `mirror-pr-state-gh.sh` handler dies (`no usable PR state for the closer`), and `mirror-closer.sh` exits 1 — re-triggering `garden-mirror-closer` self-heal every tick. Observed 2026-07-12 06:28:21 on `Agoric/agoric-sdk#11031`.

Fix: add a signature for the HTML-instead-of-JSON response to `GARDEN_TRANSIENT_GH_API_SIGNATURES` (added to the gh-api set ONLY, never to `GARDEN_OFFLINE_SIGNATURES`, per the existing comment) — e.g. append `|invalid character '<' looking for beginning of value` (or the tighter `|invalid character .<. looking for beginning of value` to be regex-safe around the quotes). An HTML body from GitHub is a server-side transient page, so absorbing it under the bounded full-jitter retry preserves "never guess a state": if GitHub keeps returning HTML past `GARDEN_GH_API_ATTEMPTS`, the call still fails loud (nonzero, empty) rather than guessing. Extend `mirror-closer-test.sh` (which already has a hermetic large-PR 422 case via `GARDEN_GH`) with a stub that emits this stderr, asserting it is retried then absorbed rather than dying on the first attempt. While there, note the cosmetic double-`gh api` in the WARN label (`gh api gh api failed`) but that is not the cause and need not block the fix.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  claimed_at: 2026-07-12T06:29:33Z
