---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 449
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-06-17T22:42:00Z
last_appended_at: 2026-06-17T22:42:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#449

## Items

- [ ] Frozen-base refresh discipline: after the builder opens the
  implementation PR for this design, the builder should verify
  that the PR's base matches the post-#435 frozen-base branch
  (the design's *Dependency: PR #435 must merge first* section
  names this dependency; the builder dispatch should check that
  the frozen-base branch was updated to `855a8f7bc` or later
  before committing to the implementation branch).
  **Source juror(s)**: critic (round 1)
  **Round**: 1
  **Recommended action**: Add a pre-implementation check to the
  builder's dispatch brief: verify `origin/master` includes
  `855a8f7bc` (PR #435 merge commit) before branching; file an
  issue on endo-but-for-bots if the frozen-base branch is stale.

- [ ] README caveat language for silent-swallow indexed assignment:
  the design's *Semantics* section documents that indexed
  assignment (`view[0] = 42`) on a non-frozen emulated freezable
  view creates a wrapper-local own property rather than modifying
  the underlying buffer, and that on a frozen view the assignment
  is silently swallowed in non-strict mode or throws in strict
  mode. The package README's *Caveats* section should be updated
  to mention both behaviors explicitly so a user reading only the
  README understands the silent-swallow constraint. The design
  already instructs the builder to update the README (the
  *Implementation outline* > *Files added or modified* table
  names README.md as EDIT); this follow-up ensures the caveat
  language covers both non-frozen and frozen cases explicitly,
  not just a generic "indexed assignment may behave unexpectedly"
  note. The worked examples in this design can serve as the
  ready-to-paste caveat prose.
  **Source juror(s)**: ergonomist (round 1, reaffirmed round 2)
  **Round**: 1
  **Recommended action**: After the implementation PR merges,
  review the README's *Caveats* section. If the caveat language
  does not explicitly cover the non-frozen case (wrapper-local
  own property) and the frozen case (silent swallow or strict
  throw), open a follow-up PR to add the missing language using
  the worked examples from this design document.
