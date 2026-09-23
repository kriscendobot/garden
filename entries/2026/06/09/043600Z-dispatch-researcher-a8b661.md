---
ts: 2026-06-09T04:36:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--a8b661
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
refs:
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/042500Z-result-researcher-3ab7bd.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/043500Z-result-designer-04b954.md
---

# dispatch: researcher — refinement-only precedence for the drop-the-pseudo-prototype builder

Thin researcher dispatch ahead of the builder for the SES
drop-the-pseudo-prototype redesign, per the researcher-precedence
rule. The prior researcher `3ab7bd` produced a comprehensive
`## Library and project references` section already (175+ lines);
the designer `04b954` then authored
`packages/immutable-arraybuffer/DESIGN.md` at commit `a4ce95b0c`
on branch `design/immutable-arraybuffer-drop-the-pseudo-prototype`
with explicit calls on the four open questions.

This dispatch is **refinement-only**: do not duplicate `3ab7bd`'s
work. Verify the prior references are still current and surface
any builder-specific implementation pointers the broad researcher
deferred to the designer.

## Scope

In your `project/` worktree at the design branch
(`design/immutable-arraybuffer-drop-the-pseudo-prototype`,
HEAD `a4ce95b0c`):

1. **Read the DESIGN.md** the designer just authored. Internalize
   the five moves, the explicit calls (premise-2 OUT, warn-and-
   overwrite, CHANGELOG historical, no ses-side companion), the
   builder's recommended starting state, and the test plan.
2. **Verify the prior researcher's references are current**:
   - The pony source file `packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js`
     still exists at the expected line counts.
   - The shim file `packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js`
     install body is at lines 94-97 (or current location if the
     designer's branch shifted lines).
   - The permits entry `packages/ses/src/permits.js:1393-1412` is
     still the `%ImmutableArrayBufferPrototype%` block.
   - The intrinsics sampling `packages/ses/src/get-anonymous-intrinsics.js:170-177`
     is still the throwaway-instance prototype walk.
   - The two test files are still
     `immutable-arraybuffer-pony-{slice,transfer}.test.js`.
   Flag any drift; otherwise note "current" briefly.
3. **Surface builder-specific implementation pointers** the broad
   researcher did not enumerate:
   - The test fixtures the builder will need to update (look in
     `packages/immutable-arraybuffer/test/` for any snapshot,
     fixture, or expected-output file beyond the two .test.js
     files).
   - The `lockdown.js:18` import — confirm no other consumer
     needs an import-path update besides this single line.
   - Any TypeScript declaration files (`.d.ts`) in
     `packages/immutable-arraybuffer/` that need rename or
     content updates.
   - The `package.json` field set that touches the renamed files
     (e.g., `main`, `module`, `exports` — verify exactly what
     needs editing for the rename without crossing into
     premise-2 scope).
   - The test command shape (`yarn test`, `yarn test --pattern`)
     and whether any test-runner config references the pony
     filename.
4. **Identify any new master commits** since `3ab7bd` ran. `git
   log a4ce95b0c..origin/master --oneline` and `git log
   3ab7bd-base..origin/master` for any commits that affect the
   redesign surface. The designer's branch is based on master at
   `4a04d078b`; if `origin/master` has advanced, the builder may
   need to rebase. Flag drift.
5. **Note any test-side gotchas** the builder will hit:
   `pre-push-gates` rules that might fire on the rename (e.g.,
   stale-filename comments, broken markdown links in the README
   after the section heading changes).

## Output shape

Produce a `result` entry under `journal/entries/2026/06/09/` with
a short `## Library and project references (refinement)` section
the orchestrator inlines into the builder brief. Keep it tight:
the broad references live in `3ab7bd`'s result entry, so the
builder reads that for context and yours for the implementation
deltas.

## Out of scope

- Do NOT duplicate `3ab7bd`'s work; that result is the canonical
  references doc.
- Do NOT propose implementation; that's the builder.
- Do NOT push, comment, or open anything.

## Authorizations

Read-only.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` containing
the refinement section + standard self-improvement footer. The
orchestrator inlines your section + the prior 3ab7bd references
pointer into the builder dispatch.

End your turn with a concise summary back to the orchestrator. The
orchestrator inlines your section and tears down your dispatch
root on return.
