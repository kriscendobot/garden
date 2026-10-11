---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-11T21:57:23Z
---
project: endo-but-for-bots
dependabotany-terminal-pr: 1439

# Dependabotany

- https://github.com/endojs/endo-but-for-bots/pull/1439 — REJECT (incompatible), closed. Root Node support is `^20.17.0 || >=22.9.0`; `@earendil-works/pi-ai@1.0.2` requires Node `>=22.19.0`. The outgoing 0.87.1 has the same engine requirement, so this is not a finding against 1.0.2 specifically. Reopen after raising the root floor or declaring `>=22.19.0` in `packages/agentry` / `packages/lal`.
