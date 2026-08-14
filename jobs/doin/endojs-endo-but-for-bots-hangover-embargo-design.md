---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: embargo outbound messages until a worker quiesces after delivery

Repo: endojs/endo-but-for-bots

Origin: review feedback on PR #124 (slot-machine wire protocol) by
@kriscendobot, review
https://github.com/endojs/endo-but-for-bots/pull/124#pullrequestreview-4941535335
The reviewer approved #124 and asked (top-level review body) for a
follow-up to address the **"hangover inconsistency"**: outbound messages
a worker emits should be **embargoed** (held) until the worker
**quiesces** after a message delivery, rather than being released while
the worker is still settling from delivering the previous message.

Task (designer): produce a design proposal for endo-but-for-bots that:
  - Defines the "hangover inconsistency" precisely: what state divergence
    or observable nondeterminism arises today when a worker emits
    outbound messages before it has quiesced following a delivery.
  - Specifies the embargo/quiescence mechanism: what "quiesce" means for
    a worker (e.g. drained microtask/turn queue, no pending promise
    reactions), when the embargo opens, and how buffered outbound
    messages are released in order once quiescence is reached.
  - Identifies the affected daemon/worker/supervisor components and the
    cross-supervisor (Rust+XS / SQLite parity) implications, so the
    behavior stays byte-for-byte consistent across supervisors.
  - Notes test/verification strategy (a reproduction of the current
    inconsistency + a regression guarding the embargo).

Deliverable: a design doc / proposal (and, if warranted, a build or
probe follow-up). Do NOT alter PR #124 — this is a separate follow-up
tracked from its review.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-14T22:17:56Z
