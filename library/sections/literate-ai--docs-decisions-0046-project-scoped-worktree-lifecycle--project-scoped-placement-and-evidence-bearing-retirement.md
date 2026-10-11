---
title: "ADR 0046: Project-scoped placement and evidence-bearing retirement"
source: docs/decisions/0046-project-scoped-worktree-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [repository-governance, capability-security, agentic-sdlc]
status: current
---

> Abstract: Canonical placement derives from the Git common directory, while migration separates discovery, bounded audit, reviewed disposition, freshly revalidated removal, and resumable content-addressed evidence.

### Derive one canonical placement from Git custody

Introduce a typed project worktree location derived from the repository's absolute Git
common directory. For a non-bare repository whose common directory is the canonical
checkout's `.git`, persistent and command-owned linked worktrees live beneath the
ignored `<canonical-checkout>/.worktrees/` directory. The canonical checkout itself is
confirmed against `git worktree list --porcelain -z`; directory naming alone never
establishes ownership.

Names are short, portable slugs with a bounded digest suffix derived from their purpose
and exact branch or detached revision. Allocation uses an atomic reservation and
refuses collisions, symlink or reparse ancestors, case-fold conflicts, a changing Git
common directory, bare repositories and ambiguous canonical-checkout identity.
Commands, authored skills and initialized project copies consume the same public
location contract. Parent contribution checkouts remain under their separately owned
`parents/<id>/` boundary and are not reclassified as disposable worktrees.

Transient worktrees may be removed at command completion, but they use the same
project-scoped root and remain visible in Git registration and lifecycle evidence while
they exist. Disposable system temporary directories and top-level sibling paths are
not placement fallbacks.

### Separate discovery, audit, disposition and removal

Migration is an explicit four-stage application, not an extension of branch garbage
collection:

1. **Discover** candidates from the canonical repository's registered-worktree
   metadata and a bounded scan of its parent directory. A peer candidate is admitted
   only when its resolved Git common-directory identity matches the canonical
   repository. Independent clones, ordinary directories, missing registrations and
   contradictory identities are classified distinctly and never inferred from names.
2. **Audit** each admitted candidate into an immutable observation: registration and
   lock state, branch or detached HEAD, reachable and unreachable commits, merge
   ancestry and patch equivalence, index and tracked changes, untracked and ignored
   entries, stashes and per-worktree refs, submodule registrations and state, active
   process/session reservations, filesystem identity, and retained evidence references.
   Every collection is bounded; incomplete or drifting observation is a refusal.
3. **Dispose** every useful item through a reviewed destination in the canonical
   repository. Commits are landed by normal review policy; file or evidence bytes are
   copied into explicit retained custody; superseded material receives a human-reviewed
   rejection reason bound to exact digests. A tool may propose a disposition, but it
   cannot invent approval for a useful or ambiguous change.
4. **Remove** only an explicitly authorized candidate whose complete disposition is
   terminal. Immediately before `git worktree remove`, re-observe its registration,
   filesystem, Git and activity identities and require equality with the approved
   record. Use Git-aware non-force removal. Recheck registration and retained custody
   afterward; any disagreement leaves the journal pending and preserves the directory.

An independent clone is reportable but is never removed through the linked-worktree
application. Its refs, stashes, configuration and object reachability require a
separate reviewed clone disposition.

### Retain a resumable migration journal

Each run writes a canonical, content-addressed journal beneath the project's configured
evidence root. It binds repository identity, canonical checkout, placement-policy
identity, discovery bounds, candidate observations, proposed and accepted dispositions,
retained destinations, review references, removal authorization, revalidation records
and terminal outcomes. The operator can export a redacted report without exposing
credentials or private host paths.

Re-running the application opens the prior journal, revalidates completed steps and
continues pending candidates. It neither repeats a completed removal nor silently
reclassifies changed input. Concurrent mutation produces a new observation requiring a
new disposition. A summary lists every pending, refused, retained and removed candidate
so interruption cannot masquerade as completion.

The existing peer-work survey consumes this inventory for release visibility, while
branch lifecycle garbage collection remains a narrower operation. It may not delete a
legacy peer merely because the corresponding branch marker is terminal.

Source: [docs/decisions/0046-project-scoped-worktree-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0046-project-scoped-worktree-lifecycle.md) at commit `fcc40bc6`.
