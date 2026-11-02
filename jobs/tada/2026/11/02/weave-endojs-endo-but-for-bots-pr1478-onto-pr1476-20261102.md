I've rewoven #1478 onto #1476's current head. The new head is **`583a7793a8a9f8650392878974ff69016c433003`**, but CI is not fully green: the main CI run passed, and one IronHorse sanitizer job still fails for a reason outside this PR.

**What changed on the PR**
- **New base:** I snapshotted #1476's head (`e530cc47c6`) as `build/ocapn-noise-session-reconnect-heartbeat-e530cc4` and moved #1478's base to it. The old `-9175a5b` snapshot is still there, since #1481–#1483 are stacked on old #1478 heads.
- **Head push:** `build/ocapn-noise-session-queue` was force-pushed (with lease) from `e8222fc4b5` to `583a7793a8`. The PR is still a draft.
- **Diff:** limited to its own five files: the changeset, `network.js`, `types.d.ts`, `_stall-injector.js` and `session-queue.test.js`.

**History is squashed (you should know this).** A commit-by-commit rebase wasn't workable. #1476's 12 commits since the old snapshot rewrote the heartbeat code that #1478's queue sits inside: the heartbeat moved into its own function, the eager read loop is gone, and errors now end the session through a single `close(failure)` path. 13 of #1478's 19 commits edit `network.js` on that old structure. So I ported the final state of `e8222fc4b5` once, by hand, and recorded it as two commits:
- `3b0c486428` feat: the session outbound queue. Its message lists all 18 folded commits by hash and subject. No commits were dropped.
- `583a7793a8` chore: the changeset.

**How the conflicts were resolved (both sides' behavior kept)**
- The queue now lives in the session code; the heartbeat sends its ping/pong through it instead of writing straight to the transport.
- #1478's own error path is gone: queue failures (a write that stalls or is rejected) end the session through #1476's `close(failure)`, and the reader reports the error.
- #1478's separate sent-message counter was dropped, because #1476 now counts both directions itself.
- Kept from #1476: no `op:pong` before the peer has sent anything, and the stricter timeout limits. Kept from #1478: heartbeats coalesce and the pong is built when sent, the 64-frame high-water mark, frame validation and copying, stall timeout, dropping queued frames on close, `writer.return` draining first, and the `err` → `error` rename.
- **Small API change:** `lastSentNonce` now reads `undefined` before the first message, the same as #1476 made `lastAckedRecvNonce`. Previously it would have read `-1n`.
- **Two tests adjusted:** #1476 only runs the liveness timeout and decrypts while the reader is reading.
  - The stall-to-loss test now starts B's read before the stall.
  - The replay test now reads one more frame before checking that B received everything A sent. The check is stricter than before.

**Checks**
- Locally, the `@endo/ocapn-noise` tests passed 111/111 on three runs; package lint has no errors, Prettier is clean, and the root `tsc` reports nothing in this package.
- CI run 41385445799 passed in full, including the bwrap sandbox tests that were red before.
- **Still red: `ironhorse-oracle-sanitizers`**, failing the same way on the first run and on a rerun. It's in ironhorse-262 Rust tests, which this PR doesn't touch: `Math.asinh`/`Math.acosh` results differ in the last digit (stage3-math 054/055). That's the known ubuntu-26.04 glibc problem; PR #1613, which pins those jobs to Ubuntu 24.04, is still open.

**Follow-ups**
- #1481–#1483 need their own weave onto the new #1478 head.
- The sanitizer red should clear once #1613 lands.

I didn't touch #1481–#1483 or post a comment on the PR, because the job didn't authorize it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1478-onto-pr1476-20261102.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (5537759 cached reads)
- Output: 32151 tokens
- Cost: $2.8349237999999994
- Wall-clock: 4071s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
