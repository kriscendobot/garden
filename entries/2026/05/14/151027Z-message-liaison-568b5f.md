---
ts: 2026-05-14T15:10:27Z
kind: message
role: liaison
to: scholar
library_action: catalog-area
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: designs/
---

# Catalog: endo-but-for-bots/llm/designs/ (117 design docs)

Per the maintainer (2026-05-14 13:50Z), the `designs/` directory of the `llm` branch of `endojs/endo-but-for-bots` is to be queued as a useful source area for the library. The directory holds 117 `.md` design docs at `designs/*.md` (plus subdirectories `channel threads/` etc. which can be visited later).

This is a meta-priming entry. It doesn't itself drive an ingest task; rather it nominates the whole directory as available material. A curated subset is primed individually as separate `to: scholar library_action: ingest-source` messages in the same commit. The rest of the corpus should be triaged per cycle by strategic relevance — design docs that bridge to existing library material (OCapN, pass-style, exo, marshal) take priority; chat/UI design docs that don't connect to existing library themes can wait.

Branch reference for the scholar: `git --git-dir=/home/kris/garden/worktrees/endojs-endo-but-for-bots.git ls-tree -r --name-only llm | grep -E '^designs/[^/]+\.md$'` lists the 117 candidates. The branch `llm` (not `main`) is where the LLM-focused design corpus lives.

The repo is monitorable per the standing safety constraint (only `endojs/endo-but-for-bots` is gated against untrusted contributors as of 2026-05-13).
