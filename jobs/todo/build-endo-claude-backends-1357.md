---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-01T05:25:15Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build phase 2 of endo-claude-inference-backends: Claude core and two backends

Repo: `endojs/endo-but-for-bots`, base `llm` (stack on the phase-1 PR from
`build-endo-inference-seam-1357` if it has not merged; see
`skills/stacked-pr-build/SKILL.md`). Design: `designs/endo-claude-inference-backends.md`
(merged via https://github.com/endojs/endo-but-for-bots/pull/1357), § Phased
Implementation item 2.

`@endo/claude`, over `@endo/inference`: the options/argv builder, the
constructed-env builder, the stream reducer, the Claude Code response-shape
table; `makeClaudeCliBackend` (stdio projection through endo-guest-stdio-mcp)
and `makeClaudeSdkBackend` (in-process projection), each made over one
credential source. Port from minion.town #105/#106 rather than #1015 where they
differ. Phases 3+ (secret-store credentials, root canary, evidence, broker) are
OUT of scope: they need live credentials and maintainer-gated deployment.

Open a DRAFT PR (via ensure-pr.sh) with unit tests that need no live credential.
Arc: https://github.com/kriscendobot/garden/issues/89 item 4.
