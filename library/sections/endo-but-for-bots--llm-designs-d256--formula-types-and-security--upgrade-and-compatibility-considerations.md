---
title: Upgrade and compatibility considerations
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-d256--formula-types-and-security
---

- **State purge required.** `rm -rf ~/.local/state/endo/
  ~/.config/endo/`
- **No automatic migration.** Manual state purge required. Future
  work may provide migration tooling.
- **Network protocol unchanged.** OCapN-Noise already uses Ed25519
  keys — this migration aligns the daemon-internal ID scheme with
  what the wire already carried.
- **API stability.** The daemon API returns identifiers; callers
  should *not* assume identifier length. TypeScript branded types
  enforce this — code that previously held a 128-char hex string
  unbranded would compile-error if it tried to mix lengths post-
  migration.
- **Documentation update.** Any user-facing documentation that
  references identifier format or length needs updating.
