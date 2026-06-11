---
ts: 2026-06-11T06:33:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--4ab426
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3393767528
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion_r3393779233
---

# dispatch: fixer — archive design doc + verify compartment-mapper parity on PR #379

Maintainer asks on PR #379 (kriskowal at 2026-06-11T06:29-06:32Z):

1. **Inline comment `3393767528`** at
   `packages/ses/designs/construction-time-notifiers.md:1`:
   > @kriscendobot Please delete, but capture a copy in your
   > journal.
2. **Inline comment `3393779233`** at
   `packages/ses/test/import-gauntlet.test.js:1`:
   > Please double-check that each of these scenarios is also
   > represented as a compartment mapper test fixture with a
   > Node.js parity check.

👀 reactjis already posted on both
(`reactions/401601225`, `reactions/401601228`).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#379`, OPEN (not DRAFT),
  base `master`, head `fix/issue-59-star-export-cycle` at
  `53d8662a7...`. Confirm via `gh pr view 379 --json
  headRefOid`.

## Task — two distinct asks, two separate commits

### Phase 1 — Archive then delete the design doc

The design doc was a useful exploration of the
construction-time-notifiers redesign, but the fixer landed
the actual TDZ fix without needing the redesign. The
maintainer wants the doc removed from the PR but archived
for future reference.

1. **Copy** `packages/ses/designs/construction-time-notifiers.md`
   into the journal at
   `journal/entries/2026/06/11/063300Z-archive-construction-time-notifiers-design.md`
   (or use the project's convention if one exists for design
   archives — check
   `garden/skills/process-documents/SKILL.md` and the
   project's `journal/projects/endo-but-for-bots/` directory
   for the right shape).
   - Add a short frontmatter / preamble noting the archival
     reason: "Maintainer asked to delete from PR #379 but
     archive for future reference per
     #issuecomment / #discussion_r3393767528".
2. **Delete** the file
   `packages/ses/designs/construction-time-notifiers.md`
   from the working tree.
3. **Commit** with conventional message:
   `docs(ses): remove construction-time-notifiers design doc
   (archived in journal) per kriskowal`.
4. **Push** to `fix/issue-59-star-export-cycle` (append
   only).
5. **Reply on the inline thread** (`3393767528`) citing the
   addressing commit SHA and the journal archive path.

### Phase 2 — Compartment-mapper parity check

The maintainer wants every scenario in
`packages/ses/test/import-gauntlet.test.js` (which the prior
fixers extended) to have a matching **compartment-mapper test
fixture with a Node.js parity check**. Parity tests assert
that SES behavior matches Node.js behavior on the same
fixture.

1. **Read**
   `packages/ses/test/import-gauntlet.test.js` to enumerate
   the test scenarios. The prior fixers added:
   - 6-cell TDZ matrix (import-order × binding-form) for
     star-reexport.
   - 1-cell named-reexport variant.
   Plus whatever was there before. Each scenario is a
   distinct fixture shape (e.g., renamer + star-reexporter +
   main; renamer + named-reexporter + main).
2. **Locate the compartment-mapper test fixtures** —
   probably under
   `packages/compartment-mapper/test/fixtures-*/` or
   similar. Look for the existing parity-test infrastructure
   (the kriskowal comment hints there's an established
   pattern; grep `git log` for parity-related commits).
3. **For each gauntlet scenario**, check whether a
   corresponding compartment-mapper fixture exists. If not:
   - Create the fixture (the three or four .js files for
     the cyclic-import shape).
   - Add the parity-test entry that asserts SES behavior
     against Node.js behavior on the fixture.
4. **Document the parity-check coverage**: in the PR body or
   as a JSDoc comment in import-gauntlet.test.js, link each
   scenario to its compartment-mapper fixture.
5. **Note `garden/skills/no-latin-shorthand/SKILL.md`** for
   the fixture file naming.
6. **Run** the relevant test commands to verify both
   suites pass:
   - `corepack yarn workspace ses test`
   - `corepack yarn workspace @endo/compartment-mapper test`
7. **Run pre-push-gates**; clean.
8. **Commit** with conventional message:
   `test(compartment-mapper): parity fixtures for cyclic
   star/named-reexport scenarios per kriskowal`.
9. **Push** (append).
10. **Reply on the inline thread** (`3393779233`) citing
    the addressing commit SHA and listing each new fixture
    by name.
11. **Re-request review** from kriskowal once both replies
    are posted.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `fix/issue-59-star-export-cycle`
  (append only).
- **Reply on both inline threads**. Standing.
- **Write to the journal** (the archive of the design doc).
  Standing.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT amend prior commits.
- Do NOT rebase or force-push.
- Do NOT delete the journal archive once written.
- Do NOT pursue the construction-time-notifiers redesign
  (it's accepted-as-followup, not in-scope for this PR).
- Do NOT touch other PRs.
- Do NOT mark the PR ready or otherwise change PR state.

## Deliverable

A `result` entry under `journal/entries/2026/06/11/` naming:

- Pre/post branch tip SHAs.
- The two substance commit SHAs.
- The journal archive path for the design doc.
- The list of new compartment-mapper fixtures created (one
  line per fixture: scenario name + fixture path + parity
  assertion).
- Test result.
- pre-push-gates result.
- The two inline-thread reply URLs.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
