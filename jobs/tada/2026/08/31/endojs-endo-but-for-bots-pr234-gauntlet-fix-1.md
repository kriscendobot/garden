Inbox empty. The fix stage is complete.

## Completion report

**PR #234** (`design(agents): follow-stream tool for lal/fae monitoring`) — FIX round 1 done.

**Panel round-1 must-fix items applied** to `designs/agent-follow-stream-tool.md`:
- **Integration section rewritten against the real code.** lal delegates its turn loop to `@earendil-works/pi-agent-core` via `makePiAgent`/`runInboxLoop` (no in-repo `runAgenticLoop`, `notificationQueue`, or `pendingProposals`); tools are declarative records in `tools/index.js` dispatched by the `switch` in `tool-dispatch.js`. Correctly attributed `runAgenticLoop`/`extractToolCallsFromContent` to **fae**. Named lal's mid-round drain point as an open pi-agent-core dependency rather than an existing hook.
- Replaced the removed `makeRefIterator`/`@endo/daemon/ref-reader.js` with the live `iterateReader` from `@endo/exo-stream/iterate-reader.js`.
- Fixed References: daemon follow-stream producers are split across `channel.js`/`mail.js`/`pet-store.js`/`host.js`/`manager.js`/`guest.js`, not a nonexistent `daemon/src/daemon.js`.
- Added a **Test plan** catalog (overflow, coalescing, done-vs-cancel, double-cancel, name-collision, stale-generation drop, worker-exit cleanup).
- Added a **per-subscription generation counter** so a reused name can't pick up prior-generation frames.
- Gathered delivery knobs into one `deliveryPolicy` record; kept Phase-2 `filter`/`frameBudget` out of the shipped schema.
- Unified `cancelMonitor` to `{ name, status: 'closed' | 'already-closed' }`; kept `petNameOrPath`'s field name in the response echo.
- Converted the ASCII lifecycle diagram to a validated mermaid `sequenceDiagram`; removed all em-dashes; sentence-cased the top heading; unified ring-buffer policy emphasis; flagged at first use that the subscription name is not a pet-store binding.

**CI blocker diagnosed and fixed:** the first pushes triggered zero Actions runs because the PR had become `CONFLICTING` with base `llm` (only conflict: the hand-maintained `designs/README.md` index), so GitHub couldn't compute the merge ref. Rebased the branch onto current `llm`, resolved the three README index regions (kept llm's current rows, re-added the `agent-follow-stream-tool` entries), and force-pushed head `3b175a5d8`. PR went `MERGEABLE` and CI ran.

**Outcome:** all 6 checks green (lint, test, build, browser-tests, zizmor, copilot-setup-steps). The PR was subsequently merged (07:46:37Z, merge commit `daef3af9`) with the fixed head as content.

**Follow-ups:** none for this stage. (The design carries open questions — including the new #7, the pi-agent-core mid-round injection hook — that belong to any implementation PR, not this design merge.)

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr234-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 180 tokens (11006197 cached reads)
- Output: 69893 tokens
- Cost: $11.7517305
- Wall-clock: 1372s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
