## Completion report

**Job:** `ebfb-retire-master-pr-251` (weaver) — retire the `master` base for endojs/endo-but-for-bots#251.

**Outcome: STOPPED and reported — did NOT force the rebase. No fork mutation of any kind.**

### What I found
- PR #251 is **open**, targets `master`, mergeable status `CONFLICTING`, last updated 2026-05-22 (~2 months idle). Head `feat/harden-exports-destructuring` (4 commits) sits on base `c2fc02e`, which is **187 commits behind** upstream `endojs/endo` master (tip `46d4edf`).
- The fork (`endojs/endo-but-for-bots`) `master` (`fcbb540`) has diverged from upstream endo master — confirming the base-drift the sweep targets.
- The frozen reflection **`master-46d4edf` already exists** on the fork, pointing exactly at upstream endo master tip — reuse, no push needed.

### Why I did not wedge it
Attempting the rebase onto `46d4edf` produced a **modify/delete conflict**: upstream deleted `packages/eslint-plugin/lib/rules/harden-exports.js` (the eslint-plugin package was restructured — `lib/rules/` → `src/rules/`, converted to `createRule`/ESLint 10 in commit `e352f0f`). More fundamentally, **the PR's premise is superseded upstream**:
- PR #251 mirrors **endojs/endo#2404** ("support destructuring in harden-exports"), which is **CLOSED, never merged** upstream.
- The equivalent functionality already landed on endo master via **endojs/endo#2390** (destructuring patterns) + **endojs/endo#2632** (skip `M.*` pattern makers). Upstream's `src/rules/harden-exports.js` already contains the `pushDeclaredNames`/`ObjectPattern`/`ArrayPattern` logic this PR adds.

Rebasing onto upstream master would therefore produce a redundant, heavily-conflicting change — **beyond a focused weave**, and the classic stale-mirror / premise-no-longer-holds case the job body and weaver norms carve out as report-not-force.

### Actions taken
- Read-only investigation in an isolated project worktree; local rebase attempt **aborted**. Verified PR head unchanged (`8626e5d` == remote), no rebase in progress, **nothing pushed to the fork**, fork master untouched, PR base unedited.
- Messaged the maintainer (via liaison inbox, delivered `20260717T121433Z-3cdeec`) with the finding and recommendation.

### Follow-up for the maintainer
**Recommend closing endojs/endo-but-for-bots#251 as superseded-upstream** — its intent already lives in endo master (via #2390 + #2632 + the ESLint-10 restructure) — rather than rebasing. The `master-46d4edf` reflection is already present on the fork should a different disposition be chosen later.
