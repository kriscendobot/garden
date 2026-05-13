---
ts: 2026-05-13T21:50:21Z
kind: result
role: builder
project: cosgov
repo: dcfoundation/cosmos-proposal-builder
worktree: dispatches/builder--cosgov-pr-79-findings--20260513-214347--614810/project
prs:
  - repo: dcfoundation/cosmos-proposal-builder
    pr: 79
    role: source
refs:
  - entries/2026/05/13/214419Z-dispatch-liaison-614810.md
---

# Builder mirror + advised-next-steps comment on cosgov PR #79

Mirrored `dcfoundation/cosmos-proposal-builder#79` head (`4c08d9ce`) into `kriscendobot/cosgov` on branch `preflight-balance-check-chunked-bundles`, applied findings 1-5 from `/home/kris/cosgov-prompt.md` as a single commit (`66e3d1de64bba7052274580cd973e1c6dd60f962`), and posted one summary comment on PR #79 as advised next steps for the maintainers.

## Branch push

- Branch: `preflight-balance-check-chunked-bundles` on `kriscendobot/cosgov`.
- Push SHA: `66e3d1de64bba7052274580cd973e1c6dd60f962`.
- Compare URL: https://github.com/dcfoundation/cosmos-proposal-builder/compare/4c08d9ce740f4b9f9b14c9c79a58e4c8e0900f8c...kriscendobot:cosgov:preflight-balance-check-chunked-bundles

## Comment

- URL: https://github.com/DCFoundation/cosmos-proposal-builder/pull/79#issuecomment-4445475005
- Body: numbered next-steps for findings 1-6 (with finding 6 explicitly framed as "deferred, branches 1 and 2 covered transitively"), the prompt's out-of-scope list framed as "we did not pursue these intentionally", and a closing line inviting reviewers to pull the branch.

## Per-finding status

1. **Drop `bundleCost!` non-null assertion / opaque `!== false` admit pattern** — applied verbatim in `src/config/agoric/agoric.tsx`.
2. **Distinct toast for missing storage denom** — applied. Branches on `selectCoinBalance(...) === undefined` before computing `scaledAvailable`; emits "No `<scaledDenom>` balance found in wallet. Required: …" with `autoCloseToast: 3000` and preserves the prior "Insufficient funds. …" wording when the denom is present but short. Minor structural deviation: I hoisted the `txContext` computation above the new no-denom branch so both throw sites can reuse it (the alternative was duplicating the same three-line ternary in both arms). Behavior matches the prompt's specification.
3. **Remove dead `getBundleCost` from `CodeInputMethods`** — applied verbatim; `grep -rn "getBundleCost" src/` returns no matches after the edit.
4. **Tighten happy-path test** — applied verbatim; added `expect(validateCost).toHaveBeenCalledWith({ compressedSize: expect.any(Number), chunked: false, chunkCount: undefined })`.
5. **Pin `chunkCount` exactly in chunked test** — applied verbatim; computes the expected count as `Math.ceil(new TextEncoder().encode(validBundleJson).byteLength / 10)`.
6. **Three agoric.spec.tsx coverage tests** — skipped per the prompt's authorization. The current `agoric.spec.tsx` only renders tabs/forms; wiring wallet, queries, and a file upload to exercise the `validateCost` branches is heavy integration work and the harness pattern does not extend naturally. Branches 1 and 2 remain covered transitively through the `installBundle` spec. The PR comment calls this out explicitly so the maintainer can decide whether to land an integration fixture later.

## Local validations

Ran in the project worktree against the new HEAD (`66e3d1d`):

- `yarn tsc --noEmit`: clean (exit 0, no output).
- `yarn lint`: clean modulo the three pre-existing `react-refresh/only-export-components` warnings in `src/contexts/chain.tsx`, `network.tsx`, `wallet.tsx` (the prompt tolerates these).
- `yarn test:unit --run`: **23/23 tests passing across 6 files** in ~770ms. The tightened happy-path assertion (finding 4) and the exact `chunkCount` assertion (finding 5) both pass against the current `installBundle` implementation, which is the load-bearing check for both edits.

I did not watch upstream CI on dcfoundation/cosmos-proposal-builder; the branch lives on the fork and PR #79's CI tracks the upstream head, not our mirror.

## Commit trailer

The prompt explicitly authorized the `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` trailer for this single engagement; honored as written. Author/committer is `Kris Kowal <kriskowal@kriskowal.com>` (kriscendobot identity), trailer-only Claude attribution.

## Self-improvement

When mirroring an upstream PR into a fork for review-comment hand-off, fetch upstream **and** confirm the merge base matches the fork's main in the same step (one `git merge-base` call) — it prevents an otherwise-easy mistake where the topic branch ends up rebased onto stale main. I caught it for this dispatch because PR #79 had been rebased onto current main, but the verify step is cheap enough to make routine.
