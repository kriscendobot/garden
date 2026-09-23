---
ts: 2026-06-02T05:52:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--159247
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/358
---

# dispatch: designer — #358 r2: incorporate maintainer answers to open questions + caching scope

kriskowal CHANGES_REQUESTED on #358 at 2026-06-02T05:46:48Z with:

**Body (new scope ask)**:

> Expand scope to cover the caching behavior of the registry. It should be
> transparent that some operations will need to refetch evicted package
> data or metadata, but should not grow unbounded. The snapshot mapper
> will add a hard retention link to anything captured by the formula
> graph, into the CAS.

**Eight inline directives** (paths into the layered designs):

1. `designs/registry-capability.md` line 397: "Let's conflate these into
   `@registry` for now."
2. `designs/registry-capability.md` line 408: "Let's keep `@registry`
   since that will allow us to exceed its current mission as scope
   changes."
3. `designs/registry-capability.md` line 422: "Let's run without
   credentials at this time. All packages on npm must be public to read
   in."
4. `designs/mvs-resolver.md` line 300: "I do not believe that conditions
   come to bear on the dependency graph. Conditions will come to bear on
   linking the resulting compartment map, which is not the subject of
   this document."
5. `designs/mvs-resolver.md` line 314: "Yes. Search for the parent
   package.json with workspaces enabled, where the workspace is mentioned
   in the list of workspaces." (Answer to a question about workspace
   resolution.)
6. `designs/mvs-resolver.md` line 323: "Please include these in scope and
   test accordingly." (Apparently extending MVS scope — read context.)
7. `designs/snapshot-mapper.md` line 362: "We can avoid the scheme
   entirely. We can also avoid using the node_modules convention, since
   we are not using a Node.js importer. We should use the precedent
   established by archives. That is, there is a top-level
   `compartment-map.json` and all peers are directories naming package
   …" (Significant structural directive — abandon the
   `endo-mount:` URL scheme + node_modules layout, follow the
   compartment-mapper archives precedent.)
8. `designs/snapshot-mapper.md` line 371: "Sure." (Affirmative on whatever
   the surrounding question was — read context.)

## Task

Update the four layered design documents to incorporate these answers and
the new caching scope. For each inline, find the context at that line and
either:

- Resolve an open question by replacing it with the maintainer's answer.
- Update a design decision to reflect the maintainer's directive.
- Restructure prose where the directive requires it (e.g. the
  snapshot-mapper line 362 directive about dropping the
  `endo-mount:` URL scheme and adopting archive precedent will need
  meaningful rewriting of the addressing/layout sections, not just an
  acknowledgement).

Plus, in `designs/registry-capability.md` add a new section covering the
caching behavior the maintainer asked for:

- Transparent refetch of evicted package data/metadata.
- Bounded growth (define what "bounded" means here — LRU? size cap? TTL?
  use designer judgment but state explicitly).
- A subsection (or cross-link from `snapshot-mapper.md`) noting that the
  snapshot mapper adds a "hard retention link" from captured-in-formula-graph
  artifacts into the CAS, preventing eviction of anything reachable from
  a snapshot.

### Concrete sub-tasks

A. `registry-capability.md`:
   - Line 397: conflate the two named slots into `@registry`.
   - Line 408: keep the `@registry` name explicitly (do not narrow it).
   - Line 422: drop the credentials concept; assert public-only.
   - **New section**: caching behavior (transparent refetch, bounded
     growth, retention link from snapshot mapper). Add to Goals/Non-Goals
     as appropriate.

B. `mvs-resolver.md`:
   - Line 300: drop conditions from the dependency-graph scope; state
     plainly that conditions are linking-time, out of this doc's scope.
   - Line 314: add the workspace-resolution procedure (search parent
     package.json with workspaces enabled, etc.).
   - Line 323: extend scope per the inline (read what "these" refers to
     in the diff hunk and include them).

C. `snapshot-mapper.md`:
   - Line 362: abandon `endo-mount:` URL scheme and node_modules layout.
     Adopt compartment-mapper archive precedent: top-level
     `compartment-map.json` + peer directories named by package. This is
     the most structurally significant change — the addressing section
     of the design needs rewriting, not patching.
   - Line 371: incorporate the maintainer's affirmation.
   - Cross-link to `registry-capability.md` caching section for the hard
     retention link.

D. `daemon-worker-import-from-mount.md` (integration layer):
   - Reflect downstream consequences of the snapshot-mapper structural
     change (no more `endo-mount:` URLs in the integration surface).

E. `designs/README.md`:
   - No changes expected unless the layered docs gain/lose dependency-graph
     nodes. The earlier decomposition's dependency-graph nodes
     (`dwicap`, `dwimvs`, `dwisnap`) should stay.

### Procedure

1. Read the dispatch entry (this file) and the maintainer's review on the
   PR.
2. Read each inline comment's `diff_hunk` to see the exact prose the
   maintainer is replying to. The line numbers reference the HEAD blob;
   the `diff_hunk` from the API gives the exact context.
   ```
   gh api repos/endojs/endo-but-for-bots/pulls/358/comments \
     --jq '.[] | select(.created_at > "2026-06-02T05:30:00Z") |
       {path, line, body, diff_hunk}'
   ```
3. Update each layered design per the sub-tasks above.
4. Verify cross-references and the layered structure still hold.
5. Commit per-layer.

### Commit structure

Suggested split:

1. `design(registry-capability): conflate @registry slots; drop
   credentials; add caching+retention scope (round-2)`
2. `design(mvs-resolver): drop conditions from dep-graph scope; add
   workspace resolution; expand test scope (round-2)`
3. `design(snapshot-mapper): adopt archive precedent for layout; drop
   endo-mount: URL scheme; link to registry caching (round-2)`
4. `design(daemon-worker-import-integration): reflect snapshot-mapper
   layout change (round-2)` (only if integration surface changes)

Commits under endolinbot identity. Push regular append (no force) to
`endojs/endo-but-for-bots:design/daemon-worker-import-from-mount`.

## Per-action authorizations

- Create new sections / edit existing sections in the 4 layered
  `designs/*.md` files. Authorized.
- Edit `designs/README.md` if dependency-graph changes (unlikely).
  Authorized.
- Regular append push to
  `endojs/endo-but-for-bots:design/daemon-worker-import-from-mount`.
  Authorized.

## Not authorized

- Force-pushing.
- Modifying any code under `packages/`.
- Resolving review threads (steward does that after designer reports).
- Un-drafting or re-drafting.
- Closing the PR.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/designer--159247/garden/roles/COMMON.md`
2. `/home/kris/dispatches/designer--159247/garden/roles/designer/AGENT.md`
3. Skills referenced by the designer just-in-time. Relevant:
   `process-documents`, `design-to-pr-pipeline`.

Project worktree at `project/` on
`design/daemon-worker-import-from-mount` (head `0257affa7`).

## Report

A `result` journal entry. Include: new head SHA after push, list of
files modified per commit, mapping of each maintainer inline comment to
the commit that addresses it (so the steward can resolve threads
cleanly), any new open questions surfaced by the round-2 updates.
