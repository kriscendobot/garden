---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: "§Phase-rhythm: §five-phases-mostly-S"
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

| Phase | Scope | Size |
|-------|-------|------|
| 1 — Create `@endo/hex` | Add packages/hex/ as cloned base64. No consumers yet. | S (< 500 LOC) |
| 2 — Migrate daemon | Replace daemon/src/hex.js with re-export from @endo/hex; transitional alias. | S (1 day) |
| 3 — Migrate relay-server | Delete relay-server/src/protocol.js's toHex/fromHex. | S (< 1 hour) |
| 4 — Migrate OCapN | Migrate client/util.js + buffer-utils.js + test files. | S (half day) |
| 5 — Document and release | CHANGELOG, designs/README, npm publish. | S |

§All-five-phases-are-S. §Compare-to-cycle-174-gateway-package
which had four §strategic-phases + 11+ §tactical-PRs. §Hex-
package-is-a-§one-tier-flat-rhythm — leaf package with simple
migration steps.

§Phase-2-uses-the-§transitional-alias-pattern:

```js
// packages/daemon/src/hex.js (transitional)
export { encodeHex as toHex, decodeHex as fromHex } from '@endo/hex';
```

§The-name-mismatch (`toHex` vs `encodeHex`) is handled by re-
export alias. §All-daemon-call-sites continue to import from
`./hex.js`. §No-call-site-rewriting-in-Phase-2. §A-follow-up-
commit-deletes-the-transitional-file. §This-is-§two-step-
migration-with-zero-flaky-window.
