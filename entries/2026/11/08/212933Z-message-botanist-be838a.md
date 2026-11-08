---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-08T21:31:32Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1657 MERGE-NOW (conduct blocked on base-red test-xs / #1646)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR #1657 - MERGE-NOW (non-terminal) - @earendil-works/pi-coding-agent 0.87.1 -> 1.4.0 (npm, major; consumer packages/agentry). Head 306baa33a8ed3be7defb20128635982a9181c12e, ahead=1 behind=0 vs llm 48d6f3e08b; base still ^0.87.1; no sibling PR.
- Maturity floor: 2026-10-28T22:48:58Z (headline pi-coding-agent@1.4.0 is the freshest moved version, 2026-10-21T22:48:58Z). Passed.
- Moved set: pi-coding-agent/pi-agent-core/pi-ai/pi-telemetry 1.4.0 (nested), new pi-codemode 1.4.0, pi-mcp 1.4.0, quickjs-wasi 3.6.2; extra @anthropic-ai/sdk 0.129.0, openai 7.19.0; brace-expansion 5.0.12 alias only. All trusted publishing + SLSA, no install hooks, OSV/GHSA clean on both sides.
- Local: scripts-disabled install clean; agentry tsc clean, 207 + 13 ava pass (conflict-rebase needs GIT_CONFIG_GLOBAL=/dev/null on this host: global rerere). endo-pi --version = 1.4.0.
- CI: 25 success; test-xs red = base-attributable (Node 26 lts/* rollover, hardened262 ThrowTypeError sesNode; identical on llm 48d6f3e08b); test (22.x, macos-15) red = claude-sandbox restore-context macOS flake, job 128846679652 re-run requested.
- Conduct NOT attempted. Unblock: once #1646 lands on llm (and the macOS rerun is green), run `ci-wait-merge.sh endojs/endo-but-for-bots 1657 --dependabot-auto-merge`. Recheck via the existing daily heartbeat `dependabotany-recheck-endo-but-for-bots`; no one-shot (floor already passed).
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1657#issuecomment-6727376011
- Foreign-content classification: none; no upstream prose was read.
