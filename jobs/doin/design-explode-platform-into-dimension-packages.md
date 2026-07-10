---
role: designer
---
<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-10T07:34:13Z -->

# Design (LOW PRIORITY): explode `@endo/platform` into focused per-dimension endo/exo package pairs

**Repo:** endojs/endo-but-for-bots, base `llm`. **Priority: low.** Deliverable: a
`designs/` doc that follow-up build/migration work executes.

## Goal

Split the monolithic `@endo/platform` package into **focused packages, one per
platform dimension** (`fs`, `cas`, `net`, `http`, …), each shipped as a **parallel
endo + exo pair**:

- `@endo/<dim>` — the plain/pure platform binding for that dimension (the "endo"
  package).
- `@endo/exo-<dim>` — the exo (object-capability facet) wrapper over it (the
  "exo" package).

E.g. `@endo/fs` + `@endo/exo-fs`, `@endo/cas` + `@endo/exo-cas`, `@endo/net` +
`@endo/exo-net`, `@endo/http` + `@endo/exo-http`, and so on for every dimension.

This follows the split precedent already in the tree: `@endo/http-confine` (pure
confinement core) vs `@endo/exo-http-client` (exo facet pair), and the
`@endo/agent-tools` mount-tools layering.

## Design questions the doc MUST resolve

1. **Enumerate the real dimensions.** From `@endo/platform`'s actual `exports` /
   `src` layout, list every dimension and its sub-variants (e.g. the `fs`
   dimension already has `lite` / `extended` tiers — `@endo/platform/fs/lite`,
   `@endo/platform/fs/extended`). Don't guess the set from this brief; derive it
   from source. Confirm the `net` vs `http` boundary and what `cas` (content-
   addressed store) contains.

2. **The endo/exo split per dimension — load-bearing.** Define precisely what
   belongs in the pure `@endo/<dim>` package (platform binding, pure logic, no exo
   machinery) vs. the `@endo/exo-<dim>` package (the `Far`/exo facet pair, confined
   interface, revocation/attenuation surface). Mirror the existing
   http-confine/exo-http-client division. `@endo/exo-<dim>` depends on
   `@endo/<dim>`.

3. **Compatibility during transition — must not break consumers.** `@endo/platform`
   and its `@endo/platform/<dim>/…` subpaths are imported across the monorepo
   (e.g. the daemon, agent-tools, mount). Specify how they keep resolving during
   the split: recommend `@endo/platform` becomes a **thin umbrella that re-exports**
   the focused packages (additive, zero-break), consumers migrate incrementally,
   and the umbrella's eventual removal is reserved for a **next-major** bump with a
   changeset note — consistent with the additive/phased discipline in
   `design-exports-extensionless-migration`.

4. **Package scaffolding & graph.** Per new package: `package.json` (exports,
   types, changeset), tsconfig wiring, the workspace dependency edges
   (`exo-<dim>` → `<dim>`; the umbrella → all), and how the daemon/agent-tools
   consumers are repointed. Note test relocation and that build/tsc/ava stay green
   per package.

5. **Execution decomposition.** Large multi-package refactor → run as an
   **orchestration** (per the standing decompose-multi-part rule): one child per
   dimension producing its endo+exo pair, plus a final umbrella-shim + consumer-
   repoint child. Additive umbrella first so nothing breaks mid-flight.

## Definition of done

A `designs/` doc that: enumerates the concrete dimensions from source (1), fixes
the endo/exo boundary per dimension (2), specifies the compat umbrella + next-major
removal policy (3), the per-package scaffolding and dependency graph (4), and the
orchestration plan (5) — concrete enough to execute as follow-up build tranches
with no further design decisions.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 15
  claimed_at: 2026-07-10T07:34:17Z
