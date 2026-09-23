---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
title: §Read-soft-write-hard discipline for escaping symlinks
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

| Method | Behavior on escaping symlink |
|--------|------------------------------|
| `list()` | §Silently-exclude from returned array |
| `has()` | Return `false` |
| `lookup()` | §Throw |
| `write()` / `remove()` / `move()` | §Throw |

§Read-soft-write-hard. §Reads-pretend-the-escape-doesn't-
exist; §writes-fail-explicitly.

§Why-soft-on-reads: §enumeration-doesn't-leak-existence-
beyond-the-boundary. A `list()` that *threw* on escapes
would let an attacker probe whether escapes exist by trying
operations. §Hidden-not-rejected for reads is the same
discipline as cycle-89's eventual-send pipeline observation
about §don't-let-error-paths-reveal-too-much.

§Why-hard-on-writes-and-lookup: §explicit-mutation-on-
imaginary-state-is-incoherent. The caller needs to know
whether the operation actually targeted anything.
