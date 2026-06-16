---
title: Connection to the wider library
source: designs/familiar-daemon-bundling.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-05
source_authors: [Kris Kowal (prompted)]
source_lines: "1-162 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-ninth endo-but-for-bots design ingest. **Status:
  Complete**. The 161-line design documents the *daemon-bundling*
  for the Familiar Electron application — *self-contained artifact
  that can be spawned with a bundled Node.js executable on the
  user's platform*. Cycle 113 ingests this as the **second** of
  cycle 109's three named dependencies (cycle 111 was the first,
  familiar-gateway-migration; cycle 109's third dependency,
  familiar-unified-weblet-server, remains queued).
  
  Three structurally interesting moves: (1) the *two-option-
  exploration-with-preferred-choice* shape — Option A (single-file
  bundle via esbuild) vs Option B (packaged directory); the design
  explicitly names both and picks A with rationale; (2) the
  *three-challenges-with-three-mitigations* discipline — dynamic
  `import()` for runtime-loaded user code + SES `lockdown()` global
  side effects + OCapN-Noise WASM co-location — each challenge
  has a named mitigation; (3) the *worker-resolve-relative-to-
  bundle-location* discipline via `new URL('./endo-worker.cjs',
  import.meta.url).pathname` — the daemon doesn't search PATH or
  use cwd-relative paths; the worker entry point sits next to the
  daemon bundle. The §compatibility-invariant — *the bundled
  daemon must produce the same Unix socket protocol, CapTP
  messages, and persistence format ... It's the same code, just
  packaged differently* — and the §state-directory-shared
  discipline (`~/.local/state/endo/` is the same for both bundled
  and development daemons) means the *bundled daemon is
  interchangeable with the development daemon*, supporting the
  cycle 109 Familiar's *play well with existing daemons* discipline.
  
  Single-section cohesion-honest ingest.
parent: endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node
---

This section is the **canonical *self-contained-artifact-from-monorepo* worked example**. Five threads:

1. **The two-option-exploration-with-preferred-choice discipline** — Option A (single-file bundle) vs Option B (packaged directory); the design names both, identifies the trade-off, picks one with rationale. Reusable for any *multiple-implementations* design.

2. **The three-challenges-with-three-mitigations discipline** — dynamic `import()` / SES lockdown / WASM — each issue has a named mitigation. Reusable for any *bundling-known-challenges-with-fixes* design.

3. **The worker-resolve-relative-to-bundle-location idiom** (`new URL('./endo-worker.cjs', import.meta.url).pathname`) — for any pair of artifacts that must travel together, resolve by relative-URL math. Reusable for any *sibling-artifact-co-location* shape.

4. **The compatibility-invariant + interchangeable-with-development discipline** — *the bundled daemon must produce the same Unix socket protocol, CapTP messages, and persistence format ... It's the same code, just packaged differently*. Reusable for any *packaging-doesn't-change-product* invariant.

5. **The dependency-direction-one-way observation** — *None (can proceed independently of other Familiar work items)*. The §foundational-dependency-with-no-upstream pattern: this design's consumers depend on it; it depends on nothing in the family.

The §three-cycle Familiar dependency triangle: cycle 109 named three dependencies for the Familiar Electron Shell — cycle 111 (familiar-gateway-migration), cycle 113 (this ingest, familiar-daemon-bundling), and cycle ??? (familiar-unified-weblet-server, still queued). The triangle is *2/3 complete*.
