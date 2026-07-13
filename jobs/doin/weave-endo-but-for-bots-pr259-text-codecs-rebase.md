---
role: weaver
---

Weave (rebase onto current `master`) `endojs/endo-but-for-bots#259` ("feat(ses): permit TextEncoder and TextDecoder as universal intrinsics", head `feat/hardened-text-codecs-shim`), which fully implements the M2 hardened-text-codecs-shim design but is now `CONFLICTING`/`DIRTY` after base drift; resolve conflicts against `master`, preserve the net diff, and keep CI green so the PR is mergeable.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  claimed_at: 2026-07-13T00:35:26Z
