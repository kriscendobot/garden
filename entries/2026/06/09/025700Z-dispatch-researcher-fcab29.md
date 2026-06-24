---
ts: 2026-06-09T02:57:00Z
kind: dispatch
role: steward
host: endolinbot
project: agoric-sdk
to: researcher
dispatch_root: /home/kris/dispatches/researcher--fcab29
refs:
  - https://github.com/Agoric/agoric-sdk/pull/12527
---

# dispatch: researcher — refs for agoric-sdk#12527 mirror+rebase+latest-endo builder

User directive (2026-06-09T02:50Z):

> Please dispatch a builder to create a mirror of
> https://github.com/Agoric/agoric-sdk/pull/12527 and rebase
> on current master. There has been an even more recent
> release of Endo packages, so please also instruct the
> builder to move to the latest versions published to npm.
> This may require some reconstruction of some commits or
> further adjustments to patches. Use the kriscendobot fork
> of agoric-sdk.

The downstream is a **builder** dispatch. Researcher precedence
applies.

## State at dispatch time

- **Upstream PR `Agoric/agoric-sdk#12527`** (`Sync Endo
  dependencies and refresh patch set`), branch
  `copilot/update-endo-dependency-versions`, head `a6212a8`,
  base `master`. 9 commits. Updated 2026-04-14 (almost 2
  months stale).
- **Bot fork `kriscendobot/agoric-sdk`** exists, default
  branch `master`, last updated 2026-05-12. **No prior PRs
  the garden has dispatched against this repo per the journal
  trail** (this is a new repo for the garden's active set).
- **Upstream master tip**: `ce854477ce8860142c81f731c70527040729ffb9`.

## What you should look for

- **Agoric SDK repository shape**: monorepo? packages
  layout? Where do Endo deps live (package.json fields,
  package-lock or yarn.lock)? Where do "patches" live (a
  `patches/` directory? per-package patch-package patches?
  the title says "refresh patch set" — what's the discipline)?
- **PR #12527's substance**: read the diff via `gh pr diff
  -R Agoric/agoric-sdk 12527 | head -100` or fetch the
  branch. Specifically: what Endo versions does it move to?
  What patches does it refresh?
- **Latest Endo npm versions**: query
  `npm view @endo/<package> version` for the key packages
  (`@endo/marshal`, `@endo/pass-style`, `@endo/captp`,
  `@endo/compartment-mapper`, `@endo/eventual-send`, etc.).
  The user said "more recent release" — surface the deltas
  the builder needs to land. Cross-reference what the PR
  proposed (mid-April version pins) vs current npm
  (2026-06).
- **Garden's authority on agoric-sdk**:
  - Per [`roles/COMMON.md`](../../../garden/roles/COMMON.md)
    § External-repo etiquette: comments / cross-refs require
    per-action authorization. The user's directive authorizes
    the builder to open the PR + post a body; subsequent
    actions need separate authorization.
  - Bot fork `kriscendobot/agoric-sdk`: standing
    authorization unclear. Likely opens PR from bot fork
    against `Agoric/agoric-sdk:master` (the upstream).
  - No standing monitor on agoric-sdk; new territory.
- **Memory references**: any prior agoric-sdk work in the
  journal? `grep -rl 'agoric-sdk' journal/entries/` — read
  any results.
- **Patch-management discipline**: agoric-sdk uses
  `patch-package` historically — the PR title's "refresh
  patch set" implies updating patches in `patches/` to
  match the new Endo versions. The builder needs to
  understand what patches exist, which need refreshing,
  and how to regenerate them.
- **Yarn/npm**: workspace structure, lockfile shape.
- **PR-shape conventions** for fork-side PRs on a new repo:
  frozen-base-branch convention applies; bot fork should
  use the same shape.

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the
standard `## Library and project references` section. The
steward will inline that section verbatim into the builder's
dispatch brief.

Five-to-seven minute wall time target (slightly longer
because this is a new repo for the garden — depth of walk
warranted).

No project worktree was prepared (journal-and-library work
only).
