# Gauntlet fix round 1 for endojs/endo-but-for-bots#1487: fixes pushed, CI green

I fixed both of the panel's must-fix items and most of the should-fix items, pushed them as four follow-up commits, and CI is green on the final head `8e71116a37a` (35 checks, 0 failed). One part is not done yet: the PR body and title edit. This host's token gets a 403 when editing PRs, so I posted that as a separate job pinned to the endolin host.

**Must-fix items:**
- **Broken citation (archivist).** The session-reconnect design cited § 6 / recommendation R3 of `ocapn-noise-cryptographic-review.md`, but that section only exists in the rewrite on https://github.com/endojs/endo-but-for-bots/pull/1475. The design now points at #1475 and says the copy on this branch is the older, deprecated review.
- **Reversed maintainer decision (decomplector).** Settling C1 as Rekey-only reverses the tentative Resume decision kriskowal made on https://github.com/endojs/endo-but-for-bots/pull/252. The design now says so plainly, and C1 moves back to the open questions until the maintainer confirms. I also sent the maintainer a message asking for that confirmation.
  - The liaison replied asking for a short note on what a Resume path would need. That is the fourth commit: a per-instance derived key so no `(key, nonce)` pair can repeat, plus the rekey-cap.

**Should-fix items, by file:**
- **Design doc:**
  - The `op:pong` field `last_acked_recv_nonce` is now defined as a frame count that restarts with each epoch.
  - Receivers must always deduplicate replayed operations; the hedged "exact counting or dedupe" wording is gone.
  - Removed the "Resolution of C1" paragraph, the "was …" history notes, the "Phase 4: dropped" item (Crossed-hellos is now Phase 4), and repeated forward-secrecy lines.
- **Other design files:** synced the date in the `designs/README.md` index row, and fixed the stale "Noise sequence continuity" line in `designs/ocapn-noise-network.md`.
- **Package README:**
  - Replaced `‖` with `||` in the layout table and cut three restated sentences.
  - Added that on `np/1` the channel binding is always the 32-byte handshake hash and never empty. I checked this against `packages/ocapn/src/cryptography.js`.
- **Key-compromise test:** a read error now counts as a hang-up, and the test waits for pending callbacks before asserting the session never graduated. `yarn test test/network.test.js` passes 38/38; prettier and eslint are clean.

**Follow-ups:**
- **Job `endojs-endo-but-for-bots-pr1487-gauntlet-fix-1-pr-body`** applies the trimmed PR body and changes the title prefix from `feat` to `docs` (the PR changes no behavior). The new body asks @kriskowal to confirm the C1 reversal and says this PR should land after #1475.
- **The liaison also asked for a comment on #1487 or #1475** flagging the reversal. I couldn't post one from this host. The new PR body and the maintainer message cover it.
- **Not addressed:** the wire-watcher's point that the key-compromise test can't tell a rejection from a timeout, and the spec-keeper's request for spec citations in the README. Panel round 2 can raise them again.
- **Merge stays blocked** until the maintainer settles C1.
- **Likely conflict:** `designs/README.md` will probably conflict with #1475, which edits the row next to the one I changed. A weave will need to resolve it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1487-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3490225 cached reads)
- Output: 18187 tokens
- Cost: $1.807921
- Wall-clock: 4067s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
