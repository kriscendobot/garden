---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-13T21:43:06Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1269

project: endo-but-for-bots

**Verdict:** MERGE-NOW (executed — MERGED 2026-09-13T21:41:16Z, merge commit `3fb02fdeb02cca769c5215782cb0195244e90518`).

**Upgrade:** `marked` 17.0.6 → 18.0.11 (major, npm) in `@endo/chat` and `@endo/spaces-util` (`^17.0.5` → `^18.0.11`).

- Base/sibling census: base `llm` resolved 17.0.6 for both consumers (genuine forward bump, not a no-op/revert); no sibling PR moves `marked`; head rebased onto live `llm` (6bfd45e → d5607679) before merge.
- Transitive set: `marked` is zero-dependency, so the only moved version is `marked` itself; no license change.
- Advisories: OSV = 0 vulns for both 17.0.6 and 18.0.11 (historical marked GHSAs bind to 0.x–4.x). Not CVE-repairing; cleared on maturity.
- Maturity floor: `marked@18.0.11` published 2026-08-24T16:55:21Z (freshest/only moved version); floor 2026-08-31 satisfied (~20d aged). Publisher = npm trusted-publishing OIDC (GitHub Actions) with SLSA attestations — a strengthening.
- Source: v18 breaking changes = trim trailing blank lines from block tokens + TS v6 build; public API unchanged. Consumed surface (`marked`, `Renderer`, `marked.parse`) stable v17→v18. No migration push needed.
- Install scripts-disabled (rc=0). CI: 34/34 green on head `d5607679`.

Terminal MERGE-NOW: no embargo, no recheck wiring required.
