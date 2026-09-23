---
source: designs/daemon-content-store-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: e22f713278b397142ca2a27eddd38f937573cd43
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 3
status: current
notes: Per the README this design is **Complete** as of PR #99. Bridges to library's existing daemon coverage (retention-path-notation cycle 42) and to daemon-cross-peer-gc (also Complete; not yet ingested). Establishes the "sweep-time reference count, not persistent counter" pattern as the daemon's GC discipline.
---

> Abstract: Design for cleanup of daemon-local storage associated with formulas but living outside formula JSON. **Two backing-store kinds covered**: (1) content-addressed blobs (`{statePath}/store-sha256/`, referenced by `readable-blob`/`readable-tree` formulas via SHA-256 `content` field) — grew monotonically before this design because `makeContentStore` had `store`/`fetch`/`has` but no `remove`; (2) scratch-mount backing directories (`{statePath}/mounts/{formulaNumber}`, owned 1:1 by `scratch-mount` formulas) — persisted after collection. **Both** hook into `collectIfDirty()`'s mark-and-sweep. **Content-store cleanup uses sweep-time reference counting** (NOT a persistent counter): scan collected formulas for `content` hashes → scan surviving formulas → delete only the orphaned hashes. Simpler than maintaining a durable refcount table; consistent with the existing mark-and-sweep discipline. **Scratch-mount cleanup** is simpler (1:1 with formula, no sharing): `rm -rf {statePath}/mounts/{formulaNumber}` at collection time. Cross-peer GC is orthogonal (separate design).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-scope](../sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--problem-and-scope.md) | daemon, persistence | current |
| [current-state-and-refcount-problem](../sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--current-state-and-refcount-problem.md) | daemon, persistence | current |
| [design-and-api-extension](../sections/endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension.md) | daemon, persistence | current |

## Cross-references

- Sibling daemon-GC design: `daemon-cross-peer-gc.md` (Complete; not yet ingested) — covers cross-peer formula GC; this design covers local storage cleanup.
- Adjacent daemon GC material in the library: `endo-but-for-bots--llm-designs-rpn--*` (cycle 42; the retention-path machinery this complements).
- `daemon-mount.md` provides the `scratch-mount` formula whose backing directory this cleans up.

## Source

[designs/daemon-content-store-gc.md](https://github.com/endojs/endo-but-for-bots/blob/e22f713278b397142ca2a27eddd38f937573cd43/designs/daemon-content-store-gc.md) at commit `e22f7132` on branch `llm`.
