---
ts: 2026-06-13T05:57:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--6beb46
prs:
  - repo: endojs/endo-but-for-bots
    pr: 438
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697671329
  - https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482896738
---

# dispatch: fixer — apply panel-recommended routes for Gap 1 + Gap 2 on PR #438

Maintainer routing decision on PR #438 (kriskowal at
2026-06-13T05:55Z, issue comment `4697671329`):

> > Panel-recommended route: (a) Fix the root cause in
> > @endo/harden, then re-survey. The cascade is dominated
> > by a single root cause (the makeHardener callback
> > signature missing a `val is ...` type predicate)
> 
> Please try this.
> 
> > Panel-recommended route: (c) Open a resolutions for a
> > known-good earlier nightly as a short-term workaround,
> > paired with a bisect of the failing source file for an
> > upstream issue.
> 
> Please search for a working version of tsgo and pin a
> resolution.

The 👀 reactji is on the comment.

A **separate investigator dispatch** (1d8bb6) handles the
"isolate the tsgo defect and report through the journal"
ask in parallel.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#438`, DRAFT, base
  `master-4a04d07`, head `chore/tsgo-lint-types` at
  `a619bea05` (per recent activity; FETCH if newer).

## Task — two gap routings

### Gap 1: fix @endo/harden root cause

Per panel option (a) and maintainer's "Please try this":

1. **Read** `packages/harden/make-hardener.js:155` (and
   adjacent) to find the `makeHardener` callback signature
   missing the `val is ...` type predicate.
2. **Add the type predicate** to the callback signature.
   The exact JSDoc shape:
   `@param {(val: any) => val is SomeType} predicate` (or
   the appropriate `val is ...` shape based on the
   callback's contract). Inspect the current callback usage
   to determine the correct predicate type.
3. **Re-survey** the tsgo JSDoc cascade after the harden
   fix. Run
   `corepack yarn workspace @endo/harden lint:types` and
   then sweep the dependent packages
   (`corepack yarn typecheck-packages`).
4. If the cascade clears for most of the 39 affected
   packages, great. If a residual set remains, those need
   per-package JSDoc fixes (one commit per package or one
   commit per logical category).
5. **Commit** the harden fix:
   `fix(harden): add val is type predicate to makeHardener
   callback signature per kriskowal review`.
6. Per-package follow-on fixes get their own commits.

### Gap 2: pin a working tsgo via yarn resolutions

Per panel option (c) and maintainer's "Please search for a
working version of tsgo and pin a resolution":

1. **Search for a known-good tsgo nightly**. The current
   broken version is `7.0.0-dev.20260611.2`. Try the
   immediately preceding nightlies
   (`7.0.0-dev.20260610.*`, `7.0.0-dev.20260609.*`, etc.)
   to find one that doesn't crash on `typecheck-all`.
   Test by:
   - `npm view @typescript/native-preview versions` to see
     available versions.
   - For each candidate, set as override locally and run
     `corepack yarn typecheck-all`.
2. **Pin the working version via yarn `resolutions`** in
   root `package.json`:
   ```json
   "resolutions": {
     "@typescript/native-preview": "7.0.0-dev.20260610.X"
   }
   ```
   (Or whichever version works.)
3. **Update the `.yarnrc.yml` catalog** if appropriate (the
   catalog has the canonical pin; the resolutions block is
   the override).
4. **Run** `corepack yarn install --immutable` to verify the
   lockfile reconciles.
5. **Verify CI-equivalent** locally: `yarn typecheck-all`
   should now succeed.
6. **Commit**: `chore(deps): pin @typescript/native-preview
   to known-good nightly per kriskowal review (workaround
   for upstream Go panic)`.

### Final

- Run pre-push-gates.
- Push to `chore/tsgo-lint-types` (append push only).
- Reply on the directive comment `4697671329`
  at-mentioning `@kriskowal` summarizing:
  - The harden fix commit + cascade re-survey result.
  - The pinned tsgo version + how it was selected.
  - The separate investigator dispatch is tracking the
    upstream defect (link to journal entry).
- Re-request review from kriskowal.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `chore/tsgo-lint-types` (append push
  only).
- **Top-level comment** on PR #438 at-mentioning kriskowal.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT touch source outside `packages/harden/` and the
  root `package.json` / `.yarnrc.yml`.
- Do NOT chase the upstream tsgo defect investigation
  (separate investigator).
- Do NOT un-draft the PR (gamut continues via justice
  re-run after the maintainer's next response).

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` naming:

- Pre/post branch tip SHAs.
- Gap 1 commit SHA(s); cascade re-survey result (how many
  of the 39 affected packages now pass).
- Gap 2 commit SHA(s); the pinned tsgo version + selection
  rationale.
- Local test results (`yarn typecheck-all`,
  `yarn typecheck-packages`).
- pre-push-gates result.
- The reply URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.
- **Recommended next stage**: justice re-run on the gamut.

End your turn with a concise summary back to the orchestrator. The
orchestrator continues the gamut and tears down your dispatch
root on return.
