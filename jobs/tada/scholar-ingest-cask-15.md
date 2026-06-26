Done. Verified `cask--net-crypto-go` is on `origin/journal2`, scratch cleaned up, job completed.

## Completion report — `scholar-ingest-cask-15` (cask cycle 16)

**What I did.** Wore the scholar role and continued the cask comment-fragment lane with the densest `net/` file, **`net/crypto.go`** (the casknet `SessionManager`). Idempotency-checked all four net Go files against `origin/journal2`: they share commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` and no comment-fragment source existed for any of them, so this was a fresh ingest. Work was done in a uniquely-suffixed isolated worktree off `origin/journal2` under the bot home, with a sparse scratch clone (not `/tmp`); CAS-pushed on attempt 1.

**Sources ingested.** `cask--net-crypto-go` — **4 sections**:
1. `command-constants-and-mirror-convention` — eleven command codes, the response-is-request-reversed convention, status codes, Noise-IK packet sizes (init 176 / tini 121).
2. `command-plaintext-wire-layouts` — byte-exact build/parse layouts of every command plaintext.
3. `counter-nonce-and-replay-protection` — nonce-is-the-send-counter, strict-monotonic recv high-water mark, directional-key independence.
4. `membership-mutuality-traffic-class-and-key-asymmetry` — three implementation-only notes: mutual membership via `MemberAdd`, `bestTrafficClass` priority clamping, send-only key persistence.

`crypto.go` is the implementation-side source-of-truth for the casknet protocol the design docs describe in prose; sections cross-reference the existing concepts rather than restating them.

**Indexes updated.** `sources/README.md` (+1 row); `topics/README.md` counts networking 42→46, content-addressed-storage 81→82, capability-security 184→186; topic pages networking (+4), content-addressed-storage (+1), capability-security (+2); four concept pages (`casknet-wire-protocol`, `noise-ik-session-establishment`, `member-table-authorization`, `codel-send-buffer-shedding`) gained sections, aliases, and a packet-size Common-confusions block; `concepts/README.md` deepening notes; `keywords.md` +29 lines.

**Drift noticed (flagged, not pushed).** `buildInitPacket`'s layout comment says 144 bytes and omits the encrypted ed25519-key blob, while the `initPacketSize` const says 176 (corroborated by `net/noise.go` and `MemberLookupFunc`). Recorded as a candidate upstream comment-fix missive in the source notes, the wire-layouts section, and the casknet-wire-protocol Common-confusions block. The scholar does not push upstream, so this is surfaced for the boatman/maintainer.

**Follow-ups.** Posted `scholar-ingest-cask-16` (cycle 17): `net/peer.go` next (~2336 lines, may need two cycles), then `net/noise.go` (soft-flag-check overlap before ingesting), then survey `net/relay.go` (likely below-bar). Corpus now **41 sources / 163 sections**.

Self-improvement: nothing this time — the comment-fragment conventions, slug discipline (`cask--net-crypto-go` cleanly distinct from the `cask--net-crypto` design doc), and idempotency check all held without friction.
