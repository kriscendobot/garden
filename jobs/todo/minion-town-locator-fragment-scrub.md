---
role: web-builder
tier: mentor
fallback-tier: minion
handler-timeout: 10800
dispatch: automatic
---

# minion.town: capture locator fragments early, scrub them from the URL and history, and keep them encrypted at rest

Repo: kriscendobot/minion.town (front end / guest shell). Open a DRAFT PR against a frozen `main-<sha7>` base; the gauntlet follows automatically.

## Why

minion.town shares capability locators whose formula identifier rides in the URL fragment (`#v=1&...formula=...`, the locator family from endojs/endo-but-for-bots#1360; invitation envelope `#v=1&invitation=...`). The fragment keeps the value off the wire, but not out of the page, the address bar, history (including synced history), copied URLs, screenshots, or telemetry. Read the garden library's digest of Jasvir Nagra's *Secret Seal* before starting:

- `journal/library/sources/web--secret-seal.md`
- `journal/library/sections/web--secret-seal--url-fragments-and-split-knowledge.md` (the key section)
- `journal/library/sections/web--secret-seal--framework-controls-and-leak-canaries.md`

## Task (maintainer request, liaison session 2026-10-08)

1. **Capture as early as possible.** Read `location.hash` in a small inline script that runs first, before any app bundle, analytics, or error telemetry loads. Parse it with the strict locator/invitation parser (do not hand-roll a second parser), store the formula identifier in client storage, and remove the fragment.
2. **Leave no history record.** Use `history.replaceState` so the fragment never reaches the address bar or history. **Caveat from the source:** `replaceState` in the same document does *not* rewrite the Navigation Timing entry, so later same-origin code can still recover it from `performance.getEntriesByType("navigation")`. Prefer the source's recommended shape: a minimal isolated bootstrap document that captures, stores, and then navigates (`location.replace`) to a fresh document whose initial URL never held the fragment. If you choose same-document replace, justify that in the PR body.
3. **Encrypt formula identifiers at rest (evaluate, then implement if it holds up).** Suggested shape: a non-extractable WebCrypto AES-GCM key kept in IndexedDB (localStorage cannot hold a `CryptoKey`), with ciphertext and a fresh IV per record. Be honest in the PR body about the threat model: this guards against disk, backup, and profile-sync scraping and against code that only reads storage, but **not** against same-origin script, which can call decrypt itself. If the cost or complexity is not worth it, write up the decision instead of shipping it.
4. **Leak-canary tests.** Add a Playwright test that loads a URL with a canary formula id in the fragment and asserts the canary is absent from `location.href`, `history`, the navigation timing entry of the landed document, outgoing request URLs and `Referer` headers, and plaintext storage (when encryption ships).
5. Keep accepting existing links (both `endo://` and https `#v=1` forms). Do not change emission (https share-link emission is still gated on design acceptance of ebfb#1360).

## Done

A draft PR with the bootstrap capture and scrub, the storage (encrypted or a written decision), the leak-canary tests, CI green, and a PR body that states the residual exposure (same-origin JS, extensions, capture before the scrub runs).
