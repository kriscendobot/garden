---
ts: 2026-06-15T23:33:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--cc9bb5
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/15/230109Z-result-fixer-cb7a05.md
---

# dispatch: fixer — Class A retry on PR #5 multichain-testing runtime per kriskowal serial-CI

Prior fixer cb7a05 addressed Class A by adding SES-2-compatible resolutions to
`multichain-testing/package.json` and regenerating `multichain-testing/yarn.lock`.
Pushed as `cec9ed5c44` + `9216c5a936`.

**Result**: Class B (cosmic-swingset SIGHUP) DID transitively resolve. But Class A
multichain-testing imports.test.ts still fails with the SAME `null == true`
assertion signature on the latest CI run (`e435b5cdca`). The fix did not take.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `e435b5cdca`.
- **Failing**: lint-primary (multichain-testing eslint warnings + runtime imports.test.ts `null == true`).
- **CI log**: https://github.com/kriscendobot/agoric-sdk/actions/runs/27582269050/job/81545597094

## Task

In your `project/` worktree at `e435b5cdca`:

1. Verify the cb7a05 resolutions are present in `multichain-testing/package.json` and yarn.lock reflects single ses@2.2.0.
2. Read the failing CI log carefully. The signature is `AssertionError [ERR_ASSERTION]: null == true`. Identify what `null` was being asserted true.
3. The failure may be:
   - **Resolution didn't take**: yarn.lock still has dual ses — re-run resolution + lockfile regen, push to project (not a tmpdir).
   - **Different root cause**: maybe `makeStargateClient` returns null for a different reason than version drift (e.g., env var missing in CI, port unreachable, network setup).
   - **Test setup gap**: the imports.test.ts may need a `before` hook or CI-specific setup that's not in place.
4. Diagnose and apply the right fix.
5. Run local verification: `corepack yarn workspace multichain-testing test` or appropriate subset.
6. Commit + push to `mirror/12527-endo-sync-refresh`.
7. Post a top-level comment on PR #5 at-mentioning @kriskowal:
   - Confirm what cb7a05's fix did vs didn't do.
   - The diagnosed root cause.
   - The new fix + SHA.

## Authorizations

- Append-push.
- Top-level comment.

## Out of scope

- Do NOT pursue test-fast-usdc-deploy structural impasse (Class E, maintainer-decision).
- Do NOT touch upstream Agoric/agoric-sdk.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- Diagnosis (what cb7a05 did vs why imports.test.ts still failed).
- New fix SHA.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: fixer` for Class E (maintainer decision) or `next: liaison` if Class A is the final blocker.

End your turn with a concise summary back to the orchestrator.
