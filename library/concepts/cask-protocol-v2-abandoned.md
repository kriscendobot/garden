---
id: cask-protocol-v2-abandoned
aliases: ["cask protocol v2", "protocol2", "PROTOCOL2", "protocol2-arch", "cask network protocol v2", "cohort field", "cask cohort", "trace identifier and priority", "regular block framing", "1026-byte block", "depth type payload block"]
topics: [networking]
status: current
---

# cask-protocol-v2-abandoned

CASK Network Protocol v2: a proposed UDP protocol (and the design brief that requested it) that was **never implemented**. `protocol2.md` self-declares "SUPERSEDED" in its header; the shipped system uses the plaintext casksock format (`[[casksock-local-protocol]]`), the Noise-IK encryption layer (`[[noise-ik-session-establishment]]`), and the encrypted casknet wire protocol (`[[casknet-wire-protocol]]`) instead. v2 proposed a 60-byte fixed header (4-byte command, 8-byte session, 32-byte recipient ed25519 key, 8-byte span, 8-byte cohort) followed by message-specific fixed fields and variable data last, plus a "regular framing" 1026-byte block (1 byte depth + 1 byte type + 1024-byte payload) — neither shipped (the actual block is a 1024-byte body with a separate 12-byte footer). Three v2 ideas did carry forward: the Layer 0-4 stack in its "Future Extensions" section became `architecture.md`'s casknet layering; the dual-purpose **cohort** field (a single 64-bit integer that is both a Dapper-style trace identifier and a priority, with low bits randomly distributed so packets sharing a trace fail together under relay saturation) is the lineage ancestor of the shipped TrafficClass/Priority model; and `protocol2-arch.md` is the brief that named that field.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--protocol2--changes-from-v1-and-layered-vision](../sections/cask--protocol2--changes-from-v1-and-layered-vision.md) | v2 motivation, the four improvements, no-backward-compat, and the Layer 0-4 future-extensions vision. |
| [cask--protocol2--message-and-block-framing](../sections/cask--protocol2--message-and-block-framing.md) | The 60-byte fixed header, STOR/LOAD formats, and the 1026-byte depth+type+payload block framing. |
| [cask--protocol2--session-span-cohort-model](../sections/cask--protocol2--session-span-cohort-model.md) | Signed session numbers, per-session spans, and the dual trace+priority cohort. |
| [cask--protocol2-arch--design-brief](../sections/cask--protocol2-arch--design-brief.md) | The prompt that requested v2: fixed-offset framing, TTL-as-relay-deadline, and naming the cohort field. |

## See also

- [[casksock-local-protocol]] — the **current** local protocol v2 would have evolved (uppercase `STOR`/`LOAD` vs casksock's lowercase).
- [[casknet-wire-protocol]] — the **shipped** encrypted inter-node protocol that v2's session/encryption layer was eventually realized as.
- [[codel-send-buffer-shedding]] — the shipped TrafficClass/Priority scheduling that the v2 cohort idea fed into.

## Common confusions

- The cask **cohort** field here (a UDP-packet 64-bit trace identifier doubling as a priority) is unrelated to Endo's `[[cohort-destruction]]` (the daemon's partition-response "destruction by cohort"). Same word, different domain: cask = networking telemetry/priority; Endo = capability-graph GC grouping.
