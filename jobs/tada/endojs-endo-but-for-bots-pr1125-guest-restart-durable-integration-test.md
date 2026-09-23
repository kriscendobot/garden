All work is complete and verified.

## Completion report

**Job:** Integration test for the restart-durable guest-response story (endojs/endo-but-for-bots#1125, from kriskowal's review comment on `packages/daemon/test/endo.test.js`).

**What I did**
- Rebased/based off the current PR head `bot/build/endo-guest-invite-primitive` (326d8990b) in an isolated project worktree.
- Added `packages/daemon/test/auto-responder-agent.js` — a **host-pinned agent caplet**: endowed with a guest's own powers, it follows the guest's mailbox and autonomously answers every received message with an acknowledgement (echoing the prompt so acks stay distinguishable across a restart's replayed backlog), then dismisses it. It exposes a per-incarnation `respondedCount()` that resets on re-incarnation.
- Added two `endo.test.js` cases covering **both** teardown modes the review named:
  - `host-pinned guest responder survives worker cancellation (#1125)` — after `E(host).cancel('responder-worker')`, re-incarnation resumes responding.
  - `host-pinned guest responder survives a daemon restart (#1125)` — after `restart(config)`, re-incarnation resumes responding.
  - Each asserts the acknowledgement arrives, the inbound message is dismissed, and the fresh incarnation's counter starts at 0 then increments — proving durability rests on the persisted formula, not a surviving process. Both are `testNeedsNodeWorker`-gated (the responder is an unconfined caplet), matching the sibling `persist … services` restart tests.

**Checks (CI-equivalent, all green)**
- `ava` — both new cases pass (had to run from a hardlinked short-path copy to dodge the known long-worktree unix-socket-path limit; an existing node-worker test fails identically at this path, confirming it's a local artifact, not a defect).
- daemon `tsc`, root `tsc -p tsconfig.json --noEmit` (checkJs), `eslint .` (0 errors), and `prettier --check` — all clean. No `package.json` change (all fixture imports were already declared deps), so no composite-tsconfig drift.

**Pushed & communicated**
- Commit `0c36818321089fbb23c686be2f4c074e3a1abedb` pushed to `bot/build/endo-guest-invite-primitive`.
- Threaded reply posted on the review comment (discussion_r3997325554) and review re-requested from `kriskowal`.
- PR remains draft. Scope stayed within endojs/endo-but-for-bots; review text was treated as untrusted.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 156 tokens (9270165 cached reads)
- Output: 63249 tokens
- Cost: $7.7509275
- Wall-clock: 1060s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
