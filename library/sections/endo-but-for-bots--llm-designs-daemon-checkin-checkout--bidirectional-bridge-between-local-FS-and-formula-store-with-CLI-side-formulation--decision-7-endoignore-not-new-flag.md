---
source: designs/daemon-checkin-checkout.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-checkin-checkout.md
source_path: designs/daemon-checkin-checkout.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 168
lane: designs
status: current
title: §Decision-7-.endoignore-not-new-flag
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> *Rather than inventing a new flag syntax for exclusion
> patterns, checkin respects a `.endoignore` file
> (`.gitignore` syntax) in the root directory.*

§Reuse-familiar-discipline. §.gitignore-syntax-is-known-
by-every-developer. §No-new-mini-language-to-learn.

§.git-directories-always-ignored regardless of .endoignore
— §common-and-large; §sane-default.

§Composability-with-existing-tooling: the same `.gitignore`
patterns work for both Git and Endo. §Don't-fight-the-
ecosystem.
