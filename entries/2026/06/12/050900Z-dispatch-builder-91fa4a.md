---
ts: 2026-06-12T05:09:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--91fa4a
refs:
  - https://github.com/Agoric/agoric-sdk/pull/12721
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/050700Z-result-researcher-034c20.md
---

# dispatch: builder — analogous tsgo migration on endo-but-for-bots (model Agoric/agoric-sdk#12721)

User directive (2026-06-12T~04:55Z): "Please dispatch a builder
to create an analogous migration in the endo-but-for-bots
repository for tsgo
https://github.com/Agoric/agoric-sdk/pull/12721"

Researcher `034c20` produced the references and a recommended
5-commit ladder. The full `## Library and project references`
section is in the researcher's result entry
(`journal/entries/2026/06/12/050700Z-result-researcher-034c20.md`)
— **read it verbatim** before starting.

## Headline findings (per researcher)

- **50 packages**; 49 declare `"lint:types": "tsc"`; only
  `packages/lockdown` lacks the script (analogous to agoric's
  `swingset-runner` exception).
- **tsgo not installed**. Add `@typescript/native-preview`
  alongside the `typescript` catalog entry at `.yarnrc.yml`.
- **No `tsconfig.quickcheck.json` exists** — skip that
  commit from the agoric ladder.
- **Reuse `tsconfig.json` for `typecheck-all`** instead of
  introducing `tsconfig.check.json` (minimum-diff approach;
  the existing workspace-graph excludes are already
  appropriate).
- **`build:types` stays on `tsc`** (composite emit via
  `tsc --build tsconfig.composite.json`) — tsgo
  declaration-emit parity isn't complete. Leave
  `tsconfig.composite.json`, `tsconfig-build-options.json`,
  and per-package `tsconfig.composite.json` alone.
- **CI surface: single `lint` job in
  `.github/workflows/ci.yml`** (single platform, no matrix).
  Add `typecheck-all` and `typecheck-packages` steps after
  `yarn lint`.
- **AGENTS.md is project-root only**. Add a "TypeScript
  Preview (tsgo)" section mirroring agoric's.
- **`packages/skel/package.json` is the uniformity template**
  (enforced by `scripts/check-package-uniformity.mjs`). Update
  its `lint:types` alongside the other 49.
- **`*.tsbuildinfo` is already in `.gitignore`** — no
  gitignore changes needed.

## Open questions for the builder

(per researcher; address each by best-design-signal or
document in PR body's "Design departures" section.)

1. Reuse `tsconfig.json` for `typecheck-all` vs introduce
   `tsconfig.check.json`. Researcher recommends reuse for
   minimum diff; builder can deviate if the workspace
   structure requires.
2. How does `tsd` (referenced in library section but not
   visible in per-package scripts) integrate? Builder
   inspects.
3. `lockdown` package: add a `lint:types` stub OR document
   a TODO exclusion (analogous to `swingset-runner`).
4. Renovate policy for the unpinned native-preview package.

## Task — 5-commit ladder (per researcher recommendation)

In your `project/` worktree at master (`4a04d078b`):

1. **Read** the researcher's full references section in
   `journal/entries/2026/06/12/050700Z-result-researcher-034c20.md`.
2. **Read** upstream PR #12721 in detail
   (`gh pr view 12721 --repo Agoric/agoric-sdk --json
   commits,files`) for the canonical patch shape.

### Commit 1 — Install tsgo

- Add `@typescript/native-preview` to the workspace catalog
  in `.yarnrc.yml` (alongside the existing `typescript`
  entry at `~6.0.3`). Pin a version that's known-working
  (consult agoric-sdk#12721's version for compatibility).
- Update yarn.lock as a separate `chore: Update yarn.lock`
  commit per the project discipline.

### Commit 2 — Sweep 49 packages' lint:types to tsgo

- Update `package.json:scripts.lint:types` from `tsc` to
  `tsgo` (or whatever invocation form agoric-sdk#12721 uses)
  across all 49 packages.
- Update `packages/skel/package.json` (uniformity template).
- Run `scripts/check-package-uniformity.mjs` to verify
  uniformity passes.

### Commit 3 — Root typecheck-all + CI wiring

- Add `typecheck-all` script to root `package.json` invoking
  tsgo against `tsconfig.json`.
- Update `.github/workflows/ci.yml` `lint` job to run
  `yarn typecheck-all` after `yarn lint`.

### Commit 4 — Root typecheck-packages + CI wiring

- Add `typecheck-packages` script that runs each workspace's
  `lint:types` (now tsgo) per-package.
- Update CI workflow to run `yarn typecheck-packages` after
  `yarn typecheck-all`.

### Commit 5 — AGENTS.md update

- Add a "TypeScript Preview (tsgo)" section to root
  `AGENTS.md` mirroring agoric's. Document `typecheck-all`
  and `typecheck-packages` and the division-of-labor
  (tsgo for lint:types and typecheck; tsc for build:types
  declaration emit).
- Update any CLAUDE.md / per-package AGENTS.md if needed.

### Optional commit — Renovate policy

If the researcher's Renovate concern applies, add a Renovate
configuration entry for `@typescript/native-preview` (pinning
strategy, update frequency).

### Final: yarn.lock + PR

- After all substance commits, ensure `yarn install
  --immutable` passes locally.
- Run `corepack yarn lint` + `yarn typecheck-all` +
  `yarn typecheck-packages` locally to confirm the new
  scripts work.
- Run pre-push-gates in `project/`.

## PR opening

- Open a **DRAFT PR** on the bot fork
  (`endojs/endo-but-for-bots`) targeting current master.
- Title: `chore(types): switch lint:types to tsgo for the
  dev loop` (mirroring upstream PR #12721's title).
- Body follows `.github/PULL_REQUEST_TEMPLATE.md`.
  Reference upstream PR #12721 with `endojs/endo-but-for-bots`
  qualification. Note the analogous mapping (which agoric
  changes apply, which were adapted, which were skipped).
- Document the design-departures decisions (reuse
  tsconfig.json vs new tsconfig.check.json; lockdown
  exclusion shape; Renovate policy).

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to the new branch on the fork. Branch
  name: `chore/lint-types-tsgo` or similar (builder
  chooses).
- **Open the DRAFT PR** on the bot fork.
- **No top-level comment** with at-mention to kriskowal
  needed; the PR opens the conversation.

## Out of scope

- Do NOT change `build:types` invocation (tsc stays for
  declaration emit).
- Do NOT touch composite-build infrastructure
  (`tsconfig.composite.json`, `tsconfig-build-options.json`,
  per-package composites).
- Do NOT touch packages outside the 49 + skel + root.
- Do NOT amend the cherry-picked upstream commits if the
  build cherry-picks any (the migration is a fresh write on
  endo-but-for-bots).
- Do NOT mark the PR ready; the gamut un-drafts at
  termination via the judge.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` naming:

- The new PR number/URL.
- The commit series (SHA + scope per commit; 5-7 commits
  expected).
- The open-question decisions (per the 4 from researcher).
- File-by-file change summary.
- Test results (`yarn lint`, `yarn typecheck-all`,
  `yarn typecheck-packages`).
- pre-push-gates result.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: cleaner` to start the
  gamut after substance lands.

End your turn with a concise summary back to the orchestrator. The
orchestrator continues the gamut and tears down your dispatch
root on return.
