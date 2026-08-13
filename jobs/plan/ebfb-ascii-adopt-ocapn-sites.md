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

<!-- garden-annotation: key=ascii-site-ocapn-hub by=designer at=2026-08-13T18:52:14Z -->

Additional genuine site: packages/ocapn/src/hub/hub.js swissnumHex currently feeds string-form swissnums through TextEncoder without the ASCII contract. Replace that branch with encodeAscii (or the canonical validated swissnum helper if its branded result is accepted) and add a non-ASCII rejection test while preserving raw Uint8Array and ArrayBufferLike branches.

<!-- garden-annotation: key=ascii-site-ocapn-session-prefix by=designer at=2026-08-13T18:52:53Z -->

Also replace packages/ocapn/src/cryptography.js sessionIdHashPrefixBytes TextEncoder encoding of the ASCII protocol prefix prot0 with encodeAscii. This removes the file module-load dependency on the TextEncoder host global; the same file already needs encodeAscii for LOCATION_SIG_DOMAIN.
