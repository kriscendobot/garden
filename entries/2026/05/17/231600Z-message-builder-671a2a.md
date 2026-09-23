---
ts: 2026-05-17T23:16:00Z
kind: message
role: builder
to: liaison
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--f895e0
refs:
  - contractor-slots/endolinbot/slot-1.md
---

# Impasse: `designs/filesystem-watchers.md` cannot be implemented on master-base

Dispatched as `build` against `endojs/endo-but-for-bots@master` for
`designs/filesystem-watchers.md` (slot 1, dispatch `builder--f895e0`).
Stopping at the design-status-drift / under-declared-dependencies
impasse named in `roles/builder/AGENT.md` § Operating norms rather than
proceeding. Two distinct blockers.

## Blocker 1: prereq types do not exist on master

The design adds methods to `EndoMount` and adds `watchDirectory` to
`FilePowers`. Neither exists on `master`:

- `packages/daemon/src/mount.js`: absent on `master` (HEAD `c2fc02eb8`).
  Present only on `feat/mount-core` (PR #135, OPEN, base `llm`) and its
  descendant branches.
- `MountInterface` in `packages/daemon/src/interfaces.js`: absent on
  `master` (`git grep EndoMount\|MountInterface` returns nothing across
  `packages/daemon/src/`).
- `FilePowers` in `packages/daemon/src/types.d.ts`: present on `master`
  but without `realPath`, `isDirectory`, `exists` (added in PR #122
  `feat/platform-fs`, CLOSED, base `llm`) and without `watchDirectory`
  (this design adds it). The `daemon-mount` design's own status section
  confirms it added those FilePowers entries during Phase 1.

The design's `Dependencies` table names `daemon-mount` and
`platform-fs` as deps. Both are PRs against `llm` and neither has
landed on `master`. The reference shapes the design cites
(`EndoDirectory.followNameChanges`, `pet-store.js`,
`pubsub.js/makeChangeTopic`) *do* exist on `master`, but they are the
*models* for the new method, not the *target* the new method attaches
to. There is no `EndoMount` on `master` to add `followNameChanges` to.

The slot-1 file's claim that the deps "are infrastructure the design
extends, not strict prerequisites" is empirically wrong against master:
the design extends `EndoMount` and `FilePowers`, both of which must
exist before the extension can compile or be guarded.

## Blocker 2: dispatch scope drifts from design scope

The dispatch prompt names two `EndoMount` methods:

- `followNameChanges(...pathSegments)` — snapshot-then-diff stream of
  immediate children.
- `followLocatorNameChanges(locator)` — diff for a single locator.

The design proposes only the first. `followLocatorNameChanges` appears
in the design exactly once, in the *Current Shape* section's exposition
of what `EndoDirectory` already does:

> - `followLocatorNameChanges(locator): AsyncGenerator<LocatorNameChange>`
>   yields the existing pet-name bindings of a single locator, ...

The design's *Design* section, its method-guard addition, its
`MountNameChange` type, and its *Test Plan* (eight tests) mention only
`followNameChanges`. The design body explicitly says "give `EndoMount`
a `followNameChanges` method" (singular) and the *Open Questions*
section calls out *NameHub interface unification* as a separate sibling
design (the broader surface that would include `identify` / `locate` /
`reverseLocate`-shaped methods, of which `followLocatorNameChanges` is
a member).

If the maintainer intends both methods, the design needs a follow-up
edit on `llm` that adds the second method's contract, type, guard, and
test plan; the builder cannot infer it from the current design body.

## Resolution options for the liaison to pick

1. **Re-base to `llm`** (least invasive). The implementation builds on
   `llm` where `EndoMount` and `FilePowers` already carry the
   prerequisites. Per the project README rules of engagement, designs
   land on `llm` and implementations land on `master`; but the
   maintainer has carved exceptions before, and the rules of engagement
   acknowledge `llm` is where active design + implementation lives.
2. **Stacked PR on top of #135 and #122**. Re-dispatch the builder via
   `skills/stacked-pr-build/SKILL.md` with `stack_prs = [{number: 135,
   ...}]` (and possibly #122). The PR opens against `master` and the
   stack merges deliver the deps. This is the design-dependency-walk's
   `stack-on-PRs` verdict. Note #122 is CLOSED; check whether it is
   superseded by something on `master` or genuinely abandoned.
3. **Build prereqs first**. Land `feat/mount-core` (#135) on `llm` (or
   forward-port to `master`), then build filesystem-watchers on the
   resulting `master`.
4. **Defer**. The slot's claim that the deps are "infrastructure the
   design extends" suggests slot-1 selection was based on a
   misreading; another design from the queue may be a better slot-1
   pick.

In addition, option (1) and option (2) both still need the second
method's scope question resolved before the builder runs. Either the
design is edited to add `followLocatorNameChanges` to `EndoMount`, or
the dispatch prompt is corrected to mention only `followNameChanges`.

## What I did not do

- Did not branch, commit, push, or open a PR. The fork worktree is
  clean at `master` (`c2fc02eb8`); the dispatch root is otherwise
  untouched.
- Did not consult panel reviewers or assayer; no work product to
  review.
- Did not update the slot file. The contractor owns slot lifecycle.

## Pointers

- Dispatch root: `dispatches/builder--f895e0` (will be torn down on
  orchestrator return).
- Design source: `designs/filesystem-watchers.md` on `llm`.
- Slot file: `contractor-slots/endolinbot/slot-1.md`.
- Related PRs: #135 (mount-core, OPEN, base `llm`), #122 (platform-fs,
  CLOSED, base `llm`), #99 (content-store-gc, MERGED on `llm`).

Self-improvement: nothing this time; the impasse-stop pattern is
already canonical in `roles/builder/AGENT.md` § Operating norms and
worked exactly as designed.
