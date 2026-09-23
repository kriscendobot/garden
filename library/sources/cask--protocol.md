---
source: doc/design/protocol.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: current
---

The CASK Local Protocol (`cask/sock`, casksock): the plaintext, unencrypted protocol over the local Unix domain stream socket at `.cask/cask.sock` for CLI-to-daemon communication. Trusted because it is local-only and filesystem-permission-gated. Twelve 4-byte lowercase ASCII commands (`stor`/`load`/`ackn`, `casw`/`casr`, `coll`/`colr`, `head`/`hedr`, `nonc`/`nncr`, `stop`, `eror`); byte-exact `stor`/`load`/`ackn` layouts; the 1024-byte block body + separate 12-byte metadata footer (height/numLinks/dataLen/reserved); reliable retransmit-until-`ackn` store, RTT-bounded `ackn` batching, CoDel-style send-queue pacing, and priority-boosted ACKs. This is the **current** local protocol (distinct from the encrypted inter-node casknet protocol documented under `cask--net-crypto--*` / `cask--net-session-init-design--*`).

| Section | Topics | Status |
|---------|--------|--------|
| [casksock-transport-and-message-types](../sections/cask--protocol--casksock-transport-and-message-types.md) | networking | current |
| [message-and-block-formats](../sections/cask--protocol--message-and-block-formats.md) | networking, content-addressed-storage | current |
| [flow-reliability-and-security](../sections/cask--protocol--flow-reliability-and-security.md) | networking | current |
