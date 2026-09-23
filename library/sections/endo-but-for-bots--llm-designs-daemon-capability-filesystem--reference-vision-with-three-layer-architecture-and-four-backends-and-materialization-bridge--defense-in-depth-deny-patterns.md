---
source: designs/daemon-capability-filesystem.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-capability-filesystem.md
source_path: designs/daemon-capability-filesystem.md
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
cycle: 170
lane: designs
status: current
title: §Defense-in-depth deny patterns
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *As a secondary safety net, the physical backend may
> apply hardcoded deny patterns to catch mistakes in VFS
> construction.*

§Two-tier-defense:

1. **§Primary**: §structural-confinement-via-selective-
   mounting (the Bazel property).
2. **§Secondary**: §hardcoded-deny-patterns at backend
   level (`**/.ssh/**`, `**/.aws/**`, `**/.env`,
   `**/*.pem`, etc.).

§Why-secondary-not-primary: structural confinement is *the*
defense; deny patterns catch §granting-mistakes. If a host
accidentally mounts `$HOME` instead of `$HOME/project`,
deny patterns block access to `.ssh/` etc.

§Backend-level-not-Dir-exo-level — §cannot-be-circumvented-
by-the-guest.

§Non-physical-backends-don't-need-these-patterns: they
contain only what was explicitly placed. §The-defense-is-
specific-to-physical-backing.

§Configurable-by-host: a credential-management agent
might legitimately need `.ssh/` access. §Sensible-default-
but-overridable.
