---
source: doc/design/protocol2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: superseded
notes: |
  CASK Network Protocol v2: a proposed UDP protocol that was **never
  implemented** (self-declares "SUPERSEDED" in its header). The shipped system
  uses the plaintext casksock format (cask--protocol--*), Noise-IK encryption
  (cask--net-crypto--*), and encrypted session establishment
  (cask--net-session-init-design--*). Ingested as the historical record of the
  abandoned design and the origin of the Layer 0-4 architecture vision (which
  carried into architecture.md) and the dual trace+priority "cohort" idea (which
  carried into the TrafficClass/Priority model).
---

CASK Network Protocol v2: a never-implemented UDP protocol proposal evolving v1 toward fixed-offset framing, ed25519 session identity, and Dapper-style distributed tracing. Its header self-declares the document superseded: the shipped implementation uses the plaintext casksock wire format, the Noise-IK encryption layer, and encrypted session establishment instead. Captured here for three lineage reasons: the 60-byte fixed header (command/session/recipient/span/cohort) and 1026-byte depth+type+payload block framing it proposed (neither shipped); the signed-session-number / span / dual-purpose-cohort identity model; and the "Future Extensions" Layer 0-4 stack (block transfer → session/encryption → Merkle/filesystem → RPC/routing → orchestration/consensus) that became `architecture.md`. All sections carry `status: superseded`.

| Section | Topics | Status |
|---------|--------|--------|
| [changes-from-v1-and-layered-vision](../sections/cask--protocol2--changes-from-v1-and-layered-vision.md) | networking | superseded |
| [message-and-block-framing](../sections/cask--protocol2--message-and-block-framing.md) | networking, content-addressed-storage | superseded |
| [session-span-cohort-model](../sections/cask--protocol2--session-span-cohort-model.md) | networking | superseded |
