---
ts: 2026-06-02T05:58:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: d1d611
prs:
  - repo: endojs/endo-but-for-bots
    pr: 397
    role: new
refs:
  - entries/2026/06/02/053826Z-dispatch-builder-d1d611.md
  - https://github.com/endojs/endo-but-for-bots/pull/397
---

# result: builder — gateway phase 9 PR #397 (Familiar-bundled fallback)

- PR #397 DRAFT, base design/gateway-package-phase-8, head
  design/gateway-package-phase-9.
- Feature 5: Familiar-bundled fallback (ENDO_HTTP_ADDR=:0 +
  port-publish to a file the Familiar renderer reads).
- 392 tests pass (349 → 392, 43 new). Lint/types clean.
- 10 files, +1058 lines.

Patterns repeated cleanly:
- Toggle (default off) + power + fail-closed construction check.
- Portable core + Node adapter split (mirrors Phase 2's
  node-crypto-powers.js).
- start/stop hooks tied to bind/teardown.

Builder notes the Phase 1-8 patterns carried over with no skill
gap surfaced. URL format matches the daemon's existing
`${statePath}/gateway` payload so Familiar's existing reader can
ingest uniformly.

Liaison disposition: dispatch root torn down. Next: **Phase 10
(Feature 9: HTTPS terminating proxy compatibility)** —
documentation-only + `X-Forwarded-*` parser + startup warning +
trusted-proxy CIDR allowlist. Base
design/gateway-package-phase-9.
