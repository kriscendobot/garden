---
ts: 2026-06-14T07:36:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--c997e7
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4701061078
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/171830Z-result-shepherd-04c6a8.md
---

# dispatch: fixer — drive PR #5 CI to green by whatever means until impasse (kriskowal override)

Maintainer directive (kriskowal at 2026-06-14T07:34:19Z,
issue comment `4701061078`):

> @kriscendobot Please dispatch a fixer to address the
> remaining failures. Shepherd through to green CI. Please
> override the shepherd's directive for only surgical fixes.
> Please dispatch a gardener to relax the shepherd's
> standing instructions such that shepherds pursue a all
> tests passing in CI by whatever means necessary until
> reaching an impasse or success.

The 👀 reactji is on the directive.

**Companion gardener dispatch** `aa3d6f` runs in parallel to
relax the shepherd's role-file constraint for future
dispatches.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-57c6564`, head `mirror/12527-endo-sync-refresh` at
  `460035eb5d` (per shepherd `04c6a8`'s last push; FETCH if
  newer).
- **CI**: 47 SUCCESS, 7 FAILURE per shepherd's classification:
  - `test-dapp (node-new)`: MAINTAINERS env-acknowledge.
  - `test-quick (node-old)`, `test-quick2 (node-old)`,
    `test-portfolio-contract (node-old)`: `assert.ok(refs.runnerChain)`
    cascade. Node-engine-specific (node-new passes; node-old
    fails). Symbol is in ava/ses-ava internals.
  - `test-swingset (node-old, 2, 5)`: metering timeout
    (platform-tunable per test source).
  - `test-fast-usdc-deploy (node-new)`: needs re-verification.

## Task — drive to green by whatever means until impasse

**Override**: the shepherd's standing "only surgical fixes"
constraint does NOT apply to you. Per the maintainer:
"by whatever means necessary until reaching an impasse or
success." Means available include:

- **Targeted casts + ts-expect-error** (already applied by
  prior fixer 993833; extend if needed).
- **Workspace-level dep pins** (e.g., force a specific ava
  or ses-ava version that resolves the runnerChain on
  node-old).
- **Test-prelude shims** (e.g., introduce a workspace-level
  test setup that monkey-patches whatever is breaking).
- **Temporary matrix disablement** (per shepherd's
  alternative path: temporarily disable `node-old` for the
  endo sync PR; document as a TODO).
- **Rebase or reorder commits** if it materially helps
  (avoid if not necessary).
- **Patch refresh** if a patch is fighting the new versions.
- **Anything else short of upstream-tsgo-bug-fixing** that
  gets CI green.

**Impasse criteria**: stop only if:
- You hit a question that genuinely needs the maintainer's
  strategic decision (e.g., "should we disable node-old
  permanently?" — that needs the maintainer's call).
- A fix would require landing changes outside this PR's
  scope (e.g., upstream endo or @endo/ses-ava changes).
- Three or more iterations of the same fix-shape don't
  converge.

**Per-cycle discipline**:
1. Pull the failing logs for current red checks.
2. Pick the most-cascading issue and address it.
3. Push, watch CI re-run, classify what's left.
4. Repeat until green OR impasse.

**Post a status comment** on PR #5 every push cycle so the
maintainer can see progress.

## Authorizations (per-action, forwarded by liaison)

- **Force-with-lease or append push** to
  `mirror/12527-endo-sync-refresh` as needed.
- **Multiple push cycles** authorized.
- **Workspace-level dep changes** (yarn resolutions,
  catalog edits, package.json pins).
- **CI workflow disablement** (matrix entries, jobs) as a
  documented TODO if no other path works.
- **Top-level status comments** on PR #5 per cycle.
- **Re-request review** from kriskowal once green.
- **Escalate `next: liaison`** at impasse with specific
  question + evidence.

## Out of scope

- Do NOT touch upstream @endo packages directly.
- Do NOT amend the upstream PR Agoric/agoric-sdk#12527's
  cherry-picked commits beyond what's on this PR.
- Do NOT mark PR ready (maintainer un-drafts).

## Deliverable

A `result` entry under `journal/entries/2026/06/14/`
naming:

- Per-cycle commit + push log (SHA + scope + CI result).
- Final CI state.
- Per-failure final disposition.
- The status comment URLs (one per push cycle).
- Re-request-review URL (if green).
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: none` if green;
  `next: liaison` with specific question at impasse.

End your turn with a concise summary back to the orchestrator.
