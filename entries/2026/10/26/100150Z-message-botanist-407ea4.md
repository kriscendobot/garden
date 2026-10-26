---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-26T10:01:52Z
---
# Dependabotany: kriscendobot/minion.town PR #226 — MERGE-NOW (merged)

project: minion-town

- PR: https://github.com/kriscendobot/minion.town/pull/226
- Bump: @anthropic-ai/claude-code 2.1.296 -> 2.1.303 (tools/claude-harness), plus its 8 platform optional deps
- Verdict: MERGE-NOW. Terminal: merged 2026-10-26T10:01:18Z as 443519ebee45.
- Maturity floor: 2026-10-25T21:19:28Z (freshest moved version: @anthropic-ai/claude-code-linux-arm64@2.1.303, published 2026-10-18T21:19:28Z). Already passed.
- Advisories: none on either side (GHSA affects-query and OSV empty).
- Source: wrapper install.cjs/cli-wrapper.cjs/bin unchanged; only additive sdk-tools.d.ts types. Publisher GitHub Actions both sides.
- Migration: the claude-harness-refresh hook returned rc 0 and committed f7dcca84 (manifest/sig/release.json); merged at head f7dcca84; CI 4/4 green (run 40301231544).
- Verdict comment: https://github.com/kriscendobot/minion.town/pull/226#issuecomment-6413231968

dependabotany-terminal-pr: 226
