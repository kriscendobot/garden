---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-11-05T02:06:41Z
job: endojs-endo-but-for-bots-pr1648-gauntlet-panel-2
claim: e974c0ea55a16839
---
Verdict: request-changes

Originating dispatch: assessor review of endojs/endo-but-for-bots PR #1648, against `0b8d24a114e1f7f20b766eeee9f056b0dcc4b6bc...HEAD`.

Findings:
- must-fix: `packages/hosted-agent/src/agent-factory.js:1388` and `:1398` accept a provider-use capability but `assertUseMatchesOwner` checks only its `ownerId`; `createAgent` and `reattachAgent` then obtain a fresh root-authority use for `request.providerId`. A caller holding a use for provider A can therefore name provider B owned by the same principal and create or reattach through B. Bind `describe().providerId` to the requested provider ID (or use the supplied capability for the grant) before performing either operation. [proposed-rule: A provider-use capability accepted by a direct creation or reattachment API must authorize the exact provider ID the operation uses, not merely the same owner.]

Self-improvement: nothing this time.
