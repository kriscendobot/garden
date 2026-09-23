---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-01T17:55:15Z
---
Implemented and deployed the MCP public-surface rename in
kriscendobot/minion.town#75 (merge `7f0b8f9`). Canonical names now mirror the
Endo guest/facet methods, with the flat `list` collision resolved as `list` for
the directory and `listSites` for publications. Removed all legacy aliases,
documented the complete migration and unchanged OAuth/authority posture, updated
server registrations, clients, deployment checks, designs, and fixtures, and
added a combined tools/list uniqueness and prefix-free contract. `evaluate`
now documents and defaults a source-only call so `evaluate 2 + 2` needs only
`source: "2 + 2"`.

Verification: `npm test` passed 290 tests with 5 real-daemon tests skipped by
their existing `ENDO_CHECKOUT` gate; `npm run typecheck` and `npm run build`
passed; GitHub test run 33539871099 passed; continuous deployment run
33539977066 passed all deployment steps.

The required blind live discovery evaluation was not runnable from this worker:
the container has neither AWS credentials for `minion/test-cc-client` nor an
authenticated minion.town MCP connection. Posted successor
`minion-town-blind-discovery-eval` with `requires: aws`, the exact context-free
directive, evidence requirements, secret-handling constraint, and explicit
documentation-follow-up requirement.

Self-improvement: nothing this time.
