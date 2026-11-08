---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-08T20:25:54Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1655 — HELD (escalated: fixer)

project: endo-but-for-bots

`@earendil-works/pi-ai` 0.87.1 → 1.4.0 (major) in agent-tools, agentry, and lal. The diff shape is clean, and the base `llm` is uniformly at 0.87.1, so the PR is not superseded. Maturity is satisfied: the freshest moved version is `@earendil-works/pi-telemetry@1.4.0`, published 2026-10-21T22:44:04Z, so the floor was 2026-10-28T22:44Z. The other moved versions (new entries): pi-ai 1.4.0, @anthropic-ai/sdk 0.129.0, openai 7.19.0. All are published by OIDC with SLSA provenance. OSV and GHSA are clean on both sides. There are no install scripts, and the source read is benign.

**Blocker:** CI lint:types is red (TS2322 at agentry/src/harness/pi-agent.js:82 and lal tests) because pi-agent-core stays at ^0.87.1, which leaves two pi-ai copies. The remedy is a lockstep bump of the pi-* family (pi-agent-core and pi-coding-agent to ^1.4.0; sibling dependabot PR #1657 carries pi-coding-agent). Escalated to fixer job `fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep`. The verdict comment is https://github.com/endojs/endo-but-for-bots/pull/1655#issuecomment-6726671878. There is no maturity floor to recheck; the daily backstop `dependabotany-recheck-endo-but-for-bots` already exists. The row stays OPEN until a terminal verdict.
