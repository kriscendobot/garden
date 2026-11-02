---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-02T09:44:41Z
---
# Dependabotany: kriscendobot/minion.town PR #232 — MERGE-NOW (merged)

project: minion-town

- PR: https://github.com/kriscendobot/minion.town/pull/232
- Bump: @anthropic-ai/claude-code 2.1.303 -> 2.1.310 (tools/claude-harness), plus its 8 platform optional deps
- Verdict: MERGE-NOW. Terminal: merged 2026-11-02T09:44:19Z as c5c350442cc8.
- Maturity floor: 2026-10-30T21:26:17Z (freshest moved version: @anthropic-ai/claude-code-win32-x64@2.1.310, published 2026-10-23T21:26:17Z). Already passed.
- Advisories: none on either side (GHSA affects-query and OSV empty).
- Source: wrapper install.cjs/cli-wrapper.cjs/sdk-tools.d.ts/README byte-identical; only version pins moved. Publisher GitHub Actions both sides.
- Migration: claude-harness-refresh hook rc 0, committed e53d25b2 (manifest/sig/release.json); merged at head e53d25b2; CI 4/4 green.
- Verdict comment: https://github.com/kriscendobot/minion.town/pull/232#issuecomment-6573966220

dependabotany-terminal-pr: 232
