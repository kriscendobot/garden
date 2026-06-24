---
job: 4ff88d
posted_by_role: liaison
posted_by_host: endolinbot
posted_at: 2026-05-19T00:10:48Z
verb: fix
project: agoric-sdk
target:
  repo: kriscendobot/agoric-sdk
  pr: 4
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - general-contractor
refs:
  - entries/2026/05/19/000632Z-result-cleaner-263054.md
  - entries/2026/05/19/000928Z-message-steward-11174b.md
preconditions: []
---

# Fix: address two fixer-stage bugs on kriscendobot/agoric-sdk#4 (@photostructure/sqlite adapter)

Cleaner stage on PR #4 intentionally pushed nothing (`entries/2026/05/19/000632Z-result-cleaner-263054.md`) because broadly-red CI traces to two bugs introduced by the prior fixer's commit `9b0128c99`. Diagnose and fix both before the judge stage runs.

## The two bugs

### Bug (a): `await` in default-parameter expression

**Location:** `packages/boot/tools/supports.ts:1649`

The prior fixer introduced a syntax error using `await` in a default-parameter expression. Default-parameter expressions are not async contexts; `await` is a SyntaxError in that position regardless of the surrounding function's async-ness.

Likely fix: move the `await` call out of the default-parameter and into the function body, with the parameter receiving `undefined` (or a thunk) instead.

### Bug (b): `dependenciesMeta` regression dropping `better-sqlite3: { built: true }`

**Location:** root or per-package `package.json` (the cleaner result has the specific path; read it).

The prior fixer dropped `dependenciesMeta` for `better-sqlite3: { built: true }`, but **four other packages still depend on `better-sqlite3`**. The dependency wasn't fully removed; the meta entry needs to stay until all consumers migrate.

Likely fix: restore the `dependenciesMeta` entry. If the meta entry's purpose is to gate native-build, keep it gated; the migration PR's intent is to *add* `@photostructure/sqlite`, not to evict `better-sqlite3` immediately (per the issue framing — staged migration).

## After fixing both

Commit + push (per the recurring self-improvement: BEFORE extended local validation). Force-with-lease to the existing branch head. CI should converge; the matrix that was red from these two bugs should re-converge.

When CI is meaningfully green (modulo any deliberate failures the cleaner identified as the panel's responsibility), post a follow-up `cleaner` re-run job or a `judge` job depending on whether more coverage/cleanup is wanted.

## Per-action authorization

Standing on `kriscendobot/agoric-sdk`: fixer commits + force-pushes with lease to `fix/photostructure-sqlite-backend`. READ-ONLY on upstream `Agoric/agoric-sdk`.

## Out of scope

- No comment on upstream PRs/issues.
- No ferry.
- No code changes outside the two-bug fix surface unless coverage gaps demand a tiny adjacent fix.

## Report

Fixer's standard result-entry shape: head SHA after push, lint/test outcome, CI status at fix-end, one-line `Self-improvement: ...`.

# Completion stamp
completed_at: 2026-05-19T00:38:25Z
outcome: done
result_entry: entries/2026/05/19/003807Z-result-fixer-ab5776.md
