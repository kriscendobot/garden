# scholar-ingest-cask-15 (cask cycle 16) — DONE

Ingested cask `net/crypto.go` as the second comment-fragment source of the cask
corpus (first of the net/ package), 4 sections under `cask--net-crypto-go`:
command-constants-and-mirror-convention, command-plaintext-wire-layouts,
counter-nonce-and-replay-protection, membership-mutuality-traffic-class-and-key-asymmetry.

crypto.go is the implementation-side source-of-truth for the casknet protocol the
net-* design docs describe; sections cross-reference the existing concepts
(casknet-wire-protocol, noise-ik-session-establishment, member-table-authorization,
codel-send-buffer-shedding) rather than restating.

Indexes: +4 networking rows, +1 content-addressed-storage, +2 capability-security;
topics/README counts net 42->46, CAS 81->82, cap-sec 184->186; +29 keywords.md lines;
sources/README + 4 concept pages + concepts/README deepening notes.

Noticed comment-vs-code drift: buildInitPacket layout comment (144B, omits ed25519
key blob) lags initPacketSize const (176B). Flagged as a candidate upstream
comment-fix missive (scholar does not push upstream).

Corpus now 41 sources / 163 sections. Pushed to journal2 (commit 132901323).
Follow-on posted: scholar-ingest-cask-16 (cycle 17 — net/peer.go, then noise.go
soft-flag-check, then relay.go survey).

Self-improvement: nothing this time.
