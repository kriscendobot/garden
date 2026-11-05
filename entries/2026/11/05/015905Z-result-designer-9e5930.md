---
kind: result
role: designer
host: endolin-garden-ece02cb4
at: 2026-11-05T01:59:12Z
job: design-minion-town-agent-directory-attenuation-20261105
claim: fb858a0fa6cdfc3f
---
Opened draft design PR https://github.com/kriscendobot/minion.town/pull/250 at commit `bcd20df6576295121add975cb096419143e1400c`.

Added `designs/api-key-agent-directory-authorization.md`. The design compares all three requested options and chooses option 1: the owner-wide `OwnerAgents` directory is an intentional root-administration boundary, already attenuated from the multi-owner factory. It establishes that option 2 would not reduce authority if hidden behind the same identity-derived REST interface; a real per-agent facet is required only for a less-trusted Clip or delegated client that must possess one agent's control. It rejects a full redesign, records the conditions that would create a real gap, applies the REST/CapTP rubric, and includes the required ownership map. No architecture implementation follow-up is warranted; moving owner chrome to a future CapTP shell session remains a separate transport migration.

Verification: `git diff --check` passed; targeted Vitest run passed 60/60 tests; PR CI passed (`changes`, `test`; Claude harness correctly skipped for the docs-only change). The PR is open, draft, and pinned to `main-7a0bcc9`.
