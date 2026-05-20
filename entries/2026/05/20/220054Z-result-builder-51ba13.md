---
ts: 2026-05-20T22:00:54Z
kind: result
role: builder
project: endo
refs:
  - entries/2026/05/20/215539Z-dispatch-liaison-8d44fd.md
---

# Result: builder 8d44fd — mirror endojs/endo#2901 rebased and pushed; cross-fork PR-create blocked as expected

## Scope of the original PR

PR #2901 (*refactor: Embrace default chaining*, head `b42fac9e`) touches 3 files, +29 / -31 lines:

- `packages/captp/src/finalize.js`: collapse a manual `if (!wr) return wr; return wr.deref();` into `keyToRef.get(key)?.deref()`.
- `packages/compartment-mapper/src/bundle-lite.js`: replace `if (alias != null) { key = alias; }` + lookup with `modulesByKey[alias ?? key]`, plus split the not-found error into separate alias/no-alias messages.
- `packages/compartment-mapper/src/bundle.js`: same shape as `bundle-lite.js`.

Pure refactor; no behavior change beyond the more informative alias-failure error message.

## Rebase

`git apply --3way /tmp/2901.patch` applied **cleanly** to all three files. Zero conflicts. The 10-month-old patch landed against `ec3dcbc0c` (current master at dispatch time) without any 3-way fallback. Refactor is so localized that surrounding churn did not graze the hunks.

## Commit + push

- Branch: `mirror/2901-default-chaining` on `kriscendobot/endo`.
- Head SHA: `e5ffd0195aed4d29f5c73bd37db903e96985d64f`.
- Author: `Kris Kowal <kris@agoric.com>` (preserved from original).
- Committer: `endolinbot <main.barn5084@fastmail.com>` (bot identity).
- Subject: `refactor: Embrace default chaining` (matches original PR title).

## PR-create attempt

`gh pr create --repo endojs/endo --base master --head kriscendobot:mirror/2901-default-chaining --draft` failed with:

> GraphQL: kriscendobot does not have the correct permissions to execute `CreatePullRequest` (createPullRequest)

Expected per `entries/2026/05/20/051910Z-result-liaison-90f5ea.md`. Compare URL for maintainer ferry:

`https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/2901-default-chaining?expand=1`

## Lint

- `yarn workspace @endo/captp lint` → exit 0.
- `yarn workspace @endo/compartment-mapper lint` → exit 0.

Full `yarn lint` not run; the patch is confined to two packages, both green.

## Out-of-scope notes

- No new tests (refactor-only; the dispatch did not ask for any).
- No changeset (original PR carried none; refactor with no public API impact).
- Did not run the rest of the gamut; that is the liaison's next dispatch once the upstream PR exists.

Self-improvement: nothing this time.
