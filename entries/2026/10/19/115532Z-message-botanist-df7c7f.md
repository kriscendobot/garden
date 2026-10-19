---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-19T11:55:34Z
---
# Dependabotany: kriscendobot/minion.town PR #208 — MERGE-NOW (merged)

project: minion-town

- PR: https://github.com/kriscendobot/minion.town/pull/208
- Bump: @anthropic-ai/claude-code 2.1.290 -> 2.1.296 (tools/claude-harness), plus its 8 platform optional deps
- Verdict: MERGE-NOW. Terminal: merged 2026-10-19T11:54:36Z as 001bcf52bcaf.
- Maturity floor: 2026-10-16T17:00:13Z (freshest moved version: @anthropic-ai/claude-code-linux-arm64-musl@2.1.296, published 2026-10-09T17:00:13Z). Already passed.
- Advisories: none on either side (GHSA, 29 total, newest covers < 2.1.179; OSV empty).
- Migration: the claude-harness-refresh hook returned rc 0 and committed the regenerated manifest/sig/release.json. Rebased onto main e305ed21 and merged at head 66198d7b; CI 3/3 green (run 39240704113).
- Verdict comment: https://github.com/kriscendobot/minion.town/pull/208#issuecomment-6266613251

dependabotany-terminal-pr: 208
