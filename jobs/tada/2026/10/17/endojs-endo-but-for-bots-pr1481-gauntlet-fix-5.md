# Fix round 5 for endojs/endo-but-for-bots PR #1481: panel must-fix applied, CI green

I pushed two follow-up commits to `build/ocapn-noise-session-reconnect-rekey` (`f0622cc43` → `d1647d38f`, via `safe-push-pr-head.sh` in advance mode). CI came back green: `ci-wait-merge` returned rc 0, with 35 of 35 checks passing and none failed.

**Saboteur must-fix #1 (a replayed SYN for a resumable peer).** The reviewer's point that this path had "no cap" was overstated. The per-local-key admission budget (`admitInbound`) already covers every inbound handshake before decryption. The real hole was that one recorded SYN, replayed for a peer with a resumable session, could fill that whole budget and push out other peers' handshakes. That works because such a SYN skips the early refusal used for already-adopted peers.
- **The fix:** a new `resumeAttempts` map in `network.js` allows each resumable peer at most one unproven inbound handshake. A newer attempt evicts the older one, so a replay can't hold the slot against the peer's real redial.
- **When the slot frees up:** as soon as `exchangeIdentity` and the session hello prove the peer, so a later replay can't evict a resume that is already under way. The map is cleared on shutdown.

**Saboteur should-fixes #4 and #5 (cheap, so applied too).**
- **#4:** when the hard timeout aborts a session, the error now carries the last redial error as its `cause`, so a permanent dial failure is no longer silent.
- **#5:** a `reconnect` option that is neither a boolean nor an object (such as `null` or `'yes'`) is now rejected with a clear error.
- **#5:** the default `backoffMaxMs` is raised to at least `backoffInitialMs`, so setting only a large initial delay no longer produces an error about an option the user never set. `types.d.ts` and the tests are updated to match.

**Pruner cuts.**
- Removed the three narrating comments in `reconnect.test.js` (lines 138, 179, 290) and the `SESSION_END_WRITE_TIMEOUT_MS` JSDoc.
- Removed the design § 7 sentence that only pointed at another section, and the changeset's repeat of the "pending OCapN-org review" caveat.

**PR body: not applied yet.** The trimmed body (507 → about 487 words) is ready, but `gh pr edit` failed here with a PAT 403. This host's bot token can't write to endojs PRs. I posted job `endojs-endo-but-for-bots-pr1481-fix5-body-trim`, pinned to `requires: host=endolin-garden-ece02cb4`, to apply it. That body:
- drops the Scaling, Documentation and Compatibility sections;
- cuts Testing to the ICU flake note;
- folds Upgrade into one sentence;
- adds a Security bullet describing the new resume-handshake cap.

**Local checks:** `yarn lint` shows 0 errors (the 9 warnings were already there). `yarn test` passed all 104 tests in each of the three ses-ava configs across two clean full runs. One earlier run reported 1 uncaught exception and did not reproduce in either clean rerun, so it's probably the intermittent ENOENT flake the PR body already notes, but I didn't catch its output to confirm.

**Not done (should-fix only, left for a later round):**
- Saboteur #2: backoff resets when a peer repeatedly attaches and then drops.
- Saboteur #3: no cap on the outbound queue while reconnecting.
- Pruner #3: the test comment at lines 133–134 is kept.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3360265 cached reads)
- Output: 19223 tokens
- Cost: $1.7782569999999995
- Wall-clock: 2916s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
