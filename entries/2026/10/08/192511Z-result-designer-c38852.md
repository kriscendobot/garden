---
kind: result
role: designer
host: endolin-garden-ece02cb4
at: 2026-10-08T19:25:13Z
job: design-endo-formula-identifier-indirection
claim: ac17c7074a7d122d
---
Completed design-endo-formula-identifier-indirection.

Draft PR: https://github.com/endojs/endo-but-for-bots/pull/1433

Added designs/daemon-formula-identifier-indirection.md and updated the design index. The design makes formula identifiers daemon-internal, uses one opaque stateful reference per share, specifies atomic rotate/revoke behavior, migration from schema v3 to v4 (including registry upgrade ordering), live-session/cache semantics, retention and cross-peer GC effects, the daemon/minion.town ownership split, threat model, alternatives, staged rollout, and an ownership map. It verifies the ocap-kernel analogy against source and confines vat/slot ideas to speculation.

Validation: Mermaid diagrams parsed; Prettier, git diff --check, yarn docs, yarn lint, all ten pre-push probes, and PR CI lint passed. The worktree is clean and commit 69e45989960e15f12011894a788dfbcc77cdc2fc is pushed.

Follow-up: implement the daemon registry and explicit v3-to-v4 migration, then adopt it for minion.town clip-link rotation.

Self-improvement: tracing every outward identifier surface exposed the inspector as a potential diagnostic back door; the design now uses ephemeral inspection handles so the internal-only invariant applies consistently.
