The edit is landed and verified on `origin/journal2`: 27 new keyword routes (17 for `e-data-types`, 10 for `polymorphic-operator`), and the deliverable grep now returns hits.

## Completion report

**Job:** `library-index-keywords-orphan-concepts` (role: librarian) — index gap: two concept pages unreachable from `keywords.md`.

**What I did:**
- Read the `aliases:` frontmatter of both concept pages in `library/concepts/` and drew the keyword sets from them (authoritative source, per the task).
- Appended two blank-line-separated keyword clusters to the **end of the `## Index` section** of `library/keywords.md` (right before the first survey section, `## MCP ambient authority landscape`), preserving the file's cluster-with-blank-separator ordering discipline.
- Applied the file's backtick convention: bare code-symbol terms backticked (`` `float64` ``, `` `ConstList` ``, `` `ConstMap` ``, `` `FlexList` ``, `` `FlexMap` ``, `` `EList` ``, `` `EMap` ``); prose/phrase terms left plain (e.g. "E scalar types", "E char", "File-object E", and all ten `polymorphic-operator` phrases).
- Built the new body from the **freshest committed `origin/journal2` tip** (never the live `/home/kris/journal` worktree) and landed via `scripts/jobs/land-journal-edit.sh library/keywords.md`.

**What changed:** `library/keywords.md` gained 29 lines — 17 keyword routes to `e-data-types`, 10 to `polymorphic-operator`, plus 2 blank cluster separators.

**Verification:** `grep -E '\| *(e-data-types|polymorphic-operator) *$'` on the committed tip returns 27 hits (was 0). Both concepts are now routable via the `library-lookup` skill.

**Notes/follow-ups:** The land script emitted a benign WARN that the live `/home/kris/journal` worktree yielded no origin and it fell back to the cached journal remote (transient — consistent with the known journal-worktree-severed symptom); the push still verified reachable on `origin/journal2`, so no action needed. No concurrent keyword append was observed in the land window; the whole-file land is subject to the usual rare-concurrent-append caveat caught by the next index-integrity pass.
