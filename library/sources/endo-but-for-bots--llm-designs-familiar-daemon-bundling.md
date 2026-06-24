---
source: designs/familiar-daemon-bundling.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-05
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-ninth endo-but-for-bots design ingest. **Status:
  Complete**. The 161-line design documents *daemon-bundling* for
  the Familiar Electron application — *self-contained artifact
  that can be spawned with a bundled Node.js executable on the
  user's platform*. Cycle 113 ingests this as the **second** of
  cycle 109's three named dependencies (cycle 111 was the first,
  familiar-gateway-migration; cycle 109's third dependency,
  familiar-unified-weblet-server, remains queued).
  
  Three structurally interesting moves: (1) the *two-option-
  exploration-with-preferred-choice* — Option A (single-file
  esbuild bundle) vs Option B (packaged directory); preferred A
  with explicit trade-off (simplicity vs bundle size);
  (2) the *three-challenges-with-three-mitigations* — dynamic
  `import()` for runtime-loaded user code + SES `lockdown()`
  global side effects + OCapN-Noise WASM co-location — each
  challenge has a named mitigation; (3) the *worker-resolve-
  relative-to-bundle-location* discipline via `new URL('./endo-
  worker.cjs', import.meta.url).pathname` — the daemon doesn't
  search PATH; the worker entry sits next to the daemon bundle.
  
  The §compatibility-invariant *the bundled daemon must produce
  the same Unix socket protocol, CapTP messages, and persistence
  format ... It's the same code, just packaged differently* +
  shared state directory `~/.local/state/endo/` make the bundled
  daemon *interchangeable with the development daemon* —
  supporting cycle 109 Familiar's *play well with existing
  daemons* discipline.
  
  Single-section cohesion-honest ingest. The §Dependency declared
  as *None (can proceed independently of other Familiar work
  items)* — foundational design with no upstream in the Familiar
  family.
---

> Abstract: `designs/familiar-daemon-bundling.md` documents the
> *daemon-bundling* shape for the Familiar Electron application
> — a *self-contained artifact that can be spawned with a
> bundled Node.js executable on the user's platform*. The §four
> requirements: (1) run with standalone Node.js binary, not the
> monorepo; (2) all `@endo/*` deps bundled or co-located; (3)
> worker processes spawnable from the bundle; (4) platform-
> specific native modules handled. The §two-option bundle
> strategy: Option A *Single-file bundle (preferred)* via
> esbuild produces a single `.cjs`; Option B *Packaged directory*
> copies daemon + node_modules. The §three challenges for Option
> A: dynamic `import()` for workers/weblets/guest code can't be
> statically bundled; SES `lockdown()` global side effect; WASM
> co-location. The §three mitigations: separate-artifact bundling
> of worker entry + SES shim; main bundle excludes dynamically-
> loaded user code; WASM copied alongside. The §worker-resolve
> discipline via `new URL('./endo-worker.cjs',
> import.meta.url).pathname`. The §Node.js executable matrix
> (macOS arm64/x86_64, Linux x86_64/arm64, Windows x86_64). The
> §launch command: `<familiar-resources>/node
> <familiar-resources>/endo-daemon.cjs <sock-path> <state-path>
> <ephemeral-state-path> <cache-path>`. The §five-file `dist/`
> build artifacts. The §50MB size target (Node.js ~40MB + daemon
> ~10MB). The §Compatibility invariant: *It's the same code,
> just packaged differently*; shared state directory
> `~/.local/state/endo/` makes the bundled daemon
> *interchangeable with the development daemon*. The §Dependency
> *None (can proceed independently of other Familiar work
> items)* — foundational with no upstream in the family.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [single-file-bundle-with-worker-entry-and-platform-node](../sections/endo-but-for-bots--llm-designs-familiar-daemon-bundling--single-file-bundle-with-worker-entry-and-platform-node.md) | daemon | current |

The 161-line file is honestly one cohesive argument-cluster — *one packaging design* with Problem framing + two-option strategy + three-challenges-three-mitigations + worker resolution + Node.js executable + build artifacts + Security/Scaling/Test/Compatibility/Upgrade considerations. Single-section ingest preserves the unified structure.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-03-05 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 161 lines.
- **Twenty-ninth endo-but-for-bots design ingest**. Cycle 113 ingests this as the **second** of cycle 109's three named dependencies (cycle 111 was the first, familiar-gateway-migration; cycle 109's third dependency, familiar-unified-weblet-server, remains queued).
- Cycle 113 was scheduled for chat-lane (exhausted) and pivoted to familiar-design-lane continuing the cycles 109 + 111 pattern.
- Single-section cohesion-honest count. The 161-line file is *one unified packaging design* with Status block, Problem framing, seven design subsections, and Considerations.
- The §Familiar dependency triangle is now 2/3 complete (familiar-gateway-migration cycle 111 + familiar-daemon-bundling cycle 113 + familiar-unified-weblet-server queued).
