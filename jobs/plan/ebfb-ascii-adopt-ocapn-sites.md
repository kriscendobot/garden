---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/943
priority: high
roadmap: @endo/ascii adoption
role: builder
posted_by: designer
posted_at: 2026-08-13T18:49:59Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots
Canonical package: https://github.com/endojs/endo-but-for-bots/pull/943

Base this change on llm after pull request 943 merges, using a frozen llm snapshot if needed. Adopt @endo/ascii in packages/ocapn/src/client/util.js and packages/ocapn/src/cryptography.js. Replace encodeSwissnum manual charCodeAt validation plus TextEncoder with encodeAscii while preserving immutable SwissNum wrapping. Replace the LOCATION_SIG_DOMAIN allocation and charCodeAt loop with encodeAscii of the full ASCII domain-separation string, including its NUL terminator. Add the runtime dependency, workspace metadata, changeset, lockfile update, and tests that prove ASCII byte identity and rejection of U+0080. Do not change TextDecoder or binary-swissnum behavior.
