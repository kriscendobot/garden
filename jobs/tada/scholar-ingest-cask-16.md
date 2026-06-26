# scholar-ingest-cask-16 — cask cycle 17: net/peer.go comment-fragment ingest (4 sections)

Ingested the largest net/ file, `net/peer.go` (~2336 lines / ~195 comment lines), as the third
comment-fragment source of the cask corpus. Four cohesive Peer-side clusters; one new concept;
Server-side + noise.go + relay.go deferred behind a posted follow-on.

Source `cask--net-peer-go` (kriskowal/cask@main, file-commit `cdb975d8`, 2026-02-14) — 4 sections:
1. command-request-span-lifecycle (networking, content-addressed-storage)
2. rtt-estimation-and-retransmission-timeout (networking)
3. traffic-class-send-queue-drain-prioritization (networking)
4. session-renewal-single-flight (networking, capability-security)

New concept: casknet-rtt-and-retransmission-timeout (RFC 6298 + Karn's algorithm; the per-packet
retransmission timer, distinct from CoDel admission shedding).

Indexes: sources/README +1 row; topics/README counts networking 46→50, content-addressed-storage
82→83, capability-security 186→187; networking/+4, content-addressed-storage/+1, capability-security/+1;
concepts casktel-span-completion/codel-send-buffer-shedding/noise-ik-session-establishment/
member-table-authorization +1 section each; concepts/README new row + cycle-17 deepening notes;
keywords.md +34 lines.

Idempotency: all four net Go files still share commit cdb975d8; no prior comment-fragment source for
peer.go/noise.go/relay.go. Pushed to journal2 as 5ab85d045.

Comment-vs-code drift: none new. Pre-existing carried: cycle-16 buildInitPacket 144B-vs-176B layout-comment
lag (candidate upstream missive, recorded in cask--net-crypto-go); explicit handleInit DefaultBestTrafficClass
TODO (known unfinished feature, not stale comment).

Corpus after cycle: 42 sources / 167 sections.

Follow-on posted: scholar-ingest-cask-18 (remaining peer.go Server-side clusters: receive loop +
handleEncrypted dispatch, responder handleInit ed25519<->x25519 consistency check + authorization +
responder mutual MemberAdd, encrypted-ack batching; then net/noise.go soft-flag-checked; then survey
net/relay.go). blob/chunker.go and sendbuffer/buffer.go remain confirmed below-bar.

Result entry: entries/2026/06/26/003449Z-result-scholar-51cdbd.md

Self-improvement: nothing this time.
