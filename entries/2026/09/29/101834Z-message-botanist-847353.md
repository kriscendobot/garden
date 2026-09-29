---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-29T10:18:36Z
---
# Dependabotany — endojs/endo-but-for-bots PR 1353

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1353

- Package: `vitest` 4.1.11 → 5.0.1 (devDependency in `packages/preact-container`, `packages/preact-social`)
- Verdict: **REJECT (incompatible)** — EXECUTED close 2026-09-29 (state=CLOSED)
- Head reviewed: `c3fae9034d990a38b56b69564702a55b3af63eaa` (re-fetched live)
- Primary reason: project supports Node `^20.17.0 || >=22.9.0`; every `vitest` 5.x (5.0.0, 5.0.1, current `latest` 5.0.2) requires Node `^22.12.0 || ^24.0.0 || >=26.0.0`, excluding all of Node 20 and the supported 22.9.0–22.11.x sub-range. No newer 5.x restores Node 20.
- Compounding reason: PR bumps only `vitest`→^5.0.1 while leaving `@vitest/browser`/`@vitest/browser-playwright` at ^4.1.11; `@vitest/browser-playwright@4.1.11` pins peer `vitest: "4.1.11"` exactly. Mirror of #1270 (`@vitest/browser`→5.0.0, REJECTed 2026-09-13). A vitest-5 migration requires the whole `@vitest/*` family aligned on one major — a maintainer support-range decision.
- Review scope: declaration-only preflight (recheck job `dependabotany-recheck-endo-but-for-bots-20260928-012250`); live head matched the terminal Node-engine + peer incompatibility. Full lockfile/source/advisory/install/test chain intentionally not run.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1353#issuecomment-5888218291
- Terminal: no embargo row or recheck schedule needed.
