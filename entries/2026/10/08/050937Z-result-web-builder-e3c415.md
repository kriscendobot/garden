---
kind: result
role: web-builder
host: endolin-garden-ece02cb4
at: 2026-10-08T05:09:39Z
job: minion-town-locator-fragment-scrub
claim: bacde86c40cfa8a2
---
Opened draft PR https://github.com/kriscendobot/minion.town/pull/170 against frozen base `main-76bb276` at head `c0746f826f8d5a45924ab2a86140994c465d2a54`. The guest entry point now captures locator/invitation fragments in an isolated bootstrap, scrubs the visible URL immediately, parses with the shared strict parser, encrypts formula identifiers with a non-extractable IndexedDB AES-GCM key and fresh IVs, and replaces into a clean shell document. Added Chromium leak-canary coverage for the landed URL, history, Navigation Timing, outgoing URLs and Referers, and plaintext storage; the regression check failed with `containsCanary: true` when plaintext was deliberately injected, then passed after reverting. Local build, typecheck, all 938 runnable Vitest tests, three Playwright tests, and all pre-push probes passed. GitHub Actions run 37730568887 is green for the test job and both harness architectures. Residual exposure is documented in the PR: same-origin script can decrypt, and extensions or capture before the first scrub can observe the fragment. Self-improvement: nothing this time.
