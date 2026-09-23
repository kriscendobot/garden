---
ts: 2026-06-02T21:19:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--c1e88a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: source-design (merged at c85d618df)
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/358
---

# dispatch: builder — implement layer 1 (registry-capability) per #358 merged design

kriskowal APPROVED #358 at 20:48:19Z with body "Please conduct to llm
branch and dispatch builder." Conductor merged #358 to `llm` at merge
commit `c85d618df` per earlier dispatch (entries/2026/06/02/210100Z).

This dispatch executes the "and dispatch builder" half. Scope: layer 1
of the merged stacked design — the foundation that the other three
layers depend on.

## Design references (now on llm)

- `designs/registry-capability.md` — **this dispatch's scope.** Defines
  the `EndoRegistry` daemon capability and the `@registry` host special
  name.
- `designs/mvs-resolver.md` — layer 2; depends on registry-capability.
  NOT in scope for this builder.
- `designs/snapshot-mapper.md` — layer 3; depends on registry-capability.
  NOT in scope.
- `designs/daemon-worker-import-from-mount.md` — layer 4 integration.
  NOT in scope.

## Scope — phase-1 foundation

Implement the layer-1 foundation:

1. **EndoRegistry capability shape.** Define the TypeScript / JS
   capability shape (the interface that crosses the worker boundary):
   resolution input (package.json subset + flags), resolution output
   (`RegistryResolution` — package metadata + content-addressed tarball
   ref), failure types via `@endo/errors` per the design's "failure
   surface that distinguishes tampering, missing packages, network
   errors, and offline-mode misses".

2. **`@registry` special name.** Wire the capability into the daemon's
   host formulation as the required `@registry` slot, mirroring the
   `@node` precedent named in the design's Summary.

3. **JS reference backend scaffolding.** Set up the directory and
   package skeleton for the JS reference backend (no MVS algorithm —
   that's layer 2's job). Backend reads package.json, delegates to a
   `resolve()` hook (stub for layer 2 to fill in), and produces the
   `RegistryResolution` shape with CAS-addressed contents.

4. **CAS-backed store interface.** Define the CAS store interface
   (read/write/has by content hash) and the bus verbs the capability
   uses, per the design's "write CAS trees through the same bus verbs"
   point. Actual storage implementation can be a Map-based stub for
   this builder; persistent storage can land in a follow-up.

5. **Caching and retention** (light pass). Per the design's
   "bounded-growth CAS retention story" — at minimum a typedef'd
   `retentionLinks: WeakSet<...>`-style hook so the formula graph can
   pin entries. Full eviction policy can land in a follow-up.

## Out of scope

- MVS resolution algorithm (that's layer 2; stub the `resolve()` call).
- Snapshot mapping (that's layer 3).
- daemon-worker entry point integration (that's layer 4).
- Rust backend wrapper around endor-npm-registry-proxy (future).
- Persistent CAS storage (use an in-memory Map for now).
- Real SQLite registry table (future, with the Rust backend).

## Procedure

1. Read `designs/registry-capability.md` end-to-end before opening any
   code editor.
2. Read the `garden/roles/builder/AGENT.md` and the
   `garden/skills/stacked-pr-build/SKILL.md` (since the four-layer
   design is a stacked build).
3. Identify where in the endo-but-for-bots monorepo the
   registry-capability package should live (likely
   `packages/registry-capability/` or under a daemon-specific
   directory). Surface this as a clarifying question in the PR body if
   not obvious from the design.
4. Implement the five scope items above. Add tests (the
   `coverage-driven-testing` skill applies).
5. Open the PR DRAFT against base `llm` from a branch named e.g.
   `feat/registry-capability`. Title:
   ```
   feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1)
   ```
   PR description should:
   - Cite #358 and the four layered designs.
   - List clarifying questions discovered during implementation.
   - List what is in scope (layer 1) and what is deferred (layers 2-4).

## Per-action authorizations

- All builder-standard implementation operations. Authorized.
- Open DRAFT PR against `llm`. Authorized.
- Add tests. Authorized.
- Push to a new branch (e.g. `feat/registry-capability`). Authorized.

## Not authorized

- Touching files in layers 2-4 scope (mvs-resolver, snapshot-mapper,
  daemon-worker-import-from-mount).
- Un-drafting (steward survey or maintainer un-drafts after review).
- Force-pushing.
- Merging.

## Dispatch protocol

Read in order:
1. garden/roles/COMMON.md
2. garden/roles/builder/AGENT.md
3. garden/skills/stacked-pr-build/SKILL.md
4. Other skills just-in-time (gap-revealing-build, coverage-driven-testing, etc.).

Project worktree on `llm` at `c85d618df`.

## Report

A `result` journal entry. Include: branch name, head SHA, opened PR
number, files added/changed with counts, the PR body's clarifying
questions, test coverage notes, and any deviations from this scope.
