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
title: §progressive-syscall-migration with §named-priority-order
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
| Syscall | Replaces | Rationale |
|---------|----------|-----------|
| `fs.read` / `fs.write` | `node:fs` | Most impactful; enables Go-side caching and access control |
| `net.listen` / `net.connect` | `node:net` | Enables Go-side socket management |
| `crypto.random` / `crypto.hash` | `node:crypto` | Small surface, easy to verify |
```

§Three-syscalls in §suggested-priority-order (most-impactful
first; smallest-surface last for verification). §Each-syscall
follows-the-same-four-step-pattern:

1. §Define-the-verb-and-payload-schema.
2. §Implement-the-handler-in-Go.
3. §Replace-the-Node.js-call-in-the-`-go-powers.js`-module-
   with-an-envelope-send.
4. §Test-that-the-daemon-functions-identically.

§The-§"This phase is unbounded — it proceeds as far as is
useful without requiring completion" is the §named-open-
ended-migration discipline.

§Compare-to-cycle-180-hex-package's §five-phases-mostly-S
(four-step-per-syscall mirrors five-phase-per-package). §Both-
are-§canonical-migration-rhythm patterns.

§The-§Most-impactful-first ordering inverts cycle 186-break-
dev-deps' §smallest-to-largest order. §Different-disciplines:
cycle 192's syscalls are §independent + §ordered-by-impact;
cycle 186's cuts are §independent + §ordered-by-diff-size-for-
review-ease.
