---
title: Open questions
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions
---

The design lists several questions not yet settled, of which two are
worth surfacing for downstream design conversations:

- Should `epithets()` and `verify()` join `HandleInterface` directly,
  or live in a separate optional facet (`EpithetInterface`)? Adding
  to Handle is simpler; a separate facet avoids changing the existing
  interface for Handles that do not participate in delegation.
- How does verification work across OCapN node boundaries? The
  verifier needs to reach the principal's Handle, which may be on a
  remote node. The cross-node story interacts with the per-agent
  keypair work ([[per-agent-keypair]]) and per-agent NETS work
  ([[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]).
