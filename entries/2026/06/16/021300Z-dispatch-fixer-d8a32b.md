---
ts: 2026-06-16T02:13:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d8a32b
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
  - repo: Agoric/agoric-sdk
    pr: 12734
    role: upstream-source
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/Agoric/agoric-sdk/pull/12734
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4714030910
---

# dispatch: fixer — absorb upstream PR #12734 onto mirror PR #5

Maintainer directive (kriskowal on PR #5, 2026-06-16T01:32:51Z):

> @kriscendobot Please absorb the changes in https://github.com/Agoric/agoric-sdk/pull/12734, favoring solutions pursued there over overlapping solutions pursued here.

Upstream PR `Agoric/agoric-sdk#12734` by turadg ("chore: Sync Endo dependency versions") has 10+ commits and 30 file modifications. Key commits:

- `92c2b45f1f` ci: fix get-packed-versions.sh
- `a0ee462e72` chore(deps): sync Endo to latest including ses 2.x
- `d5bf55a1ae` chore(deps): remove obsolete Endo patches
- `8ca45b84ed` fix(types): recover TestFn typing past ses-ava wrapTest
- `80c4039141` refactor(types): adopt Endo CastedPatern narrowing
- `b973cad92e` fix: narrow getStoreKey return guard
- `4774f770f9` chore(types): declare chainstorage fn returns
- `d2565ac710` chore(types): Pattern inference accomodations
- `2139945b46` chore(types): casts for Exo strictness
- `77b2d6d4ad` chore(types): fix zone lint:types errors

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `c2de346cc5` (post fixer 65b4a3 Float*Array endow).
- **Upstream PR #12734**, OPEN, head TBD (read fresh).

## Likely overlap with PR #5's history (replace ours with theirs where applicable)

Per maintainer directive "favoring solutions pursued there over overlapping solutions pursued here":

- **Type-fix work** — our fixer `ba72cd` applied `@ts-expect-error` markers on `packages/async-flow/` to recover TestFn typing past ses-ava wrapTest. Upstream commit `8ca45b84ed` may do this differently (better narrowing). **Prefer upstream's approach** — revert our `@ts-expect-error` commits if upstream's narrowing covers them.
- **Endo patch set** — our fixer `cb7a05` adjusted resolutions in `multichain-testing/package.json`. Upstream removed obsolete Endo patches and may have different patch shape. **Prefer upstream's patch set**.
- **Type casts in ymax-planner / SwingSet** — earlier commits per copilot may overlap with upstream's `80c4039141 refactor(types): adopt Endo CastedPattern narrowing`, `b973cad92e fix: narrow getStoreKey return guard`, `d2565ac710 chore(types): Pattern inference accomodations`, `2139945b46 chore(types): casts for Exo strictness`, `77b2d6d4ad chore(types): fix zone lint:types errors`. **Prefer upstream's casts**.

## NOT overlapping (preserve our work)

- **Float*Array endow** at SwingSet supervisors (fixer 65b4a3, `c2de346cc5`). Upstream has not touched this. Preserve.
- **dual-AVA install fix** in multichain-testing (fixer cc9bb5, `882f5257a8`+`46b5491dec`). Upstream may or may not touch — verify.
- **turadg's own parameterized bundle-source type** (fixer 994622, `e435b5cdca`). This was already turadg's suggestion; upstream likely matches.

## Task

In your `project/` worktree at `c2de346cc5`:

1. **Read upstream PR #12734 diff** in full (`gh api repos/Agoric/agoric-sdk/pulls/12734/files`) to enumerate exact files + line changes.
2. **For each upstream-modified file**, identify whether our PR #5 has a corresponding edit:
   - If our edit overlaps upstream's: replace ours with upstream's (`git checkout upstream/branch -- <file>` or surgical cherry-pick).
   - If our edit doesn't overlap: leave ours alone.
   - If upstream touches a file we don't: cherry-pick the file (or the specific change in it).
3. **For commits whose intent we share but implementation differs**, prefer upstream's implementation. Notably:
   - Revert our `@ts-expect-error` directives on `packages/async-flow/` and adopt upstream's `recover TestFn typing past ses-ava wrapTest` (commit `8ca45b84ed`) if it covers the same errors.
   - Revert any of our type casts that upstream's narrowing supersedes.
4. **Verify the Float*Array endow** (fixer 65b4a3's work) is preserved — it's our novel work per maintainer 4713916780; do NOT revert.
5. Run local verifications:
   - `corepack yarn workspace @agoric/fast-usdc-deploy test` (must still be 31/31 — Float*Array endow preserved).
   - `corepack yarn workspace @agoric/async-flow lint:types` (verify upstream's narrowing covers what our @ts-expect-error did).
   - `corepack yarn lint`.
6. Run pre-push-gates.
7. Commit per logical absorption group:
   - `chore: absorb upstream #12734 type-fix commits (replace local @ts-expect-error)`
   - `chore: absorb upstream #12734 patch set (replace local resolutions)`
   - (Skip if no change in a group.)
8. Push to `mirror/12527-endo-sync-refresh` (append only).
9. Post a top-level comment on PR #5 at-mentioning @kriskowal:
   - Per-area absorption summary (what we kept vs replaced).
   - Commit SHAs.
   - Preserved Float*Array endow + dual-AVA fix.
   - Recommend next OODA observation when CI settles.

## Authorizations

- Push to `mirror/12527-endo-sync-refresh` (append only).
- Top-level comment on PR #5.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT revert the Float*Array endow (fixer 65b4a3's substance).
- Do NOT revert the multichain-testing dual-AVA fix (fixer cc9bb5).
- Do NOT pursue test-dapp Class A (expected fail).

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Pre/post head SHAs.
- Per-area absorption summary.
- Commit SHAs.
- Local test results.
- pre-push-gates result.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: ooda-observation` when CI settles.

End your turn with a concise summary back to the orchestrator.
