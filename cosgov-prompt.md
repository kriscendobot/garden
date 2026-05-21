# Hand-off prompt for follow-up agent

You are picking up PR #79 (`preflight-balance-check-chunked-bundles`) in the local repo at `/home/kris/cosgov-estimation`. The PR adds a pre-flight balance check that aborts a bundle install (chunked or non-chunked) before any `signAndBroadcast` call if the connected wallet cannot afford `costPerByte * compressedSize`.

## What's already merged into the PR

- **`src/installBundle/installBundle.ts`** — added optional `validateCost?: (info: { compressedSize: number; chunked: boolean; chunkCount?: number }) => void` to `InstallBundleParams`, invoked once after compression and after the `preflight` progress event but before any `signAndBroadcast` call. Throw-to-abort contract.
- **`src/config/agoric/agoric.tsx`** — `fallibleHandleBundle` provides a `validateCost` callback using `selectStorageCost(swingSetParams)`, `accountBalances.data`, `calculateBundleCost`, `hasSufficientBalance`, and `scaleToDenomBase`. Throws `Object.assign(new Error(msg), { autoCloseToast: 3000 })`; `handleBundle`'s catch turns it into a toast. Toast wording: `"Insufficient funds. ${scaledRequired} ${scaledDenom} required, only ${scaledAvailable} ${scaledDenom} available.${txContext}"` where `txContext` is ` This bundle would ship in ${(chunkCount ?? 0) + 1} transactions.` when chunked.
- **`src/components/BundleForm.tsx`** — the prior form-level "Insufficient funds to install bundle." check has been removed entirely; only the empty-bundle guard remains. The inline green/red hint in `CodeInput.tsx` is unchanged and still shows status.
- **`src/installBundle/installBundle.spec.ts`** — three tests: throw aborts before broadcast (non-chunked), chunked path passes `chunked=true` with a positive `chunkCount`, happy path proceeds.

CI is currently green on the latest commit (unit, e2e, netlify deploy-preview). The branch was rebased onto `main` which now also includes a `parseEnableChunking` helper and an "override" chunking mode — those are not part of this PR but they touch the same `agoric.tsx`. Do not revert them.

## Background facts you should not re-litigate

- `signAndBroadcast` (`src/lib/signAndBroadcast.tsx`) hardcodes fee `amount` to `0`. Per-tx gas fees are zero. Total on-chain cost = storage = `costPerByte * compressedSize`, identical whether bytes ship in 1 tx or N+1 txs (manifest carries no payload bytes; `chunkBundle` in `src/installBundle/bundle.ts` tiles the compressed bytes exactly).
- The only production caller of `installBundle()` is `agoric.tsx`. CoreEval / Inter / ProposalForm paths do not carry bundle bytes, so they correctly do not need this check.
- 12 reviews were run on the post-rebase state. The aggregated findings I'm asking you to act on are the high-signal items only.

## Your task: implement findings 1–6 from the aggregated review

1. **Drop the `bundleCost!` non-null assertion and the opaque `!== false` admit pattern.** In `src/config/agoric/agoric.tsx:158-160`, replace
   ```
   const bundleCost = calculateBundleCost(costPerByte, compressedSize);
   if (hasSufficientBalance(bundleCost, balances) !== false) return;
   const [required, denom] = bundleCost!;
   ```
   with an explicit guard:
   ```
   const bundleCost = calculateBundleCost(costPerByte, compressedSize);
   if (!bundleCost) return;
   if (hasSufficientBalance(bundleCost, balances)) return;
   const [required, denom] = bundleCost;
   ```
   This is a pure clarity/safety improvement; behavior is unchanged because the `null` branch is unreachable for any non-empty bundle (and `validateBundleJson` rejects malformed input upstream).

2. **Distinct toast when the wallet holds no balance for the storage denom.** In the same `validateCost` callback in `src/config/agoric/agoric.tsx`, branch on `selectCoinBalance(accountBalances, denom) === undefined` before computing `scaledAvailable`. Emit `"No ${scaledDenom} balance found in wallet. Required: ${scaledRequired} ${scaledDenom}.${txContext}"` for that case; keep the existing `"Insufficient funds. ..."` wording when the denom is present but insufficient. Both still throw with `autoCloseToast: 3000`.

3. **Remove the now-dead `getBundleCost` from `CodeInputMethods`.** In `src/components/CodeInput.tsx`, drop the `getBundleCost?: () => [amount: number, denom: string] | null;` field from the `CodeInputMethods` interface (~line 31) and the corresponding `getBundleCost: () => bundleCost,` line from the `useImperativeHandle` block (~line 72). The only consumer was the form-level check that this PR removed. Verify with `grep -rn "getBundleCost" src/`.

4. **Tighten the happy-path test.** In `src/installBundle/installBundle.spec.ts`, the third test currently only asserts call counts. Add `expect(validateCost).toHaveBeenCalledWith({ compressedSize: expect.any(Number), chunked: false, chunkCount: undefined })` to lock the contract shape on the happy path.

5. **Pin `chunkCount` exactly in the chunked test.** In the same spec, replace `expect(seen[0].chunkCount).toBeGreaterThan(0)` with the explicit invariant matching `Math.ceil(compressedBundleBytes.byteLength / chunkSizeLimit)`. Since the `gzip` mock is identity (`async (bytes) => bytes`) and `chunkSizeLimit: 10`, the expected value is `Math.ceil(validBundleJson_byteLength / 10)`. Compute the expected size from `new TextEncoder().encode(validBundleJson).byteLength` and assert exact equality.

6. **Add three agoric.spec.tsx coverage tests (optional if heavy).** The `validateCost` callback in `agoric.tsx` has three exit paths: missing `costPerByte`/`balances` throws "Cannot verify funds…"; sufficient balance returns silently; insufficient balance throws "Insufficient funds…" with the chunked txContext suffix when `chunked=true`. The existing `src/config/agoric/agoric.spec.tsx` only renders tabs/forms — wiring up wallet + queries + file upload to exercise these branches is heavy integration work. If the harness pattern in that spec extends naturally, add coverage. If not, skip this item and call it out — branches 1 and 2 are already covered transitively through the `installBundle` spec.

## Explicitly out of scope (don't do these, even if you see review comments suggesting them)

- BigInt migration for cosmos uint64 amounts (pre-existing pattern across the repo).
- Submit-button-disable race / in-flight guard (separate UX work).
- `await refetch()` inside an async `validateCost` (speculative refactor).
- Stale-closure-during-gzip mitigation (negligible window in practice).
- JSDoc on `validateCost` (codebase prefers no comments; symmetric `onProgress` is undocumented).
- Extracting the inline `validateCost` into a named helper (the file's `onProgress` callback at the same call site is comparably long; matches local convention).
- Negative-cost / malicious-RPC hardening (UX-only; chain consensus is the security boundary).

## How to work

- Use `Read`/`Edit` for the changes; don't write new files unless required (item 4/5 modifies an existing spec; item 6 modifies an existing spec).
- After edits, run `yarn tsc --noEmit`, `yarn lint`, and `yarn test:unit --run`. All must be clean (the lint output has 3 pre-existing fast-refresh warnings unrelated to this PR — ignore those).
- Commit on the current branch `preflight-balance-check-chunked-bundles` with a single commit. Use `Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>` in the trailer.
- Push and watch CI with `gh pr checks 79 --watch`. If anything fails, diagnose root cause and fix — don't skip hooks or force-push.

## When you're done

Reply with a one-paragraph summary of which items you completed, which you skipped and why, and the final CI status. Do not narrate intermediate steps; the user can read the commit diff.
