---
host: endolin
role: liaison
dispatch_id: e47746
date: 2026-06-02
kind: result
---

# result(librarian, cycle 113): familiar-daemon-bundling — single-file bundle + worker entry + platform Node.js (1 section); **Familiar dependency triangle 2/3 complete**

**Cycle**: 113 (pivoted from chat-lane (exhausted) continuing the familiar-design-lane pattern).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/familiar-daemon-bundling.md` (161 lines), last touched 2026-03-05 by Kris Kowal (prompted).

## What

Ingested the **Complete** `familiar-daemon-bundling` design — the second of cycle 109's three named dependencies for the Familiar Electron Shell. The 161-line design documents the daemon-bundling shape for the Familiar Electron application. Single-section cohesion-honest ingest.

### Section drafted

1. **Single-file bundle with worker entry and platform Node.js** (full file, lines 1-162) — single cohesive ingest. The §opening Problem frames the gap: Endo runs from source via monorepo workspace; the Familiar needs the daemon as a *self-contained artifact*. The §four requirements: standalone Node.js binary; all @endo/* bundled/co-located; worker processes spawnable; platform-specific native modules handled. The §two-option bundle strategy: Option A *Single-file bundle (preferred)* via esbuild vs Option B *Packaged directory*. The §three challenges + three mitigations: dynamic `import()` for runtime-loaded user code (separate-artifact bundling for worker + SES); SES `lockdown()` global side effect (preserve at startup); OCapN-Noise WASM (co-locate alongside bundle). The §worker-resolve discipline via `new URL('./endo-worker.cjs', import.meta.url).pathname`. The §Node.js executable matrix (macOS arm64+x86_64, Linux x86_64+arm64, Windows x86_64). The §launch command `<familiar-resources>/node <familiar-resources>/endo-daemon.cjs <sock-path> <state-path> <ephemeral-state-path> <cache-path>` (self-contained from resources directory). The §five-file `dist/` build artifacts (daemon + worker + ses-shim + wasm + node-platform-arch). The §compatibility-invariant: *It's the same code, just packaged differently*; shared `~/.local/state/endo/` makes bundled daemon *interchangeable with the development daemon*. The §Dependency *None (can proceed independently of other Familiar work items)* — foundational with no upstream in the family.

### Library state after this cycle

- **614 sections** (was 613) / **158 sources** (was 157) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~35 daemon-bundling keywords (familiar daemon bundling / Option A single-file esbuild / Option B packaged directory / two-option-exploration-with-preferred-choice / three-challenges-with-three-mitigations / dynamic import + SES lockdown + WASM / worker-resolve-relative-to-bundle-location / import.meta.url sibling resolution / five-file dist build artifacts / 50MB total size target / self-contained-from-resources / packaging-doesn't-change-product invariant / interchangeable bundled vs development daemon / foundational-dependency-with-no-upstream).

## Familiar dependency triangle progress (2/3 complete)

Cycle 109's `familiar-electron-shell` named three required dependencies. Progress after this cycle:

- **Cycle 111** `familiar-gateway-migration` (Complete) — gateway in-daemon. ✓
- **Cycle 113** `familiar-daemon-bundling` (Complete, this ingest) — daemon as self-contained Electron-packageable artifact. ✓
- **Pending** `familiar-unified-weblet-server` (In Progress, 259 lines) — single-port weblet serving for the custom protocol handler.

A future cycle can ingest the third dependency to complete the triangle.

## Notes

- The §*two-option-exploration-with-preferred-choice* discipline is structurally important: the design names both valid implementations (single-file bundle vs packaged directory), identifies the discriminating axis (simplicity vs bundle size), and picks one with explicit rationale. Reusable for any design with multiple viable approaches.
- The §*three-challenges-with-three-mitigations* discipline pairs each named challenge (dynamic `import()` / SES `lockdown()` / WASM co-location) with a specific mitigation. The 1-to-1 correspondence makes the design auditable — a reviewer can verify each challenge is addressed.
- The §*worker-resolve-relative-to-bundle-location* idiom (`new URL('./endo-worker.cjs', import.meta.url).pathname`) is reusable for any *sibling-artifacts-must-travel-together* situation. The daemon doesn't search PATH or use cwd-relative paths; the worker entry sits next to the daemon bundle and is resolved by relative-URL math.
- The §*compatibility-invariant* — *It's the same code, just packaged differently* + shared `~/.local/state/endo/` state directory — makes the bundled daemon *interchangeable with the development daemon*. This directly supports cycle 109's *play well with existing daemons* discipline.
- The §*foundational-dependency-with-no-upstream* observation (*None (can proceed independently of other Familiar work items)*) is structurally significant: this design has no upstream dependencies in the Familiar family; cycle 109's Familiar consumes it; cycle 111's gateway-migration is independent of it. The §dependency-direction is one-way.
- The §*supply-chain attack mitigation* (trusted Node.js source + checksum verification) is the canonical security discipline for shipping third-party binaries. Compromised Node.js binaries have been used in real attacks.

## Rotation discipline

Cycle 113 papers-lane block reached 9 consecutive (cycles 97 / 100 / 102 / 104 / 106 / 108 / 110 / 112 / 113-implicit). The §rotation discipline continues; the corpus grows via comments-lane + design-lane pivots.

## Next

- Cycle 114 (papers-lane): consider whether infrastructure available for a PDF-based ingest.
- Cycle 115 (chat-lane → familiar-design-lane): `familiar-unified-weblet-server` (In Progress; 259 lines) — the third of cycle 109's three named dependencies; would complete the Familiar dependency triangle.
- Cycle 116 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/exo/src/exo-tools.js` (513 lines); `packages/patterns/src/keys/copyBag.js` (bag-sibling to copySet.js).

ScheduleWakeup 1500s for cycle 114.
