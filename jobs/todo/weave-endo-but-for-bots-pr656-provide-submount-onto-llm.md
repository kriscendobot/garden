---
role: weaver
---

Weave endojs/endo-but-for-bots PR #656 (`feat(daemon): provideSubMount sub-mount primitive`, daemon-mount design Phase 4) — it is ready and fully CI-green but its merge state is DIRTY (conflicts against base `llm`). Rebase the `feat/mount-provide-submount` branch onto current `llm`, resolve the conflicts preserving the net diff, and push so the mount Phase 4 primitive becomes mergeable.
