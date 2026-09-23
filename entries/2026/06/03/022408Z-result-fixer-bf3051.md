---
ts: 2026-06-03T02:24:08Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
short_id: bf3051
dispatch_root: /home/kris/dispatches/fixer--bf3051
prs:
  - { repo: endojs/endo-but-for-bots, pr: 393, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 394, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: target }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/393#discussion_r3345555603
---

# result: fixer — kriskowal #393 stack-wide directive (Uint8Array + types.d.ts) applied across #393 → #397

kriskowal CHANGES_REQUESTED on #393 inline: "Apply this advice to this stack from top to bottom: Typedefs go in `types.d.ts`. Use `Uint8Array` as the sole unit of transmission for bytes."

Applied to every PR in the cascade with the same two-concern shape: byte fields drop the `ArrayBuffer | Uint8Array` union and use `Uint8Array` exclusively; typedefs move to a new `packages/gateway/src/types.d.ts` (re-exported via the package's top-level `types.d.ts`).

## Per-PR result

| PR  | Phase | New head SHA  | Commits | Tests |
| --- | ----- | ------------- | ------- | ----- |
| 393 | 5     | `2f9d2bff1`   | 2       | 243   |
| 394 | 6     | `1444e6c8e`   | 5       | 281   |
| 395 | 7     | `fdadab479`   | 2       | 323   |
| 396 | 8     | `659d77fc4`   | 2       | 365   |
| 397 | 9     | `c19a8ef60`   | 1*      | 399   |

`*` Phase 9's directive carry was combined with the feature commit because the rebase mid-conflict skip dropped the feature commit; the cherry-pick + directive-apply round-trip produced one combined commit.

## Uint8Array vs makeExo contradiction: resolved via M.raw()

The phase-2 builder reached for immutable `ArrayBuffer` because `M.any()` argument guards invoke `@endo/marshal`'s pass-style check, which rejects mutable typed arrays at the exo boundary. The directive's resolution is to switch byte-argument guards from `M.any()` to `M.raw()` (which bypasses the pass-style check) and validate the byte shape in the method body.

Verified empirically with a one-off ava test in the gateway package: `M.call(M.raw()).returns(M.promise())` accepts a `Uint8Array` argument via `E(exo).method(u)`; the same call with `M.any()` throws "Cannot pass mutable typed arrays". `harden(new Uint8Array(...))` returns a value with `Object.isFrozen=false` (the buffer cannot be frozen). The current `@endo/pass-style` byteArray helper still requires immutable `ArrayBuffer` with the `'byteArray'` passStyle tag (a Uint8Array view of an immutable buffer fails with "cannot serialize Remotables with non-methods like BYTES_PER_ELEMENT"); that's the cross-vat marshal constraint and lands as a future concern when the sock listener / WS upgrade PRs ship.

In-realm calls (which all tests exercise today) work through `M.raw()`. The exo's interface guards on byte arguments switch to `M.raw()` across `bootstrap.js`, `admin.js`, `relay-policy.js`, `ocapn-ws.js`, `git-http.js`, and `resource-ledger.js`. Internal validators check `instanceof Uint8Array` + length.

## Architectural surprise warranting confirmation

Phase 3 (#389) shipped an admin-side `ResourceLedger` interface with only `listBalances`. Phase 8 (#396) shipped a richer `ResourceLedger` (`getBalance`, `chargeBalance`, `purchaseTokens`, `setQuota`, `listBalances`). The consolidated `types.d.ts` cannot export both under the same name, so the phase-3 narrow shape is renamed to `AdminResourceLedger` and the phase-8 richer shape keeps the canonical `ResourceLedger`. The admin facet's `AdminDeps.resourceLedger` is typed `AdminResourceLedger` (any handle that exposes `listBalances`); the phase-8 concrete ledger satisfies this naturally because its surface is a superset. `GatewayPowers.resourceLedger` (external read-through option) is typed `AdminResourceLedger`; `GatewayPowers.verifyPaymentProof` (the package-owned-ledger option) routes through `getLedger()` returning the richer `ResourceLedger`.

This naming choice is documented in the #393 review-thread reply for kriskowal's review. If the maintainer prefers a different naming (`ResourceLedgerRead` vs `ResourceLedger`, or `ResourceLedger` vs `FullResourceLedger`), the swap is mechanical.

## Adversarial test

Per `skills/regression-evidence/SKILL.md`, the #393 layer adds one new adversarial test: `addCallerPublicKey(arrayBuffer)` is rejected with `/must be a Uint8Array/`. Sabotage-verified: temporarily relaxing the validator in `relay-policy.js` to accept ArrayBuffer reproduces the failure on the adversarial test. The regression evidence covers a future refactor that silently re-introduces the union type.

## kriskowal review-thread reply

https://github.com/endojs/endo-but-for-bots/pull/393#discussion_r3345555603

Cites the per-PR addressing SHAs and describes the makeExo resolution + the ResourceLedger naming choice. No top-level summary comment was authorized in the dispatch prompt, so the inline reply is the sole upstream artifact.

Self-improvement: when rebasing a stack of PRs onto a fixer-amended base, `git rebase --skip` discards the in-progress cherry-pick rather than committing it; reach for `git cherry-pick --no-commit <hash>` followed by manual conflict resolution + `git commit` instead. The `--skip` shortcut is appropriate only when the rebase has already detected "nothing to commit"; it is not a "I have resolved the conflicts" verb. Recovered by re-doing phase-9 via cherry-pick; one extra round of work.
