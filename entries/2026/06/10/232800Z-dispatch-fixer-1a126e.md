---
ts: 2026-06-10T23:28:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--1a126e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4675471286
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/232410Z-result-fixer-a8a6ac.md
---

# dispatch: fixer — named-reexport test + construction-time-notifiers consideration on PR #379

Follow-on dispatch after fixer `a8a6ac` landed the TDZ-observation
matrix (commit `30664c3c2`) and surfaced 2 cells diverging from
Node.js (SES does NOT enforce TDZ for cross-module namespace
reads during cycle).

Second maintainer directive (kriskowal at 2026-06-10T22:58:19Z,
issue comment `4675471286`):

> @kriscendobot I believe I now understand ZB's comment
> https://github.com/endojs/endo/pull/3276#discussion_r3323524839:
> Please consider whether we can create all of the notifiers for
> a module instance at time of construction instead of time of
> link. This may require a more deliberate separation of the
> instantiation and link phases, but I suspect we already have a
> hard enough line. This would obviate deferred notifier linkage,
> since notifiers would always be available up front. If not,
> please explain why such an arrangement is not possible or how
> the calling convention for precompiled ModuleSource instances
> would need to change. It might be that the notifiers need to
> be partially applied before full initialization.
>
> Please also write a test that demonstrates the same failure
> mode of the cyclic export, but with a named reexport rather
> than a star reexport.

Two asks:

1. **Architectural consideration**: investigate whether
   notifiers can be created at module-instance construction
   time instead of link time. The maintainer offers two valid
   outcomes:
   - (a) Implement the redesign.
   - (b) Document why it's not possible / what the calling
     convention for precompiled ModuleSource instances would
     need to change. "Notifiers may need to be partially
     applied before full initialization" is one hypothesis.
2. **Test addition**: write a test demonstrating the same
   cyclic-export failure mode using a **named reexport**
   instead of a **star reexport**.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#379`, OPEN (not DRAFT), base
  `master`, head `fix/issue-59-star-export-cycle` at
  `30664c3c2` (post-TDZ-tests).

## Task

In your `project/` worktree on `fix/issue-59-star-export-cycle`
at `30664c3c2`:

### Phase 1 — Investigate construction-time-notifiers

1. **Read the relevant SES module-instance machinery**:
   - `packages/ses/src/module-{instance,link,load}.js`
   - The notifier-creation site(s). Grep for `notifier`,
     `notifierMap`, `notifyImport`, `notifyExport`, etc.
   - The instantiation vs link separation. The maintainer
     says "I suspect we already have a hard enough line" —
     verify whether instantiate and link are clearly
     separated in the current code, or whether they share
     state that would block the redesign.
2. **Read ZB's referenced comment**
   https://github.com/endojs/endo/pull/3276#discussion_r3323524839
   for the underlying concern.
3. **Determine outcome**:
   - **If the redesign is straightforward**: implement it
     (move notifier creation from link-time to construction-
     time). Single substance commit; tests confirm.
   - **If the redesign is complex but possible**: document
     the design in a `designs/construction-time-notifiers.md`
     OR as a prose section in the PR body, including:
     - The current instantiate/link separation analysis.
     - The proposed redesign sketch.
     - What partial-application of notifiers before full
       initialization would look like.
     - The implications for precompiled ModuleSource
       instances' calling convention.
     - A proposal for whether to pursue it now or as a
       follow-up.
   - **If it's not possible**: write a prose explanation in
     the PR body explaining why, with code references.

### Phase 2 — Named-reexport variant test

1. **Read the existing tests** at
   `packages/ses/test/import-gauntlet.test.js` (where fixer
   a8a6ac added the TDZ matrix) to understand the test
   harness shape.
2. **Add a test demonstrating the cyclic-export failure
   mode with a named reexport** (e.g., `export { y } from
   './export-renamer.js'`) instead of a star reexport
   (`export * from './export-renamer.js'`). The failure
   mode is the same: in a cycle where the renamer's `y` is
   read through the named reexport before it's bound, what
   does SES observe vs what does Node.js observe?
3. If the failure mode reproduces in the named-reexport
   shape (likely), mark as `.failing` per the prior fixer's
   precedent, with the same expected-vs-observed
   commentary.
4. If it does NOT reproduce (named reexport handles cycles
   differently from star reexport), the test asserts the
   passing behavior and notes the asymmetry.

### Phase 3 — Commit, push, respond

1. **Run** `corepack yarn workspace ses test` to confirm
   the new test + any implementation changes.
2. **Run pre-push-gates** in `project/` and confirm clean
   (the prior fixer noted two pre-existing probe failures
   on master to ignore: `no-inline-import-jsdoc` on
   `evasive-transform/src/index.js`,
   `security-md-hash-uniform` SECURITY.md divergence).
3. **Commit**:
   - If the construction-time-notifiers redesign is
     implemented: one substance commit
     (`fix(ses): create notifiers at construction time per
     kriskowal #issuecomment-4675471286`) + one test commit
     (`test(ses): named-reexport variant of cyclic-export
     failure mode`).
   - If the redesign is documented but not implemented: one
     prose-only commit (`docs(ses): document
     construction-time-notifiers consideration`) — or fold
     into a PR-body comment if it stays short — plus the
     named-reexport test commit.
4. **Push** to `fix/issue-59-star-export-cycle` (append
   push).
5. **Reply on the issue-comment** (`4675471286`) at-mentioning
   `@kriskowal`. The reply should:
   - Name the addressing commit SHA(s).
   - Summarize the construction-time-notifiers outcome
     (implemented / documented-not-implemented / documented-
     not-possible-with-reason).
   - Confirm the named-reexport test is added; note whether
     the failure mode reproduces.
6. **Re-request review** from kriskowal.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `fix/issue-59-star-export-cycle`
  (append push only).
- **Reply on the issue comment** with the at-mention
  acknowledgment. Standing `endo-but-for-bots` broad-comment
  authorization.
- **Re-request review** from kriskowal once the response is
  complete.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT amend prior commits.
- Do NOT touch the existing fixer's TDZ tests (commit
  `30664c3c2`); they stay as-is.
- Do NOT chase the broader SES module-instance refactor
  beyond what the maintainer's directive scopes (i.e., the
  construction-time-notifiers question specifically).

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` (or 11)
naming:

- Pre/post branch tip SHAs.
- The commit SHA(s) (substance + test, or docs + test).
- The construction-time-notifiers outcome (implemented /
  documented-and-folded-into-PR-body / not-possible-with-
  rationale).
- The named-reexport test summary (does the failure mode
  reproduce? is it `.failing` or passing?).
- Test result.
- pre-push-gates result.
- The reply URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
