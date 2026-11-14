**PR #667 viability check (endojs/endo-but-for-bots): proceed**

- **PR state:** open, not merged, not a draft, mergeable. The head is `9b70df7f8e`. The base is `llm-48d6f3e`, which is the current `llm` tip (0 commits ahead, 0 behind). A rebase onto it was pushed at 2026-11-14T08:38Z.
- **Deciding question:** Does current `llm` still have no stdio JSONL RPC bridge for `PiAgent`, while the maintainer still wants this one landed in `@endo/agentry`?
- **Evidence:**
  - No bridge on `llm`. Its `packages/agentry/package.json` has no `./rpc` export, and `packages/agentry/src` has no `rpc/` directory. Code search finds no `serveRpc` anywhere in the repo, so nothing newer has replaced it.
  - The design it implements, `designs/endopi-stdio-rpc-bridge.md` on `llm`, is still "Status: Proposed". Its motivation still holds: embedding hosts (IDE plug-ins, CI runners, Familiar panes) need a stdio transport, and the only existing transport is the WebSocket gateway.
  - What the PR builds on still exists on `llm`: `makePiAgent` is still exported from the agentry root, and the `@earendil-works/pi-agent-core` dependency is still there.
  - kriskowal's (the maintainer's) review asked for the work to be moved into agentry or agent-tools. The PR now places it at `packages/agentry/src/rpc`. Their later comment (2026-07-29) asked to "rebase on current llm, resolve conflicts, and conduct", and the rebase has now been done.
- **Earlier halt:** the previous gauntlet (2026-11-02) halted on a failed fix stage with CI red. That is a quality problem for this run's later stages to handle. It does not make the PR obsolete.

I did not touch the PR and changed no files.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr667-gauntlet-20261114-9b70df7f8e4f-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (251495 cached reads)
- Output: 2069 tokens
- Cost: $0.493799
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
