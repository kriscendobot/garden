---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-04T20:11:19Z
job: endojs-endo-but-for-bots-pr1424-dependabot
claim: 52267293b968f2de
---
Verdict: REJECT (incompatible).

Re-fetched the live endojs/endo-but-for-bots#1424 head and confirmed `refs/pull/1424/head` and the isolated worktree both resolved to `d41b2f0d5f435e44cef3f13766b82338c0fc9df7`. The root `package.json` still declares Node `^20.17.0 || >=22.9.0`, while registry metadata for `electron@44.4.5` still declares Node `>= 22.12.0`. Because the proposed dependency excludes the project's supported floor, the declaration-level preflight remained conclusive and the lockfile/source/advisory/test chain was intentionally not run.

Posted the structured verdict at https://github.com/endojs/endo-but-for-bots/pull/1424#issuecomment-5983928696, closed the bot-owned pull request, and verified GitHub reports `state=CLOSED` at the same head SHA. Recorded the terminal Dependabotany ledger entry; no active embargo row or follow-up is needed.

Self-improvement: nothing this time.
