---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-13T20:06:43Z
---
# Dependabotany

project: endo-but-for-bots

- PR: https://github.com/endojs/endo-but-for-bots/pull/1272
- Package: eslint-plugin-unicorn 73.0.0 -> 74.0.0 (devDependency)
- Verdict: REJECT (incompatible) — EXECUTED close 2026-09-13
- Reason: unicorn@74.0.0 requires Node >=22; project floor is Node 20.17.0 (engines `^20.17.0 || >=22.9.0`). Incoming range excludes the supported floor.
- Head verified: c3f71cd6d41c4055b981208b4c9703344fa57ac5
- Latest on npm at close: 74.0.0 (no newer release restores Node 20 support); not superseded, no sibling PR.
- Reopen if the project raises its Node floor to >=22.
