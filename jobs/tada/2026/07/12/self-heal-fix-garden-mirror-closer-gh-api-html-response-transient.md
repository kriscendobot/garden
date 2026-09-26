Pushed cleanly on the first attempt.

## Completion report

**Job:** `self-heal-fix-garden-mirror-closer-gh-api-html-response-transient`

**Root cause:** When GitHub is overloaded it serves an HTML error page instead of JSON. `gh`'s decoder then emits `invalid character '<' looking for beginning of value` — a string with no HTTP-status word that matched no entry in `GARDEN_TRANSIENT_GH_API_SIGNATURES`. So `_gh_api_stderr_is_transient` classified it DEFINITIVE, `gh_api_retry` refused to retry, `mirror-pr-state-gh.sh` died (`no usable PR state for the closer`), and `mirror-closer.sh` exited 1 every tick — re-triggering `garden-mirror-closer` self-heal. Observed 2026-07-12 06:28:21 on `Agoric/agoric-sdk#11031`.

**What changed** (`scripts/jobs/common.sh`):
- Added the regex-safe signature `invalid character .<. looking for beginning of value` to `GARDEN_TRANSIENT_GH_API_SIGNATURES` — the **gh-api set only**, never `GARDEN_OFFLINE_SIGNATURES` (per the existing comment, that set classifies git's transport and must not absorb a Go-decoder string).
- Documented the rationale in the block comment: an HTML body is a server-side transient page, so absorbing it under the bounded full-jitter retry preserves "never guess a state" — persistent HTML past `GARDEN_GH_API_ATTEMPTS` still fails loud (nonzero, empty).
- Cosmetic: fixed the double-`gh api` WARN label (`gh api gh api failed`) by defaulting the label to the first positional (e.g. `graphql`), since every log line already prefixes `gh api $label`.

**Test** (`scripts/jobs/test/mirror-closer-test.sh`, new section K): a hermetic `GARDEN_GH` stub that emits the HTML-decode stderr. Two cases — (1) two transient HTML pages then success, asserting the retry fires (gh called 3×) and the real state is read; (2) HTML on every attempt, asserting the loud die (nonzero, empty) once the attempt budget is spent. Full suite: **33 passed, 0 failed** (`--no-e2e`; PART 2 needs real bot `gh`). Both files pass `bash -n`.

**Committed & pushed** to `main2` as `9cf685607d` (CAS push succeeded on attempt 1).

**Follow-ups:** none. The self-heal loop on `Agoric/agoric-sdk#11031` should clear on the next `garden-mirror-closer` tick after this deploys.
