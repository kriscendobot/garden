---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-25T20:22:11Z
---
# Dependabotany — endo-but-for-bots PR #1551

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1551
head: eeea7a3dada272914b9dd350d2c8041640ae4b63
verdict: REJECT
state: closed
active: false

Rejected and closed on 2026-10-25. The grouped bump's `ava@8.1.0` unconditionally writes `RegExp.lastIndex` while matching thrown-error messages, which fails on Endo's hardened regular-expression expectations. The focused sandbox test passes 264/264 on base with AVA 8.0.1 and fails six times on the PR with AVA 8.1.0. No recheck is scheduled; a corrected Dependabot proposal should replace this terminal row.
