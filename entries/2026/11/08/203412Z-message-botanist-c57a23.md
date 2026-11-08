---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-08T20:34:13Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1654 — HELD (escalated: fixer)

project: endo-but-for-bots
project: endo-but-for-bots

all-minor-patch group (15 updates: @types/node, @typescript-eslint/* + typescript-eslint 8.72.1, ava 8.1.2→8.3.0, globals 17.14.0, type-coverage 2.31.1, rollup 4.67.4, amaro 1.3.0, marked 18.1.2, ws 8.22.1, openai 7.47.0). Clean shape; no sibling supersession; base llm 48d6f3e08 still at outgoing versions.

Maturity satisfied: freshest moved version globals@17.14.0 published 2026-11-01T11:01:01Z, floor 2026-11-08T11:01Z (passed). OSV clean both sides; publishers unchanged; no install scripts; source diffs benign.

Blocker: ava 8.3.0 strict t.timeout() wall-clock deadline (also in 8.4.0) turns cover 22/24 (@endo/sandbox spawner/bwrap) and test 22 macos (@endo/platform node-fs watch) red; green on base. test-xs red is pre-existing on base. Escalated to fixer job endojs-endo-but-for-bots-pr1654-ava-timeout-fix (pushes to PR head). Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1654#issuecomment-6726767202. Row OPEN until terminal verdict (expected MERGE-NOW via ci-wait-merge.sh --dependabot-auto-merge once green); daily backstop dependabotany-recheck-endo-but-for-bots exists.
