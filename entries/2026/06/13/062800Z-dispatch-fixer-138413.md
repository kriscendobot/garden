---
ts: 2026-06-13T06:28:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--138413
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#pullrequestreview-4491014140
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3407538590
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3407540460
---

# dispatch: fixer — consolidate parity tests + update changeset + remove issue numbers on PR #379

Kriskowal CHANGES_REQUESTED review `4491014140` on PR #379
(2026-06-13T06:26:17Z). Body:

> Please consolidate all of the new compartment mapper tests
> into a table test generator that makes evident which
> assertions correspond to each fixture, and that for every
> fixture, the corresponding Node.js parity test passes.

Plus 2 inline asks:

1. **`.changeset/fix-ses-star-export-cycle-rename.md:1`**
   (id `3407538590`):
   > Please update to reflect sum of changes.
2. **`packages/compartment-mapper/test/cycle-rename-tdz-var-renamer-first.test.js:41`**
   (id `3407540460`):
   > The issue number will be invalid upstream. Remove
   > issue numbers.

👀 reactjis posted on both inline asks.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#379`, OPEN (not DRAFT),
  base `master`, head `fix/issue-59-star-export-cycle` at
  `cc23fca8f` (per dispatch-prepare; FETCH if newer).

## Task

In your `project/` worktree on
`fix/issue-59-star-export-cycle`:

### Ask 1 — Consolidate parity tests into a table generator

The prior fixer (`4ab426`) added 7 fixture directories under
`packages/compartment-mapper/test/fixtures-cycle-{rename,named-reexport}-tdz-*`
each with a SES-side `.test.js` + Node.js parity sibling
(14 files total + a shared `_cycle-rename-tdz-assertions.js`
module).

Refactor these 14 individual test files into:
- **One table** declaring all 7 (or 8 — count) scenarios
  with their fixture path, expected `probe` value, and any
  scenario-specific metadata.
- **One test-generator function** that iterates the table
  and registers `test()` calls (or `test.serial()` if
  needed) — one per (scenario × runtime) pair.
- The runtime check (`'ses'` vs `'node'`) drives the
  assertion target.

Goals (per maintainer):
- Evident which assertions correspond to each fixture.
- For every fixture, BOTH SES and Node.js parity pass
  visibly.

Implementation sketch:
```js
// packages/compartment-mapper/test/cycle-rename-tdz-parity.test.js
import {SCENARIOS} from './_cycle-rename-tdz-assertions.js';
for (const scenario of SCENARIOS) {
  test(`${scenario.name} (ses)`, async t => { ... });
  test(`${scenario.name} (node parity)`, async t => { ... });
}
```

Adjust to the existing test infrastructure (AVA shape, how
the existing tests load fixtures, etc.).

### Ask 2 — Update changeset

`.changeset/fix-ses-star-export-cycle-rename.md` currently
describes the initial fix. Now the change set covers:
- The original cyclic star-export fix.
- The TDZ-observation matrix tests (6 cells, both star and
  named-reexport).
- The construction-time-notifiers archived design doc.
- The compartment-mapper parity fixtures.
- The compartment-mapper table-test generator (this round).

Rewrite the changeset body to reflect this sum. Keep the
version bump shape per the prior fixer's call (likely
patch).

### Ask 3 — Remove issue numbers

In
`packages/compartment-mapper/test/cycle-rename-tdz-var-renamer-first.test.js:41`
(and likely sibling files), remove any `#59` / `endojs/endo#59`
issue-number references. The maintainer's framing: these
will be invalid upstream (when this fix ferries to
`endojs/endo`, the bot-fork issue numbers don't translate).

Sweep all `cycle-rename-tdz-*` test files for similar issue
numbers and remove them.

### Push + reply

1. Run `corepack yarn workspace @endo/compartment-mapper
   test` to verify the table-generator works + all 7
   scenarios pass.
2. Run pre-push-gates.
3. Commit per logical step:
   - `test(compartment-mapper): consolidate cycle-rename-tdz
     parity tests into table generator per kriskowal review`
   - `chore: update changeset to reflect sum of cycle-rename
     work`
   - `test(compartment-mapper): remove fork-specific issue
     numbers from cycle-rename tests`
4. Push to `fix/issue-59-star-export-cycle` (append push).
5. Reply on review `4491014140` (top-level comment if
   review-replies unavailable) + on each inline thread,
   citing addressing commit SHAs.
6. Re-request review from kriskowal.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `fix/issue-59-star-export-cycle`
  (append push only).
- **Reply on review + inline threads**. Standing.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT amend prior fixer commits.
- Do NOT rebase or force-push.
- Do NOT alter the underlying fix substance (production
  code changes from earlier rounds stay).

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` naming:

- Pre/post branch tip SHAs.
- Per-commit substance.
- The table-generator structure (paste a few lines).
- The changeset before/after summary.
- The list of files swept for issue-number removal.
- Test result.
- The reply URLs.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
