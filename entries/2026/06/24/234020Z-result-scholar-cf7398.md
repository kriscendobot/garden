---
ts: 2026-06-24T23:40:20Z
kind: result
role: scholar
project: cask
refs:
  - library/sources/cask--protocol.md
  - library/sources/cask--protocol2.md
  - library/sources/cask--protocol2-arch.md
---

# Scholar cask ingest cycle 9: the protocol family (protocol.md, protocol2.md, protocol2-arch.md)

Job `scholar-ingest-cask-8` (follow-on to `scholar-ingest-cask-7`, cycle 8). Ingested the cask `doc/design/` **protocol family**, completing the protocol picture (the net-* and cryptography docs were already in from cycle 7-8). All three files share the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (idempotency-checked against `origin/journal2`: none previously ingested).

## Sources ingested (3 docs, 7 sections)

- **`protocol.md`** (CASK Local Protocol `cask/sock`, casksock) → 3 sections, **`status: current`**. The plaintext, unencrypted, trusted local Unix-socket protocol for CLI-to-daemon traffic. Sections: `casksock-transport-and-message-types` (the twelve lowercase 4-byte commands), `message-and-block-formats` (byte-exact `stor`/`load`/`ackn` layouts + the 1024-byte body + 12-byte metadata footer block), `flow-reliability-and-security` (reliable retransmit-until-`ackn`, RTT-bounded batching, CoDel pacing, priority-boosted ACKs, local-socket security).
- **`protocol2.md`** (CASK Network Protocol v2) → 3 sections, **`status: superseded`**. Supersession judgment: the document **self-declares "SUPERSEDED" in its header — it was never implemented**. The shipped system uses casksock + Noise-IK casknet (`cask--net-crypto--*`, `cask--net-session-init-design--*`). Ingested as the historical record and the lineage origin of two shipped ideas: the Layer 0-4 "Future Extensions" stack (→ `architecture.md`) and the dual trace+priority **cohort** field (→ TrafficClass/Priority). Sections: `changes-from-v1-and-layered-vision`, `message-and-block-framing` (60-byte fixed header, 1026-byte depth+type+payload block — neither shipped), `session-span-cohort-model`.
- **`protocol2-arch.md`** (the design brief that requested protocol2) → 1 section, **`status: superseded`**. The prompt that asked for v2: fixed-offset command-first framing, TTL-as-relay-deadline translation, and naming the 64-bit trace-identifier-plus-priority field (answered "cohort"). Genesis record of the cohort concept.

## Concepts added (2)

- **`casksock-local-protocol`** — the current plaintext local protocol; sibling of `casknet-wire-protocol`.
- **`cask-protocol-v2-abandoned`** — the never-implemented v2 + its brief; carries a *Common confusions* note distinguishing the cask cohort field from Endo's `cohort-destruction`.

## Indexes touched

- `topics/networking.md` (+7 rows → 28) and `topics/content-addressed-storage.md` (+2 block-format rows → 40); both counts bumped in `topics/README.md`.
- `sources/README.md` (+3 cask rows). `concepts/README.md` (+2 rows). `keywords.md` (+19 lines: casksock/`cask.sock`/`casw`/`coll`/`ackn`/`nonc`, protocol2, cask cohort, etc.).
- `concepts/cohort-destruction.md` — added a *Common confusions* block pointing cask-cohort searchers at `cask-protocol-v2-abandoned`.

Note: `sections/README.md` is not enumerated for the cask corpus (topics/sources/concepts are the primary indexes), consistent with cycles 3-8.

## Remaining `doc/design/` backlog (follow-on posted: `scholar-ingest-cask-9`)

Not yet ingested (~17 docs): the data-structure cluster (`array-design`, `sorted-array-design`, `allocator-design`, `bigint-design`, `blob-design`, `dir-design`, `dir-design-v2`, `dir-benchmark`, `root-design`, `nursery`, `verbs`, `membertable-design`, `membership-next-steps`, `cluster-provisioning`), the meta docs (`status` shape-not-content, `style`, `todo`), and the comment-fragment sources (`cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, `net/`). The dir cluster still needs the v1-vs-v2 supersession judgment flagged in cycles 7-8.

Self-improvement: nothing this time. The cycle-7/8 working note (isolated worktree off `origin/journal2`, CAS-push loop, read `origin/journal2` rather than the stale local worktree) held up exactly; the self-declared-SUPERSEDED header made the supersession judgment unambiguous, which is the cleanest case and needs no new convention.
