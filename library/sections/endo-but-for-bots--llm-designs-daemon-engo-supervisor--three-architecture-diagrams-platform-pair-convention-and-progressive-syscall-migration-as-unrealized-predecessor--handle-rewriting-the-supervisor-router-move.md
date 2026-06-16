---
source: designs/daemon-engo-supervisor.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-engo-supervisor.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Not Started
genre: §endo-but-for-bots-design §unrealized-predecessor-of-cycle-176
cycle: 192
lane: designs
status: current
title: §Handle-rewriting (the supervisor router move)
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
daemon ──[N, verb, payload, rid]──► engo ──[1, verb, payload, rid]──► worker(N)
worker(N) ──[1, verb, payload, rid]──► engo ──[N, verb, payload, rid]──► daemon

Engo performs **handle rewriting** on forwarded messages:
when the daemon (handle 1) sends to worker N, engo delivers
the message to worker N with the handle field rewritten to 1
(the daemon's handle).  When worker N sends to handle 1 (the
daemon), engo delivers to the daemon with the handle field
rewritten to N.  This allows both sides to identify their
counterpart without an explicit sender field.
```

§The-§handle-rewriting move: each side sends to-the-handle-
of-the-target; engo delivers to-the-target-with-the-handle-
of-the-sender. §No-explicit-sender-field needed; §the-
asymmetry-of-the-rewrite-is-the-routing-information.

§Compare-to-cycle-176-endor-architecture's §three-worker-
platforms-with-byte-identical-CBOR-envelopes. §Cycle-176-uses
the same §handle-as-routing-key discipline. §Engo-cycle-192-
introduces it; endor-cycle-176-inherits-it.

§Compare-to-cycle-182-debugger's §`"debug"`-verb-same-in-
both-directions (§handle-rewriting-distinguishes-sender).
§Same-pattern-applied-to-debug-protocol.
