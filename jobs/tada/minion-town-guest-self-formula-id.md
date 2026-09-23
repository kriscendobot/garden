---
handed-off: minion-town-guest-self-formula-id-land-verify
deliverable-complete: false
---
Implemented and pushed guest self-formula-ID reveal in draft PR https://github.com/kriscendobot/minion.town/pull/61 (`200dccac306`).

Changed:

- Added strictly self-scoped OAuth-gated `GET /account/guest-formula-id`.
- Returns only the caller-derived guest-agent formula identifier as plain text.
- Added read-only home-page field and copy button.
- Added self-scope, gate, daemon-adapter, and integration coverage.

Verified:

- Typecheck and full suite: 278 passed, five existing daemon tests skipped.
- Pre-push gates and local verification passed.
- Regression mutation correctly failed the self-scope assertion.
- Headless Chromium verified rendered read-only field and copy behavior.

Live merge, deployment, and peer `enlivenSturdyRef` verification remain owned by posted successor `minion-town-guest-self-formula-id-land-verify`. Status was relayed for the parallel remote-interaction work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-guest-self-formula-id.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2358s

<!-- garden-usage-end -->
