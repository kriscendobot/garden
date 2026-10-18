# PR #202 gauntlet, fix round 2: fixes pushed, CI still pending

I applied the panel-2 must-fix items (review 5560986626) to kriscendobot/minion.town#202 and pushed three follow-up commits. The new head is `5329a05b`. CI has not finished: after 3600 s the `test` and `Claude harness (amd64)` jobs were still queued on the self-hosted runner, with no runner picked up. `Claude harness (arm64)` passed.

## Server side (`src/endo/gateway/new-clip.ts`)
- **Peers only by introduction** (assessor, integrator, locksmith):
  - A peer is now an inventory entry added through `invitePeer` or `acceptInvitation`. Each one is recorded under `<app>/chat-peers/<name>`, holding the mailbox high-water mark at that moment.
  - The page can no longer use that `chat-peers` name in any path.
  - A locator someone imports, or a handle they adopt, does not make a peer.
  - Inventory methods refuse to overwrite a peer's entry, and removing a peer removes its record.
  - Mail from before the introduction is shown as `earlier`, and every action on it is refused.
- **Input checks** (locksmith): the power is now built with `makeExo`, with an `M.interface` guard on all 18 methods.
- **Path limits** (saboteur, breaker): paths are checked as a whole after the power adds its own segments, so the 16-segment limit always holds. A chat app can be at most 14 segments deep.
- **Size limits on received mail** (saboteur, spec-keeper): received text is cut to 4096 code units in total without splitting an emoji, keeps at most 64 parts, and is marked `truncated` when cut.
- **Message ids** (purist): the page now gets the daemon's random message id instead of the mailbox-wide number. A `replyTo` is kept only when it points inside the same conversation.
- **Send race** (breaker): `sendMessage` and `remove` take the same lock, so a send can't be redirected by a remove followed by a rebind. The new test fails if the lock is taken out.
- **Failed invitation** (wire-watcher): if the invitation locator can't be made, the name is freed for another try.

## Client side (`clips/new-clip/`)
- **Out-of-order renders and polling** (saboteur, breaker, engine-realist): each render gets a generation number, and a stale render leaves the page and the poll timer alone. The next poll is scheduled only after the previous one settles.
- **Smaller fixes:** messages are addressed by id, earlier mail has no actions, and the reply preview is cut without splitting an emoji. `ChatMessage` moved to `types.d.ts` (typist), and `args` → `methodArguments`, `EVIDENCE_DIR` → `EVIDENCE_DIRECTORY` (stylist).

## Tests
- **`test/chat-clip-power.test.ts` (new):** runs the power source over an in-memory space and agent, covering each fix above plus the boundaries corner-prober asked for.
- **`test/chat-clip-page.test.ts` (new, prover):** runs the real `main.js` in happy-dom, which I added as a dev dependency. Its out-of-order-render test fails without the generation check.
- **`test/chat-clip.test.ts`:** now has fast-check property tests (fast-checker).
- **`test/chat-clip-daemon.test.ts`:** moved to message ids and gained a nested-chat check.

## Docs and PR text
I updated `designs/chat-clip.md`, `designs/new-clip.md` and `designs/clip-shell-framework.md` (archivist, integrator), and removed restating comments from the workflow, the browser demo and the test files (pruner). I also rewrote the PR body and posted a round summary comment (scribe): https://github.com/kriscendobot/minion.town/pull/202#issuecomment-6245385130

## Declined
- **releaser (changeset):** the package is private and has no Changesets setup, so there is nowhere to add one.
- **purist, engine-realist (each call reads the whole mailbox):** the guest mailbox can't be queried per correspondent. I recorded the cost and timing leak in the design (§ 3) as waiting on the #37 mailbox facets or `followMessages`.

## Local results
- Typecheck is clean, and the chat and New Clip unit suites pass (35 tests).
- Both real-daemon suites pass against the pinned endo `1706e632`, run one at a time (CI also runs them in separate steps).
- The Playwright browser demo passes 15/15 on this head.
- Full `npm test` has one failure, the known unrelated `git-remote/capability` test that the garden host's `git` wrapper breaks.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr202-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (11368088 cached reads)
- Output: 85745 tokens
- Cost: $5.687293600000002
- Wall-clock: 4535s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
