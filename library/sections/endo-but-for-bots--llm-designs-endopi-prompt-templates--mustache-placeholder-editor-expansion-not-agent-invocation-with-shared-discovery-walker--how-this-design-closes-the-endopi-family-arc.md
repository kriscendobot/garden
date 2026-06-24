---
section: mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
source: endo-but-for-bots--llm-designs-endopi-prompt-templates
topics: [agent-conventions]
status: current
title: How this design closes the endopi-* family arc
parent: endo-but-for-bots--llm-designs-endopi-prompt-templates--mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
---

With this cycle, the endopi-* family is at **9/9 ingested**:

- cycle 112 — `endopi-skills-markdown-format.md`
- cycle 117 — `endopi-jsonl-transcript-format.md`
- cycle 121 — `endopi.md` (family keystone)
- cycle 122 — `endopi-edit-tool.md`
- cycle 124 — `endopi-iterative-compaction.md`
- cycle 126 — `endopi-stdio-rpc-bridge.md`
- cycle 128 — `endopi-provider-registry-and-oauth.md`
- cycle 129 — `endopi-extension-package-manifest.md` (the
  unifier)
- **cycle 131 (this cycle)** — `endopi-prompt-templates.md`

The family arc:

- **Keystone** (cycle 121, 583 lines) — *Reference* status,
  comparative analysis frame
- **Two-already-ingested-spinouts** (cycles 112 + 117) — *Proposed*
  status, both named keystone as Parent
- **Five-more-spinouts** (cycles 122 + 124 + 126 + 128 + 129 +
  131) — *Proposed* status (one *partially satisfied*), all
  named keystone as Parent
- **Unifier** (cycle 129) — the `endo` manifest key in
  package.json that consumes guests + skills + prompts +
  providers in one install

The family covers nine endopi-* design files (one keystone +
eight spinouts) ingested across nineteen cycles (112 → 131). Each
ingest *traced back to the keystone* and built on the prior
ingest's vocabulary.
