---
job: 24b50f
posted_by_role: judge
posted_by_host: endolinbot
posted_at: 2026-05-20T04:37:41Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 306
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
refs: []
preconditions: []
---

# Summary-fix bundle: PR endojs/endo-but-for-bots#306 (daemon persona capability)

The judge code-panel round (2026-05-20) terminated with 0 must-fix-loop items at head `b6f332621`; CI 25/25 SUCCESS. Eight `summary-fix`-dispositioned items remain owed and bundle into one fixer dispatch.

These items do not block un-draft (the judge un-drafts on this terminating round) and are not regressions of new fixer work; they are the round-1 panel findings that fell into the summary-fix bucket.

## Items

1. `packages/daemon/src/interfaces.js:109,113` — tighten `epithets` / `verify` method guards to `M.promise(M.arrayOf(EpithetShape))` and `M.promise(M.boolean())` per the design's *Handle extension* snippet. This consumes the unused `EpithetShape` export (currently exported but never used at runtime). [rule: skills/coverage-driven-testing/SKILL.md § shape guards earn their keep at the boundary]

2. `packages/daemon/src/types.d.ts:310-314` — drop `ExposedEpithet` (zero `grep` consumers) or replace its body with the precise `{ relationship: string; principal: Handle }`. The trailing "Handle remotable" comment + `unknown` type is the wrong shape; `Handle.epithets()` already returns the precise form. [rule: packages/CLAUDE.md § Type-assertion discipline]

3. `packages/daemon/src/interfaces.js:99-104` — rewrite the `HandleInterface` header so the leading sentence does not contradict the new persona methods' explicit guards. The trailing sentence acknowledges the persona methods carry guards; the lead-in still reads as a blanket prohibition. [rule: skills/archivist/AGENT.md]

4. `packages/daemon/src/mail.js:1376` — narrow `getFormulaForId(selfId).catch(() => undefined)` to "id not found" rather than swallowing every read error. Today it silently fails-open to `false` on disk corruption or unreadable JSON. [rule: packages/daemon/CLAUDE.md § Diagnostic Discipline in Formulas]

5. `packages/daemon/src/mail.js:1391-1418` — JSDoc on `verify` should name the local-node-only restriction (cross-node `===` returns `false` even on truthful claims) and clarify that the default checks only the top link (deep verification is the caller's responsibility). [rule: designs/daemon-capability-persona.md § Open Questions]

6. `designs/daemon-capability-persona.md` — add a `## Status` prose section after the metadata table listing the near-term implementation that landed in PR #306 (file paths, deferred items). Leave the metadata `Status: Not Started` per the PR body's reasoning. [rule: designs/CLAUDE.md § Document Structure]

7. `.changeset/daemon-persona-epithets.md` — rewrap to sentence-per-line. [rule: packages/CLAUDE.md § Markdown Style]

8. `packages/daemon/test/endo.test.js` (`persona:` test block) — add (a) a backward-compat persistence test (load a pre-PR handle formula via direct write; confirm `epithets()` returns `[]`) and (b) a verify-self test (`E(h).verify(h, ...)` returns `false`). [rule: skills/regression-evidence/SKILL.md § migration paths warrant migration tests]

## Branch and rebase

The PR's head as of the judge's terminating round is `b6f332621` on branch `feat/daemon-capability-persona`. The fixer pushes to the same branch in detached-HEAD style: `git push origin HEAD:feat/daemon-capability-persona`.

## Verify before push

After applying the bundle, run `yarn format`, `yarn lint`, and the daemon's `npx ava test/endo.test.js --timeout=120s` (the persona subset of which lives at the tail of `endo.test.js`) per `packages/CLAUDE.md` § Pre-PR checklist. CI is currently 25/25 SUCCESS; the bundle should preserve that.

## Source of truth

The originating panel round entries:
- Round 1 result: `journal/entries/2026/05/20/020226Z-result-judge-907068.md`
- Round 2 result: (this judge dispatch's result entry; see `2026/05/20/` for the matching `result-judge-*.md`)
- PR: https://github.com/endojs/endo-but-for-bots/pull/306

completed_at: 2026-05-20T04:55:39Z
completed_by_role: steward
completed_by_host: endolinbot
completion: done
result_commits: f4aa40343,520c4b629,cb99e3332,ae8f80b6d,a9dce3992
