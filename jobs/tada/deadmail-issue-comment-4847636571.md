Posted: https://github.com/kriskowal/garden/issues/9#issuecomment-4847698650

This was an operational/reporting task — no garden source changes, so nothing to commit to main2.

---

## Completion report

**Job:** `deadmail-issue-comment-4847636571` — promoted from a dead-lettered `issue-inbox` message whose addressee (`issue-kriskowal-garden-9`) had already completed. Maintainer comment (kriskowal, issue #9): *"Please post a job to loop until the snapshot is fully downloaded and report back here."*

**What I found:** The Agoric Polkachu snapshot the maintainer was concerned about had **already finished downloading** at 04:33 UTC on 2026-06-30 (a few hours after the prior "resumed at ~56%" report in #issuecomment-4839806548). The completion was never reported back on the issue thread — that gap is why the maintainer asked. The loop's terminal condition was therefore already satisfied.

**Verification (re-checked live):**
- Archive `agoric_26146641.tar.lz4`: 20,627,561,482 bytes — exactly Polkachu's `content-length`; download log shows `saved [20627561482/20627561482]`.
- Vacuumed `swingstore.sqlite` (8,321,896,448 bytes): `PRAGMA integrity_check` → `ok`; `host.height` = `26146641` (matches snapshot height).
- Extracted `data/agoric/swingstore.sqlite`: 19,003,445,248 bytes, sha256 matches `provenance.json`.
- Cache: `$GARDEN_STATE/cache/agoric-snapshots/agoric-26146641/` (per-host, not in git).

**What I did:** Rather than post a perpetual loop job that would immediately exit on its already-met condition, I reported the completion with full evidence directly on the issue thread (posted as `kriscendobot`, the active gh identity matching prior thread comments): https://github.com/kriskowal/garden/issues/9#issuecomment-4847698650. The snapshot is ready to feed to inquisitor for the `hex.js` `flatMap`→loop reproduction.

**Changes to repo:** None (operational/reporting task; nothing committed to main2).

**Follow-ups:** I offered, in the issue comment, to arm a standing watchdog that re-resumes on any *future* stall if the maintainer prefers ongoing assurance over a one-shot confirmation — awaiting their word. No action needed otherwise; the download is complete and verified. Inbox drained clean at finish.
