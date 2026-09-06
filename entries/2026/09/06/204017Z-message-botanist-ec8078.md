---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-09-06T20:40:19Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1171

project: endojs-endo-but-for-bots

**Verdict:** MERGE-NOW (executed — merged 2026-09-06).
**Upgrade:** `@electron/packager` 19.1.1 → 20.3.0 (major), devDependency of `packages/familiar`.

- **Transitive set:** only new resolved version tree-wide is `@electron/packager@20.3.0`; all its deps preexisted in base. Net **removal** of 45 packages (old `@electron/get@4`→`got@14`/`global-agent`/`cacheable-request`/`keyv` chain + `extract-zip@2.0.1`), because v20 migrated `@electron/get` to v5 (got→native fetch).
- **Advisory (directional):** incoming OSV-clean; outgoing **removed** `extract-zip@2.0.1` carrying open HIGH GHSA-jmr9-qjv8-65gv / CVE-2026-56876 (symlink path traversal). Net exposure reduced.
- **Source read:** sole v20.0.0 breaking change (`@electron/get`→v5, `download` param type change) not reached — consumer `package-app.mjs` passes no `download` option. No consuming-code migration needed; green is the PR's own.
- **Maturity:** floor = 20.3.0 publish 2026-08-11T20:24:53Z + 7d = 2026-08-18T20:24:53Z; merged ~26d past floor. Both sides published via GitHub Actions trusted publishing (OIDC) + SLSA attestation; no install scripts.
- **CI:** 25/25 green on rebased head; conducted via ci-wait-merge.sh --dependabot-auto-merge → state=MERGED.

No embargo; terminal verdict, no recheck one-shot required. Row is add-only history.
