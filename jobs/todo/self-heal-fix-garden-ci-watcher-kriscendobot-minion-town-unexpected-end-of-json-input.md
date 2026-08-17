---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh

Add `unexpected end of JSON input` to the curated `GARDEN_TRANSIENT_GH_API_SIGNATURES` set (`scripts/jobs/common.sh:3163`), alongside the existing `\bEOF\b` and `invalid character .<. looking for beginning of value` truncated/wrong-body signatures.

Failure signature (garden-ci-watcher@kriscendobot-minion.town, exit 1):

```
[ci-pr-source] WARN: gh api repos/kriscendobot/minion.town/pulls?state=open&per_page=100 failed (definitive, rc=1); not retrying: unexpected end of JSON input
[ci-watcher/kriscendobot-minion.town] FATAL: ci PR source failed for kriscendobot/minion.town (rc=1; see source stderr above)
```

Why: that message is Go's `encoding/json` error for a response body that ended mid-document or came back empty — a truncated/dropped GitHub response, the same self-resolving class as the `EOF` and HTML-gateway-page signatures already in the set, and more likely under `--paginate` where any single page can truncate. It is not structural: a successful open-PR list returns at least `[]`, and a real 404 / auth failure carries its own distinct signature. Because the string is missing from the set, `_gh_api_stderr_is_transient` returns 1 and the failure bypasses all three graceful paths built for exactly this case — `gh_api_retry`'s bounded full-jitter retry, and the ci-watcher's WARN+skip degrades at `ci-watcher.sh:299` and `:308` (the latter's comment explicitly names "a Go-decoder … signature" and the restart storm it exists to prevent). It instead reaches `die` at `ci-watcher.sh:318`, failing the unit and triggering the systemd restart storm the degrade was written to avoid.

Fixing it in the shared signature set (not in the ci-watcher) is deliberate: the same one-line change repairs every consumer of the shared classifier — `handlers/ci-pr-source-gh.sh` via `gh_api_retry`, plus dependabot-watcher, approval-reconciler, dependabotany-preflight, and mirror-closer — and keeps the classification in the single place `is_transient_gh_source_error`'s header says it belongs. "Never guess a state" is preserved: a genuinely structural failure still matches none of the signatures and still dies loud, and the watcher still never proceeds on a partial list (a transient classification skips the tick rather than treating the empty result as "no open PRs").

Verification: extend `scripts/jobs/test/gh-api-retry-test.sh` SUBTEST 1 with `assert_transient "unexpected end of JSON input" "truncated/empty response body"`, confirm it fails before the change and passes after, and confirm the existing `assert_definitive` cases (real 404 / malformed slug) still classify definitive so the set has not been widened beyond this class. Run the ci-watcher test (`scripts/jobs/test/ci-watcher-test.sh`) to confirm the source-failure paths still die loud on structural errors.
