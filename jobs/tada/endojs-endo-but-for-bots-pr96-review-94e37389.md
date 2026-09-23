The rename is complete and pushed, with no stray `search` identifier references remaining in code.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #96 (reviewer @kriskowal, comment r3532573034).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this comment.

**Directive resolved (the whole review = one inline comment thread):** kriskowal, continuing the thread where the `walkUpwards`/`search` name pair was flagged as insufficiently differentiated (a peer had already renamed `walkUpwards` → `walkToCompartmentRoot` in 428b76d7f but explicitly left the exported `search` "untouched"), directed: *"for consistency, I would name this `searchCompartmentDescriptor`."* → rename the exported `search` to `searchCompartmentDescriptor`.

**Changes (commit 845dd3f74, pushed to `design/compartment-mapper-auxiliary-package-json`):**
- `src/search.js` — `export const search` → `searchCompartmentDescriptor`.
- `index.js` — updated the public re-export.
- `test/search.test.js` — import, call sites, and test titles.
- `src/types/internal.ts` — `SearchOptions`/`SearchResult` JSDoc references.
- `src/package-descriptor-cache.js` — the comment referencing the existing `search`.
- Added `.changeset/rename-search-compartment-descriptor.md` (`major`, since `search` is a public export).

**Deliberately left as-is:** `searchDescriptor` (the generic lower-level helper — only one name was named); the README's conceptual "search" pipeline-stage diagram (ASCII alignment, not the export symbol). Both noted in the reply.

**Verification:** No installed deps in the fresh worktree and a full monorepo install was disproportionate for a symbol rename (PR CI is the backstop), so I verified statically: `node --check` on all changed JS files passed, exhaustive grep confirms every call site updated with no stray refs, and no other monorepo package imports the renamed symbol.

**Thread reply posted** (r3532601917): confirms the rename + commit, lists the deliberate scope decisions, and flags the semver nuance — `search` is public, so I marked the changeset `major` and offered a deprecated-`search` alias or bump downgrade if the maintainer considers it internal.

**Follow-ups / awaiting maintainer:** whether to also rename `searchDescriptor`, and whether to keep `major` vs. add a back-compat alias.
