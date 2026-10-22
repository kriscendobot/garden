---
handed-off: build-daemon-debug-worker-restart-phase-3-chat-integration-open-pr
deliverable-complete: false
---
The `/debug-restart` command is built and pushed, but the draft PR isn't open yet. This host's token gets a 403 when creating PRs on endojs. I posted a successor job, pinned to an endolin host, to open it.

**What changed** (one commit, `73d34f7e6`, on branch `daemon-debug-worker-restart-phase-3` in endojs/endo-but-for-bots):
- **New command:** `/debug-restart <worker>` is a separate command next to `/debug`, under Workers. I didn't extend `/debug` because that command attaches to a running worker without touching it. A restart suspends the worker and breaks its live CapTP references, so it gets its own name.
- **What it does:** it calls `E(host).debugWorker(...)` with the worker name split into a path (`apps/worker1` becomes `['apps', 'worker1']`). It then opens the existing debugger panel on the returned session, which is paused at `<login>` before any code runs. If `debugWorker` fails, the error shows through the normal path and no panel opens.
- **Tests:** two executor tests (the success path, and a failure that opens no panel) plus one registry test. All 73 tests in the two changed test files pass. The success test fails if the code passes the raw `"apps/worker1"` string instead of the path.
- **Design doc:** `designs/daemon-debug-worker-restart.md` now marks Phase 3 implemented, with the manual check still pending.
- **No changeset:** both packages are private.

**Stacking:** the PR's base is a frozen snapshot of #1524's head, `daemon-debug-worker-restart-phase-2-6579612` at `65796129c`. I pushed that branch myself.

**Checks:**
- **Passed:** formatting, every deterministic probe after I renamed `cmd` to `command` in my test, eslint on the changed files (warnings only, all of them already in the code), a spaces-util typecheck, and the phase-evidence gate.
- **Killed:** the full pre-push gate run hit the 10-minute background limit after the format step, so repo-wide lint and typecheck didn't finish.

**Handoff:** the successor job `build-daemon-debug-worker-restart-phase-3-chat-integration-open-pr` is pinned to `host=endolin-garden-ece02cb4`. It carries the full PR body and runs `ensure-pr.sh` under this job's marker, so a retry picks up the same PR instead of opening a second one. It must not change code, and it names the PR so the review gauntlet starts.

**Follow-ups:**
- The design's manual check hasn't been done: run `/debug-restart @main` against a real daemon and confirm the panel opens with the worker paused at login.
- The existing `/debug` command calls `attachDebugger`, which the host interface doesn't provide, so `/debug` probably fails today. That's outside this job and I didn't touch it.
- Phases 1 and 2 (#1523, #1524) are still open drafts, so this PR can't land before them.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-debug-worker-restart-phase-3-chat-integration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3722148 cached reads)
- Output: 18180 tokens
- Cost: $1.9031896000000001
- Wall-clock: 3193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
