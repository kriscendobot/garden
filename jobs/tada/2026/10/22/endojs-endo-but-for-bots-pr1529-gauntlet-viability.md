## Viability report: endojs/endo-but-for-bots PR #1529

**Result: proceed.** The PR is still needed and nothing has replaced it.

**PR facts:** The PR is open, draft and unmerged. It is "feat(chat): /debug-restart restarts a worker paused under the debugger (debug worker restart, Phase 3)". The head is `daemon-debug-worker-restart-phase-3` @ `73d34f7e`. The base is the frozen snapshot `daemon-debug-worker-restart-phase-2-6579612`. It was opened 2026-10-22T03:14Z and has no reviews or comments yet.

**Deciding question:** Is the Phase 3 chat command (`/debug-restart` calling `E(host).debugWorker` and opening the existing debugger panel) still missing from `llm`, with its stack (#1523 → #1524) still live, so the design's Phase 3 is still unbuilt? **Answer: yes.**

**Evidence:**
- **Stack still live:** #1523 (Phase 1, supervisor debug flag, on `llm-f02cd81`) and #1524 (Phase 2, `debugWorker`, which this PR is stacked on) are both open drafts. Neither has been merged or closed, so the base #1529 builds on is still the path forward.
- **Not on `llm`:** `packages/spaces-util/src/command-registry.js` on `llm` has only the existing `debug` command (line 834). It has no `debug-restart` entry and no `debugWorker` call.
- **No competing PR:** a search of the repo for "debug-restart" finds only this stack. #1530 (host `attachDebugger` hot-attach, Phase 7 of the XS worker debugger design) is a different feature. It attaches to a running worker without restarting it, and the PR body itself says it keeps that behaviour separate from restart-paused-at-login on purpose.
- **Premise still holds:** `designs/daemon-debug-worker-restart.md` still lists Phase 3 (chat integration) as the next step, and this PR is its first and only implementation. The PR is less than an hour old.

**Follow-up for later stages:** the PR says the design's manual check (`/debug-restart @main` should open the panel paused at login on the Rust/XS supervisor) has not been done.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1529-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (120900 cached reads)
- Output: 1263 tokens
- Cost: $0.407592
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
