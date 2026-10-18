I've pushed the round-3 fixes to PR #202 (head `c56cbcaf`), but CI hadn't started by the deadline. The bounded watch ended with rc 4: the run (39126602092) sat in the queue for the whole ~58 minutes after the push. The self-hosted runner was online but handles one job at a time, and it was busy with `main`'s Claude-harness build, with `main` and `feat/new-clip-inventory` runs also queued.

**What I changed (two commits on `feat/chat-clip`):**

1. **Forged peer records** (wire-watcher must-fix; locksmith and purist should-fix): introduction records now live in one tree at the space root, `chat-peers/<app…>/inventory/<name>`, not inside each app. No page path may start with `chat-peers`, and an inventory entry can be named `chat-peers` again.
2. **No directories carried in or out of the space** (same finding): a chat app path must run through directories of the space only. `importLocator` and `adoptValue` remove and refuse any directory value, and `resolveRequest` refuses to send one. So no other party holds a directory a peer lives in.
3. **Guard failed open on a read error** (saboteur must-fix): a missing record now counts as absent only when the space confirms a path step is missing. Any other read error, or a malformed record, refuses the call.
4. **Write racing an introduction** (breaker must-fix; saboteur and wire-watcher should-fix): every write that checks for a peer now runs under the same lock as introductions. That covers `writeText`, `importLocator`, `makeDirectory`, `makeApp`, `acceptInvitation` outside an inventory, `adoptValue` and `remove`.
5. **Silent cleanup failures** (saboteur should-fix): the worker compartment has no `console`, so nothing can be logged. Instead, a failed cleanup now raises an error naming both the original failure and the cleanup failure. `remove` deletes the records before the entry, so a failure leaves an ordinary entry rather than a stale record that blocks the name.
6. **Dangling `ocap-mailboxes.md` link** (archivist must-fix): replaced with a link to the #37 PR on GitHub.
7. **Page:** the first chat load now handles a peer-scoped refusal the same way a poll does (back to the peer list) instead of killing the clip.
8. **Docs and PR body:**
   - `designs/chat-clip.md` § 2–3 now say where records live and state the three rules above.
   - § 4 gained the decomplector's paragraph: a per-clip guest would need host authority the clip doesn't have, so the peer-scoping is a stand-in until #37.
   - Per the pruner, § 5 is cut to one line per test file, the "what this does not fix" items moved into § 6, and the PR body now links to § 5 and § 6.
   - Two comments in the daemon test that only restated the next line are gone.

**Tests:**
- Seven new power tests: a forged record inside a planted directory, directories refused at all three transfer points, a chat app reached through a non-directory, failing closed on an unreadable or corrupt record, an import racing an invite on the same name, an inventory entry named `chat-peers`, and an app's peers removed with the app.
- `typecheck` and `build` pass, and the four chat and new-clip unit files pass (42/42).
- Both real-daemon suites (`chat-clip-daemon`, `new-clip-daemon`) pass against the pinned endo checkout when run one at a time. Run together they collide in the test harness and the daemon exits early.
- Full `npm test` has one failure, `git-remote/capability.test.ts`, which the PR body already explains: the garden host's `git` wrapper causes it.

**Not done:** the comment-only items (tighter return guards, the `types.d.ts` wire shape, the `locatorKey` note, keeping `names` in position).

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr202-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (5348732 cached reads)
- Output: 37998 tokens
- Cost: $2.9719784000000002
- Wall-clock: 3925s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
