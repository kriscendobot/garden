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
title: §Eight Design Decisions enumerated
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

1. §Two-formula-types-rather-than-one (lifecycle clarity).
2. §No-mount-method-on-the-exo (host avoids GC races).
3. §readOnly-IS-on-the-exo (no new formula, no GC race).
4. §lookup-returns-transient-exos (formula-store hygiene).
5. §Symlink-confinement-at-operation-time (TOCTOU
   mitigation).
6. §..-is-clamped-not-rejected (POSIX-ergonomic for
   mechanical path construction).
7. §Scratch-mount-directories-survive-cancellation
   (agent-workspace persistence).
8. §Path-based-not-inode-based-with-named-openat-future-
   work (honest-limitation-disclosure).

§Decisions-are-numbered-each-named-rationale. §Decision-2-
and-3-are-load-bearing-symmetry (creates-formula vs not).
§Decision-5-and-1-anchor-security. §Decision-8-is-§future-
hardening-target.
