---
ts: 2026-07-07T00:22:07Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/621
  - https://github.com/endojs/endo-but-for-bots/pull/612#issuecomment-4898839275
---

Job design-refine-endoclaw-oauth-foundation complete. Refined designs/endoclaw-oauth.md
as the credential foundation for domain connectors (exo-google-sheets, Gmail/Calendar
siblings), per kriskowal review of PR #612. First-mint flow settled: host-run
authorization-code with PKCE against a loopback redirect by default (RFC 8252 s7.3),
device-code (RFC 8628) as a per-provider alternative (excluded for Google connectors:
Google's device flow does not cover Sheets/Gmail/Calendar scopes), choice invisible to
consumers. Token record split from facets (one consent, many base URLs/grants),
setScopes removed, structured auth-layer errors vs pass-through provider errors, and a
Connector Contract section. Draft PR #621 opened against llm on branch
design/endoclaw-oauth-foundation; cross-link comment posted on #612 (standing
authorization). designs/README.md synced (summary row, recently-revised, M7 estimate).
