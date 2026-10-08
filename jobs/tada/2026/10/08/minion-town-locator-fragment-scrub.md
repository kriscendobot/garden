Opened draft PR https://github.com/kriscendobot/minion.town/pull/170 against frozen base `main-76bb276`.

Implemented isolated early fragment capture, strict shared parsing, immediate URL scrubbing, clean-document navigation, and AES-GCM encrypted IndexedDB storage with non-extractable keys and fresh IVs. Existing HTTPS and `endo://` link behavior remains supported.

Added Chromium leak-canary coverage for URL/history, Navigation Timing, request URLs, Referer headers, and plaintext storage. CI is green across tests and both harness architectures. The PR documents residual same-origin script, extension, and pre-scrub capture exposure.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-locator-fragment-scrub.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1172s

<!-- garden-usage-end -->
