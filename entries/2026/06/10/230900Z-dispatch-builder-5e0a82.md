---
ts: 2026-06-10T23:09:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--5e0a82
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4453991038
  - https://github.com/endojs/endo-but-for-bots/pull/403#discussion_r3376818416
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/230453Z-result-researcher-116409.md
---

# dispatch: builder — evolve PR #403 to subsume layers 2-4 of the #358 design stack

Maintainer directive on PR #403 (kriskowal at 2026-06-08T22:57:59Z,
review `4453991038`):

> I would like to override the fixer's standing instructions.
> Please dispatch a builder to evolve this change to subsume
> the subsequent planning phases.

Plus one inline ask at `packages/exo-npm/README.md:53`
(id `3376818416`):

> The layering references will not stand the test of time.
> Please remove development procedural minutia.

## Library and project references

The full `## Library and project references` section is at
`journal/entries/2026/06/10/230453Z-result-researcher-116409.md`
(researcher `116409`'s result entry; ~308 lines). **Read it
verbatim** before starting. It catalogues:

- The four design documents (layers 1-4) with section anchors
  for what each layer contributes.
- The layer-1 implementation surface
  (`packages/exo-npm/` + `packages/mem-cas/`, post-rename from
  the brief's original `packages/registry-capability/` naming).
- The layer-4 daemon consuming surfaces (host.js:199-211
  specialNames map, formula-type.js, daemon.js, worker-node.js,
  mount.js, endo.test.js, packages/cli/).
- The README:53 bullet ("Wiring of `@registry` into
  `HostFormula` as a required field") that closes the inline
  ask.
- Five prior journal entries with maintainer-directive history.
- The three open questions the researcher surfaced (`@registry`
  slot wiring shape; `Uint8Array` vs `string` for `resolve()`;
  compartment-mapper extension point API shape).

The researcher noted PR #403 head is now `9da73262d` (was
`584d06da3` at brief-time). **FETCH AND CHECKOUT `9da73262d`
BEFORE STARTING**.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#403`
  ("feat(registry-capability): EndoRegistry capability +
  @registry special name (#358 layer 1)"), DRAFT, base
  `llm-c85d618`, head `feat/registry-capability` at
  `9da73262de9ca848d7274f1f854a9d0e113226ca` (`9da73262d`).
  `reviewDecision: CHANGES_REQUESTED`.
- **Layer 1** is shipped on the branch (`@endo/exo-npm` +
  `@endo/mem-cas` packages).
- **Layers 2-4** are designs only; this PR's expanded scope
  is to implement them.

## Task — implement layers 2, 3, 4 on top of layer 1

This is a substantial multi-layer implementation. The
researcher's brief lays out a clear sequence. In your
`project/` worktree at `9da73262d`:

### Phase 0 — Setup
1. **Read each of the four design documents** in `designs/`
   per the researcher's anchors. They are the spec.
2. **Read the researcher's references section** in full.
3. **Address the open questions** the researcher surfaced.
   For each, either implement per the design's strongest
   signal OR document the choice you made in the PR body's
   "Design departures" section so the maintainer can review.

### Phase 1 — Address the inline ask
Address comment `3376818416` (packages/exo-npm/README.md:53).
The researcher identifies this as the "Wiring of `@registry`
into `HostFormula` as a required field" bullet. The
maintainer's framing: "layering references will not stand the
test of time. Please remove development procedural minutia."
This is satisfied by **either**:
- (a) Removing the layering bullet and replacing it with a
  durable description of the wiring shape that lives in the
  shipped code (after layer 4 lands), OR
- (b) Deleting the bullet entirely and letting the shipped
  code document itself.
Choose based on what reads best post-merge.

### Phase 2 — Layer 2 (mvs-resolver)
Per `designs/mvs-resolver.md`:
- Implement `EndoRegistry.resolve(packageJsonBytes, options)`
  with Go-like MVS algorithm adapted to npm versioning.
- Workspace resolution (parent-directory walk, workspace-wins
  semantic).
- Peer / optional dependency walking.
- Lockfile interaction is § *out of scope*.
- Phased-implementation Phase-1 tests inside the existing
  layer-1 Phase-1 test surface.

### Phase 3 — Layer 3 (snapshot-mapper)
Per `designs/snapshot-mapper.md`:
- Implement the `mapSnapshot` mapper structure.
- Wire ReadPowers.
- Mount-snapshot integration.

### Phase 4 — Layer 4 (daemon-worker integration)
Per `designs/daemon-worker-import-from-mount.md`:
- Wire `@registry` into the daemon host's specialNames map
  (host.js:199-211 per researcher).
- Add the daemon-side host-method and formula plumbing.
- Update `formula-type.js`, `daemon.js`, `worker-node.js`,
  `mount.js`.
- Add CLI surface in `packages/cli/`.
- Add `endo.test.js` integration tests.

### Phase 5 — Test + push iteratively
After each layer, run tests for the affected packages. Push
when a layer is complete. The PR body should evolve to
describe what now ships (all four layers).

### Phase 6 — PR body rewrite
Once layers 2-4 are landed, rewrite the PR body to describe
the full four-layer implementation, not just layer 1. Drop
the "this PR implements layer 1" framing.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `feat/registry-capability` (append push
  only; do NOT amend prior commits; do NOT force-push).
- **Multiple commits / push cycles** as the layer-by-layer
  build progresses. One commit per layer (or per logical
  sub-step) is cleaner than one mega-commit.
- **Rewrite the PR body** via `gh pr edit --body-file` to
  reflect the new four-layer scope.
- **Top-level summary comment** on PR #403 once all layers are
  pushed.
- **Reply on inline thread `3376818416`** citing the addressing
  commit SHA and noting how Phase 1 closed the layering-
  references ask.
- **Reply on review `4453991038`** (as a top-level PR comment
  if review-replies aren't supported) noting layers 2-4 are
  now subsumed.
- **Re-request review** from `kriskowal` once layers 2-4 are
  pushed and the PR body is rewritten.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT amend prior commits.
- Do NOT un-draft the PR; judge un-drafts at gamut termination.
- Do NOT scope-expand beyond layers 2-4. (The SQLite-backed
  `PackageCacheTable` and the Rust-side
  `endor-npm-registry-proxy` are explicit follow-ups per the
  researcher.)

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` (or 2026/06/11
if you cross midnight UTC) naming:

- Pre/post branch tip SHAs.
- Per-layer implementation summary (one section per
  layer 2/3/4):
  - Files added / modified.
  - Test surface added.
  - Per-design-document section anchors satisfied.
  - Design departures (if any).
- The README:53 inline-ask resolution (which option, what
  the file now says).
- Open-question decisions: per the three the researcher
  surfaced, what did you choose and why.
- Test results per workspace.
- pre-push-gates result.
- The PR body rewrite (or describe it; before/after summary).
- The inline-thread reply URL.
- The top-level summary comment URL.
- The re-request-review URL/status.
- A `Self-improvement: ...` line.
- **Recommended next stage**: most likely `next: cleaner` to
  begin the gamut after the builder's substance lands. If you
  hit an impasse, escalate `next: liaison` with a specific
  question.

End your turn with a concise summary back to the orchestrator. The
orchestrator continues the gamut and tears down your dispatch
root on return.
