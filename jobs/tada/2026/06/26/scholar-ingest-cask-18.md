Done. The job completed cleanly and my scratch was removed (the remaining `scholar-cask-c16-*` dir is a prior cycle's, left for the scratch janitor).

---

## Completion report — `scholar-ingest-cask-18` (cycle 18)

**What I did:** Continued the cask `net/` comment-fragment ingest and completed the lane. Idempotency-verified against a sparse scratch clone under the bot home (not `/tmp`): the net Go files still share file-commit `cdb975d8`, and `cask--net-peer-go`'s recorded anchor matched, so the peer.go work is an in-place source extension, not a re-ingest. All library writes were made in a uniquely-suffixed isolated worktree off `origin/journal2` and CAS-pushed (checking the `git push` exit code directly — the first attempt's `tail` pipe had masked a non-fast-forward rejection, caught and redone).

**Sources / sections added (6 new sections, +1 source):**
- **`cask--net-peer-go`** extended in place, `section_count` 4 → 7 (anchor unchanged):
  - `server-receive-loop-and-encrypted-dispatch` — `Start`/`handle`/`handleEncrypted`: read loop, first-four-bytes plaintext/encrypted fork, graceful-shutdown tracking, replay-noise suppression, decrypt → `UpdatePeerAddr` mobility → inner dispatch.
  - `responder-handshake-consistency-and-authorization` — `Server.handleInit`: ed25519↔x25519 consistency check, `statusNotAuthorized` member gate, 24h TTL cap, responder mutual `MemberAdd`. Cross-referenced as the responder counterpart to cycle 17's initiator-side section.
  - `encrypted-acknowledge-batching` — `noteEncryptedAcknowledge`/`flushEncryptedAcknowledgesLocked`: per-session grouping, batch-or-deadline flush, average-holdback computation.
  - `net/peer.go` is now **complete** for this lane.
- **`cask--net-noise-go`** (new source, 3 sections) — soft-flag check passed; ingested only implementation clusters that add over the design docs / `noise-ik-session-establishment` concept: the IK token-ladder state machine, the HKDF/HMAC-BLAKE2b/ChaCha20-Poly1305 primitives, and the ed25519↔x25519 key conversion.

**Surveyed below-bar (recorded so it isn't re-surveyed):** `net/relay.go` — longest `//` run is 5 lines (the `Relay` type comment); below the ≥8-line longform bar. Joins `blob/chunker.go` and `sendbuffer/buffer.go`.

**Indexes updated:** `sources/README.md`, `topics/README.md` (networking 50→56, capability-security 187→189), `topics/networking.md` (+6), `topics/capability-security.md` (+2), `concepts/README.md` (cycle-18 deepening notes on 3 concepts), the 3 concept pages (`noise-ik-session-establishment` +5 section rows/~30 aliases, `member-table-authorization` +1, `casknet-wire-protocol` +2), and `keywords.md` (+47 lines, append-only union).

**Drift watch:** No new comment-vs-code drift. The two carried items remain as recorded (the `buildInitPacket` 144B/176B layout-comment lag in `cask--net-crypto-go`; the `handleInit` `DefaultBestTrafficClass` TODO, now captured in the new responder section as a known unfinished feature). Scholar does not push upstream.

**Corpus state:** 43 sources / 173 sections (was 42 / 167). The cask comment-fragment `net/` lane is **drained** (crypto.go, peer.go, noise.go ingested; relay/chunker/buffer below-bar) — **no follow-on job posted**. Landed on `origin/journal2` at `400fe03f`; result entry `entries/2026/06/26/004817Z-result-scholar-79fd48.md`. Inbox was empty at checkpoint.

**Follow-up:** none outstanding for the `net/` lane. Three pre-existing peer scratch dirs sit at the garden root (`cask-scratch-c17-g55/`, `pr532-work/`, `scholar-cask-c17-endolinbot-g55/`) from a prior cycle's gardener — not mine and possibly active, so I left them rather than risk clobbering a peer's work; flagging for the liaison.

Self-improvement: nothing this time.
