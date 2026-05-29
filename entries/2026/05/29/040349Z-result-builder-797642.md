---
ts: 2026-05-29T04:03:49Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo
project: endo
to: "*"
short_id: 797642
refs:
  - entries/2026/05/29/035554Z-dispatch-builder-797642.md
  - https://github.com/kriscendobot/endo/pull/1
  - https://github.com/endojs/endo/issues/3289
---

# result: builder — kriscendobot/endo#1 draft, install-engines retry hardening

## Deliverable

- **PR**: <https://github.com/kriscendobot/endo/pull/1> (DRAFT)
- **Title**: `fix(benchmark): retry esvu installs in install-engines.sh (#3289)`
- **Base**: `master-052b048` (frozen-base branch on the fork)
- **Head**: `fix/3289-install-engines-retry`
- **Affected package**: `@endo/benchmark` (private; CI helper only)

## Change

Wrapped each `yarn dlx esvu install <engine>` invocation in
`install_engine_with_retry` (three attempts, five-second backoff).
Preserved the `are_engines_installed` short-circuit, the
`INSTALL_OUTPU_XS` / `INSTALL_OUTPU_V8` capture for the final-failure
diagnostic, the always-attempt-v8-after-xs semantics, and the
`chmod +x` + `eshost` tail. No CI YAML changes. Verified with a stub
against three paths (succeed-first, fail-then-succeed, always-fail)
plus shellcheck and `sh -n`.

## Pre-push-gate findings (out of scope; surface for orchestrator)

- `security-md-hash-uniform` failed on pre-existing SECURITY.md drift
  in `packages/immutable-arraybuffer/`, `packages/hex/`,
  `packages/panic/`. Same root cause the steward and contractor are
  already tracking via PR #357.
- `no-inline-import-jsdoc` flagged a pre-existing inline `import()`
  JSDoc in `packages/evasive-transform/src/index.js`.
- `yarn format` / `yarn lint --fix` attempted out-of-scope auto-edits
  to `packages/evasive-transform/src/index.js` and
  `packages/ses/src/compartment.js`; builder unstaged + reverted so
  the diff stays scoped to `install-engines.sh`. Prettier's in-scope
  trailing-whitespace nudge on the script's own lines 3 and 26 was
  kept.

No changeset added (CI helper shell script in a private package; the
past three commits touching this file shipped none).

## Self-improvement signal carried by the builder

`skills/frozen-base-branch/SKILL.md` § Scope enumerates
`kriscendobot/endo-but-for-bots` and `kriscendobot/agoric-sdk` as the
fork-side-PR forks; cross-org PRs against `endojs/endo` via
`kriscendobot/endo` are implicit. A *Notes from the field* row that
records "convention covers kriscendobot/endo: PR base+head both live
on the fork; boatman ferries to endojs/endo:master" would save the
next builder the same disambiguation pass. Gardener-shaped.

## Liaison disposition

- Dispatch root `dispatches/builder--797642/` to be torn down by the
  liaison after this entry.
- Next stage in the gamut is cleaner. The user's framing was "propose
  a PR based on master that addresses the underlying failure" — the
  draft PR meets that. The liaison hands the rest of the PR-creation-
  flow chain off to the steward's per-cycle scan rather than running
  the gamut in-session, since the user has named a separate task
  (designer dispatch for MCP gateway extension) and is in foreground
  mode.
