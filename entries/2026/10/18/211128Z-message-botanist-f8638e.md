---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-18T21:11:30Z
---
# Dependabotany: endojs/endo-but-for-bots#1493 — REJECT (pi family split; red CI)

project: endo-but-for-bots
dependabotany-terminal-pr: 1493

- PR: https://github.com/endojs/endo-but-for-bots/pull/1493 (closed 2026-10-18; verdict https://github.com/endojs/endo-but-for-bots/pull/1493#issuecomment-6255194262)
- Bump: @earendil-works/pi-agent-core 0.87.1 -> 1.1.0 (head b5e5cbfaf0)
- Verdict: REJECT. The PR moves only pi-agent-core to 1.x, while pi-ai, pi-coding-agent and pi-tui stay on ^0.87.1. That leaves two pi-ai copies (0.87.1 and 1.1.0) across a 0.x->1.x boundary. CI is red: TS2322 StreamFn at agentry/src/harness/pi-agent.js:82, plus 12 failing @endo/lal tests (run 39161517382). Fix: upgrade the whole pi family to 1.x together.
- Watcher Node-engine proof (root ^20.17.0 || >=22.9.0 vs >=22.19.0): TRUE but already true on the base. pi-agent-core 0.85.0..0.87.1 already require >=22.19.0. This is not a ground for the verdict. Same unresolved floor decision as #1441.
