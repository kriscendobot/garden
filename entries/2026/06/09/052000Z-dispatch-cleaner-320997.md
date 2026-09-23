---
ts: 2026-06-09T05:20:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--320997
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4656037929
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/051856Z-result-builder-0668d9.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/043500Z-result-designer-04b954.md
---

# dispatch: cleaner — stage 1 of #435 gamut (drop-the-pseudo-prototype redesign implementation)

Continuing the gamut on PR #435 per kriskowal's directive at
2026-06-09T04:15:35Z on PR #430 (issue comment `4656037929`):

> Run the gamut until done.

Builder `0668d9` opened DRAFT PR #435 with the 9-commit
implementation of the drop-the-pseudo-prototype redesign per
the designer's DESIGN.md (also on this branch). Per the
gamut-rule the cleaner is the first stage post-builder.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#435`
  ("feat(immutable-arraybuffer,ses): drop the pseudo-prototype
  intrinsic (per DESIGN.md)"), DRAFT, base `master-4a04d07`,
  head `build/immutable-arraybuffer-drop-the-pseudo-prototype`
  at `53e276c66`.
- **Tests reported green** by builder per workspace: 47
  immutable-arraybuffer, 505 ses (2 pre-existing known
  failures), 24 pass-style, 32 bytes.
- **Pre-push-gates** clean on builder's commits; the two
  remaining probe flags (`no-pull-citations`,
  `sentence-per-line-md`) sit on the **designer's** prior commit
  (the DESIGN.md), not on the builder's substance commits.
  Address as part of cleaner-stage hygiene.
- **Surface adaptations** the builder folded in that the design
  did not anticipate:
  - Kept `sliceBufferToImmutable` + `optTransferBufferToImmutable`
    re-exported from `index.js` because
    `packages/bytes/src/to-immutable.js` still imports them
    (premise-2 out per design).
  - Lib tests now import the shim at the top.
  - Filename: renamed from design's
    `immutable-arraybuffer-lib.js` to `lib.js` per
    `filename-no-stutter` probe (deviation from design).

## Task

In your `project/` worktree at
`build/immutable-arraybuffer-drop-the-pseudo-prototype` (HEAD
`53e276c66`):

1. **Read** `garden/skills/pre-pr-checklist/SKILL.md` and
   `garden/skills/pr-formation/SKILL.md` to refresh modern PR
   hygiene standards.
2. **Run `pre-push-gates`** in the project worktree. Address the
   two known designer-side issues:
   - `no-pull-citations` on DESIGN.md: either rewrite the `#430`,
     `#417` references to `endojs/endo-but-for-bots#430` /
     `endojs/endo#417` qualified form, or to bare commit-SHA
     references; pick the form consistent with the surrounding
     prose.
   - `sentence-per-line-md` on DESIGN.md: apply the rewrap. The
     skill reference is `garden/skills/em-dash-style/SKILL.md`
     for typographic discipline.
   Land each fix as a separate scoped commit.
3. **Audit the PR body** against `pr-formation`:
   - Title matches the redesign scope.
   - Summary explains the five moves at the right altitude.
   - Surface adaptations the builder noted (lib-test shim
     import, filename rename, premise-2-driven re-export
     preservation) are mentioned in the body so reviewers
     understand the design-vs-implementation deltas.
   - Regression-evidence section: builder's test counts are
     mentioned; the `permit-removal-warnings-node.test.js`
     adaptation is called out as a known-test-adjustment.
   - Closes-issue: no explicit issue closure (this is a
     redesign PR, not a bug fix); the `Refs:` line should name
     PR #430 + erights's comment `4655451705` + kriskowal's
     authorization `4656037929`.
4. **Audit the diff** against modern hygiene skills:
   - `garden/skills/changeset-discipline/SKILL.md` (the
     multi-package changeset shape)
   - `garden/skills/rename-discipline/SKILL.md` (the
     pony→lib rename surface; check for stray `pony` references
     in test titles, JSDoc, comments)
   - `garden/skills/em-dash-style/SKILL.md`
   - `garden/skills/no-latin-shorthand/SKILL.md`
   - `garden/skills/relative-paths/SKILL.md`
   - `garden/skills/test-title-spec-spelling/SKILL.md`
   The amplifier-with-this-fallthrough test titles are a
   particularly load-bearing surface for test-title spelling.
5. **No rebase needed**; the builder already targeted the
   current frozen base `master-4a04d07`. Confirm
   `git merge-base --is-ancestor origin/master HEAD` shows the
   branch is current with the live trunk (no need to rebase
   onto a moving target).
6. **Commit your hygiene changes** with conventional-commit
   messages scoped per kind. PR-body edits don't take a commit
   (use `gh pr edit`); diff-level cleanups each get their own
   conventional commit.
7. **Push** to `build/immutable-arraybuffer-drop-the-pseudo-prototype`
   (append push only — do NOT force-push or amend the builder's
   commits).
8. **Post a short top-level comment** on PR #435 summarizing the
   hygiene-pass findings (what was already clean; what was
   tightened; any structural concerns surfaced for the next-
   stage panel) and naming the new head SHA. End the comment
   with one line: "Next stage: barrister panel."

## Authorizations (per-action, forwarded by steward)

- **Push commits** to
  `build/immutable-arraybuffer-drop-the-pseudo-prototype`
  (append push only). Implicit in the cleaner dispatch.
- **Edit the PR body** via `gh pr edit` if structural rewrite is
  warranted. Standing cleaner PR-formation authority.
- **Top-level summary comment** on PR #435. Standing
  `endo-but-for-bots` broad-comment authorization.

## Out of scope

- Do NOT touch source files beyond hygiene fixups (probe
  outputs, prose rewrites). Substance is the builder's; cleaner
  is structural/typographic only.
- Do NOT un-draft the PR (judge un-drafts at gamut termination).
- Do NOT request review.
- Do NOT touch the design branch
  (`design/immutable-arraybuffer-drop-the-pseudo-prototype`); the
  builder branched off it and the PR head is the only live
  surface now.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- Pre/post branch tip SHAs.
- The hygiene-pass commits (SHA + scope per commit).
- PR-body edits made (before/after summary).
- Per-skill audit results.
- Pre-push-gates resolution: which probes were addressed, which
  remain (none should remain after this pass).
- The top-level summary comment URL.
- **Recommended next stage**: barrister panel (standard
  shape; deviate only if the cleaner finds something
  structural).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the next gamut stage (barrister panel) and
tears down your dispatch root on return.
