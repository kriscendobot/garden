---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-11T20:36:18Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1437

project: endo-but-for-bots

**Verdict:** MERGE-NOW (executed — merged 2026-10-11).
**Upgrade:** all-minor-patch group, 15 direct minor/patch bumps (@types/node, @typescript-eslint/* + typescript-eslint 8.71.0, globals, turbo, type-coverage, rollup, @types/ws, @anthropic-ai/sdk 0.131.0, ollama 0.6.4, openai 7.28.0).

- **Transitive set:** 55 resolutions moved (headlines + rollup/turbo platform binaries + typescript-eslint internals + type-coverage-core); one new lock entry `@types/ws@8.18.2` (types-only dup alongside 8.18.1 for `^8`); no new package names, no license changes, no install scripts.
- **Maturity:** floor from freshest moved version `openai@7.28.0` (published 2026-10-04T18:31:37Z) + 7d = 2026-10-11T18:31:37Z; merged ~2h past. Publishers unchanged both sides (GitHub Actions OIDC + attestations; unchanged human maintainers for ollama/globals/type-coverage).
- **Advisory:** OSV clean both sides for every headline; GHSA ranges for rollup/turbo/@anthropic-ai/sdk cover neither side.
- **Source read:** benign (openai opt-in agents/filesystem helper on separate subpath; ollama systemone method; type-coverage-core recursion guard). PR body Jev-classified `proceed`.
- **CI:** 27 success / 8 skipped / 0 failed on head 8b99d115; conducted via ci-wait-merge.sh --dependabot-auto-merge → state=MERGED.

Terminal verdict; no recheck one-shot required.
