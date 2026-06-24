---
ts: 2026-06-11T00:09:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--2e38d5
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4458261628
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/235730Z-result-barrister-5a67ca.md
---

# dispatch: fixer — stage 3 of #403 gamut (4 MFL items + 6 summary-fix bundle)

Continuing the gamut on PR #403 after barrister `5a67ca`
returned 4 must-fix-loop + 6 summary-fix + 4 follow-up + 2
acknowledge + 1 drop.

Layer 4 deferral disposition: `follow-up` (defensible per panel
analysis), not must-fix-loop.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#403`, DRAFT, base
  `llm-c85d618`, head `feat/registry-capability` at
  `c0d348497b82be55a3e0975acdbe98f78d6a6818` (`c0d348497`).
  Dispatch-prepare picked up older `584d06da3` —
  **FETCH AND CHECKOUT `c0d348497` BEFORE STARTING**.

## Must-fix-loop items (per barrister verdict)

1. **PR body departs from upstream PR template** (cleaner
   flagged; panel confirmed). Rewrite the PR body following
   `.github/PULL_REQUEST_TEMPLATE.md`'s section structure.
   Strip file callouts and PR-number citations from narrative
   prose. Keep the substantive content (what landed in each
   layer, design departures, test coverage).
2. **`packages/exo-npm/src/snapshot-mapper.js:128-162`** —
   `entryDependencies` is built but never assigned to the
   entry compartment; descriptor is emitted with empty
   bindings. Real bug. Fix: ensure `entryDependencies` is
   wired into the compartment-map's entry compartment.
3. **`packages/exo-npm/src/mvs-resolver.js:591-592`** —
   offline-mode transitive walk is broken
   (`decodePackageJson('{}')` enqueues no edges). Real bug.
   Fix: source the package.json correctly for the offline
   transitive case (probably from a cached resolution rather
   than the empty stub).
4. **`packages/exo-npm/package.json:4`** — `description`
   field still names "(layer 1 of ...)" after README's
   layering bullets were removed. Update the description to
   match the new four-layer scope (or three-layer since Layer
   4 is deferred — designer's call based on what's currently
   shipped).

## Summary-fix bundle (6 items per barrister)

Read the barrister's review body
([pullrequestreview-4458261628](https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4458261628))
for the 6 summary-fix items in detail. Bundle them with the
MFL fix where appropriate.

## Task

In your `project/` worktree at `c0d348497` (FETCH + CHECKOUT
FIRST):

1. **Read** the barrister's full review body via
   `gh api repos/endojs/endo-but-for-bots/pulls/403/reviews/4458261628 --jq .body`
   for the 6 summary-fix items.
2. **Apply MFL-1 (PR body redraft)**: read
   `.github/PULL_REQUEST_TEMPLATE.md`; rewrite the PR body via
   `gh pr edit --body-file`. Preserve substance, conform to
   template. Strip file callouts and PR-number citations.
3. **Apply MFL-2 (snapshot-mapper.js entryDependencies bug)**:
   inspect lines 128-162. Wire the built `entryDependencies`
   into the entry compartment's bindings. Add or extend a
   test that asserts the entry compartment carries the
   expected dependency bindings — the absence of this
   assertion in the test surface is why the bug shipped.
4. **Apply MFL-3 (mvs-resolver.js offline transitive walk)**:
   inspect lines 591-592. Fix the offline-mode `decodePackageJson`
   call to source the package.json from the appropriate cached
   resolution rather than `'{}'`. Add or extend a test that
   asserts offline mode walks transitive deps correctly.
5. **Apply MFL-4 (package.json description)**: update to
   match the current scope.
6. **Apply the summary-fix bundle** in 1-2 commits per category.
7. **Run** `corepack yarn workspace @endo/exo-npm test`
   (+ any other affected workspace tests).
8. **Run pre-push-gates** in `project/` and confirm clean.
9. **Commit each MFL with a conventional commit message**:
   - PR-body edit doesn't take a commit (use `gh pr edit`).
   - MFL-2: `fix(exo-npm): wire entryDependencies into entry
     compartment in snapshot-mapper`.
   - MFL-3: `fix(exo-npm): source package.json from cached
     resolution in offline transitive walk`.
   - MFL-4: `chore(exo-npm): update package.json description
     to match four-layer scope`.
   - Summary-fix bundle: scoped per category.
10. **Push** to `feat/registry-capability` (append push only).
11. **Reply on the barrister verdict review** (top-level
    comment on PR #403 if review-replies endpoint is
    unavailable) citing each addressed item by commit SHA.
12. **Re-request review** from kriskowal.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `feat/registry-capability` (append
  push only; do NOT amend prior commits; do NOT force-push).
- **Edit the PR body** via `gh pr edit`. Standing fixer-on-
  body-redraft authority.
- **Top-level comment** on PR #403 with addressed-items
  summary. Standing.
- **Re-request review** from kriskowal once response is
  complete.

## Out of scope

- Do NOT address the 4 follow-up items (parked).
- Do NOT address the 2 acknowledge items (panel record).
- Do NOT chase Layer 4 (panel accepted the deferral).
- Do NOT rebase or force-push.

## Deliverable

A `result` entry under `journal/entries/2026/06/11/` naming:

- Pre/post branch tip SHAs.
- The MFL commit SHAs (one per item, where applicable).
- The summary-fix bundle commit SHAs.
- Per-MFL resolution: code change description + new test
  description.
- Test result.
- pre-push-gates result.
- The PR body before/after summary.
- The reply URL on the verdict review.
- The re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches justice for the re-run next and tears
down your dispatch root on return.
