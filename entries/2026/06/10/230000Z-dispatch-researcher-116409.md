---
ts: 2026-06-10T23:00:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--116409
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4453991038
---

# dispatch: researcher — references for the PR #403 builder (subsume subsequent planning phases)

Precedence dispatch ahead of the builder for PR #403 per the
researcher-precedence rule. Maintainer directive (kriskowal at
2026-06-08T22:57:59Z, review `4453991038`):

> I would like to override the fixer's standing instructions.
> Please dispatch a builder to evolve this change to subsume
> the subsequent planning phases.

Plus one inline comment at `packages/exo-npm/README.md:53`
(id `3376818416`):

> The layering references will not stand the test of time.
> Please remove development procedural minutia.

## Scope of the research

PR #403 ("feat(registry-capability): EndoRegistry capability +
@registry special name (#358 layer 1)") implements Layer 1 of a
four-layer design from #358. The maintainer wants the builder
to **subsume the subsequent planning phases** — i.e., expand
the PR to incorporate layers 2-4.

The downstream **builder** needs to know:
- The four design documents (one per layer) so it can implement
  layers 2, 3, and 4 in addition to the existing layer 1.
- The existing layer 1 implementation surface so the builder
  knows what to build on.
- The exo-npm README's layering references so the inline ask
  can be addressed.
- Any cross-package consumers of the layer-1 surface.

In your `project/` worktree at `feat/registry-capability`:

1. **Read the four design documents** in `designs/`:
   - `designs/registry-capability.md` (layer 1 — already
     implemented in this PR; verify the implementation
     matches).
   - `designs/mvs-resolver.md` (layer 2 — the algorithm).
   - `designs/snapshot-mapper.md` (layer 3 — mount snapshot +
     ReadPowers).
   - `designs/daemon-worker-import-from-mount.md` (layer 4 —
     integration).
   Note: the design files may live on `llm` branch, not
   `feat/registry-capability`. Run `git ls-files designs/` to
   locate them; if not on this branch, `git show
   llm:designs/<file>` retrieves them.
2. **Map the existing layer-1 implementation surface**:
   - `packages/registry-capability/src/` — the four source
     files (`interfaces.js`, `reference-backend.js`,
     `store.js`, `errors.js`) per the PR body.
   - `packages/registry-capability/types.d.ts`
   - `packages/registry-capability/test/` — verify test shape.
   - `packages/registry-capability/package.json` — workspace
     declaration.
   Identify the exported surface (interfaces, factories,
   error classes).
3. **Map the layer 2-4 implementation surfaces** by reading
   each design's "Module structure" or equivalent section:
   - Layer 2 (mvs-resolver): identify the new package or
     module to be created, its responsibility (resolving
     module-version-sets against a registry), and its
     dependency on the layer-1 capability.
   - Layer 3 (snapshot-mapper): identify the mount-snapshot +
     ReadPowers structure (probably a new package), its
     consumption of the registry capability.
   - Layer 4 (daemon-worker-import-from-mount): the daemon /
     worker integration glue.
4. **Identify cross-package consumers of the layer-1
   capability**: `git grep` for imports of
   `@endo/registry-capability` outside `packages/registry-
   capability/` to surface any in-flight consumers (probably
   none on this branch yet).
5. **Locate `packages/exo-npm/README.md:53`** and read the
   layering-references / dev-minutia content the maintainer
   wants removed. Surface the exact lines so the builder
   knows what to edit and what the "stand the test of time"
   reframing should look like.
6. **Check for prior art**: any prior researcher / builder
   journal entries about this PR or the #358 design stack.
   `find /home/kris/journal/entries -name '*registry*' -o -name
   '*358*' -o -name '*403*'` and skim.
7. **Library / project references**: per the standard
   researcher output shape (see
   `garden/skills/library-lookup/SKILL.md` if useful),
   surface library and project references for capability-design,
   exo-style interfaces, CAS-store patterns, registry
   resolution, MVS / module-version-sets, snapshot-mapper /
   ReadPowers, daemon-worker integration.

## Output shape

Produce a `result` entry under `journal/entries/2026/06/10/`
with the standard `## Library and project references` section
the orchestrator inlines into the downstream builder brief.

In particular surface:

- The four design documents' summary (one short paragraph
  per layer; what the builder must implement).
- The layer-1 implementation surface (current file layout +
  exported surface).
- The layer-2/3/4 planned implementation surfaces
  (per-package layout + responsibility).
- The exo-npm README:53 content to address (verbatim if
  short; key lines if longer).
- Any prior journal entries to consult.
- Blockers / asymmetries / open questions for the builder
  (e.g., is layer 2 implementable now or does it depend on
  a yet-unmerged dep? Are layer 3 / 4 testable without a
  daemon harness? Etc.).

## Out of scope

- Do NOT propose the implementation.
- Do NOT touch the tree or push anything.
- Do NOT speculate beyond what the code/designs show; flag
  unknowns as open questions for the builder.

## Authorizations

Read-only.

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` with the
`## Library and project references` section ready for inlining
into the builder brief, plus the standard self-improvement
footer.

End your turn with a concise summary back to the orchestrator. The
orchestrator inlines your section into the builder dispatch and
tears down your dispatch root on return.
