---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Target project: `endojs/endo-but-for-bots` (bot-fork roadmap branch `llm`).

## Directive (kriskowal, 2026-08-25, verbatim)

"It occurred to me this morning that we ought to model the npm registry not
as a bespoke Exo, but as an Endo directory tree. The root would be a
directory containing an npm directory and allowing for other registries to
be named later. The npm directory would be a non-enumerable hub for each of
the packages and org/packages in npm. Each package would have a listable
directory of all the versions published. This interface would generalize
such that the npm registry could be mocked trivially from a readable tree,
and such that we can name other registries, and even extend the concept of
package addressing in the future, with our own
`endor:swissnum@hint@hint/version` protocol in the future."

Propose this evolution of the existing npm registry work **on all Endo
platforms including endor and the Node Endo daemon** — i.e., both backends
must expose the identical directory-tree shape, not just one of them.

## Library and project references (floor, not ceiling — consult first)

The npm-registry arc has two layers, at very different maturity, and this
proposal is squarely about ONE of them:

- **`designs/registry-capability.md`** — the current **capability-layer**
  design: `EndoRegistry` as a bespoke method-call interface
  (`resolve()`/`fetch()`/`lookup()`/`list()`), the `@registry` host special
  name, and the explicit goal that a Node-JS backend and a future Rust
  backend both produce the same shape so callers can't tell which resolved
  a request. **Status: Not Started** — nothing has been built against this
  shape yet, so there is a clean landing spot for a redesign before any
  consumer locks in the bespoke-Exo interface. This is the doc your proposal
  most directly targets/supersedes.
- **`designs/endor-npm-registry-proxy.md`** — the **mechanics layer**:
  SQLite `RegistryTable`, MVS resolution, tarball fetch + CAS ingest,
  npmrc auth, `endor run`/`endor npm-resolve` (`rust/endo/src/registry.rs`,
  `fetch.rs`, `semver.rs`, `npm_resolve.rs`, `assemble.rs`, `execute.rs`,
  `npmrc.rs`). **Status: all 5 phases implemented and demonstrated
  end-to-end** (fresh-state fetch → CAS → SQLite → XS execution, offline
  replay from cache, `registry verify` clean). **Do not propose redoing
  this working machinery** — the new directory-tree interface should be a
  reshaped *presentation* over it (or a thin adapter), not a replacement
  for the resolve/fetch/CAS mechanics. Several review PRs sit on top of this
  layer (peer/optional deps, workspaces, npmrc auth, imports field,
  execution refinements) — note in the design whether/how they're affected
  by a capability-shape change.
- **`designs/mvs-resolver.md`**, **`designs/snapshot-mapper.md`**,
  **`designs/daemon-worker-import-from-mount.md`**,
  **`designs/endor-registry-proxy-worker.md`** — the algorithm, the
  tree-mapping/`EndoReadableTree` consumer, and the daemon-worker
  integration point the capability shape must still serve.
- **Directory-tree precedent already established in this codebase** — this
  is not a novel pattern, which strengthens the case: `designs/endo-fs-from-git.md`
  (a git repo modeled as a readable tree), `designs/exo-zip-package.md` (a
  zip archive modeled as a tree), `designs/fs-interface-consolidation.md`
  and `designs/fs-interface-reconciliation.md` (the general effort to make
  different tree *sources* interchangeable behind one FS interface),
  `designs/platform-range-and-tree-reads.md`, and the concrete
  `packages/daemon/src/directory.js` Exo implementation. Read these first —
  they may already define most of the tree-node/directory vocabulary this
  proposal needs, and the design should reuse it rather than inventing a
  parallel shape. If the registry tree can be expressed as "just another"
  source behind the fs-interface-consolidation effort, say so explicitly;
  if it needs a genuinely new tree-node capability (the non-enumerable-hub
  behavior npm's own registry has no real equivalent for), name exactly
  what's new.

## What the design needs to work out

1. **The tree shape.** Root directory → `npm/` (non-enumerable: you must
   know a package/org name to reach it, mirroring npm's own registry, which
   has no "list everything" endpoint) → per-package directory (listable:
   enumerating a package's directory lists its published versions) → a
   version entry resolving to the package contents (presumably the existing
   CAS readable-tree). Work out exactly what "non-enumerable" means as a
   tree-node capability distinct from the existing enumerable directory
   type in `packages/daemon/src/directory.js` — is this a new directory
   variant, a flag, or a different node kind entirely?
2. **Both backends, one shape.** The Node-JS daemon and the Rust/XS-hosted
   endor daemon must both expose this tree shape identically, preserving
   `registry-capability.md`'s existing dual-backend-parity goal. Work out
   what each backend's adapter over its existing mechanics
   (`registry.rs`'s SQLite table on the Rust side; whatever the JS
   reference implementation resolves to) looks like concretely.
3. **Mockability.** The stated payoff is that the whole registry can be
   "mocked trivially from a readable tree" — work out what that actually
   buys (test fixtures as a plain directory of package.json + tarball-shaped
   trees, no SQLite/network involved at all?) and whether it changes how
   `mvs-resolver`/`snapshot-mapper` consume the registry (do they already
   only need tree-shaped reads, or do they currently call the bespoke
   `resolve()`/`fetch()` methods directly and need their own adapter?).
4. **Naming other registries.** The root directory's extensibility to other
   registries alongside `npm/` — is this just "add a sibling directory
   later" (no design work needed now beyond not hard-coding `npm` as the
   only root entry), or does it imply a registry-discovery/naming
   convention that should be specified now?
5. **The future `endor:swissnum@hint@hint/version` addressing protocol.**
   This is explicitly a *future* extension in the directive, not something
   to fully specify in this pass. Write it as an Open Question / forward
   compatibility note: does the proposed tree shape leave room for this
   future addressing scheme without foreclosing it, and what would need to
   change if/when it's designed? Do not invent the protocol here.

## Norms

Standard designer norms apply (`roles/designer/AGENT.md`): draft PR against
`llm`, left draft for the design-panel gauntlet (do not un-draft, do not
hand-post the gauntlet job). If the design concludes `registry-capability.md`'s
bespoke method-call shape should be replaced, mark that file stale with a
"Superseded by" note per house convention rather than deleting it — do not
touch `endor-npm-registry-proxy.md`'s mechanics-layer content beyond noting
where the new capability shape wraps it. Open questions the maintainer must
resolve go under `## Open questions` in question form.

<!-- garden-provider-quota-backoff: type=weekly reset-at=2026-08-29T03:00:00Z -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-25T18:50:52Z
