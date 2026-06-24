---
ts: 2026-06-03T02:26:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: bf3051
prs:
  - { repo: endojs/endo-but-for-bots, pr: 393, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 394, role: cascade }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: cascade }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: cascade }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: cascade }
refs:
  - entries/2026/06/03/012858Z-dispatch-fixer-bf3051.md
---

# result: fixer — #393 Uint8Array sweep + types.d.ts cascade COMPLETE

Layer #393 settled + cascade through #394-#397 done. Big
dispatch: 5 PRs touched, full cross-stack byte-shape pivot.

## New heads + tests

| PR  | Phase | Head        | Tests |
|-----|-------|-------------|-------|
| 393 | 5     | 04eedbedf   | 243   |
| 394 | 6     | 629f4afa4   | 281   |
| 395 | 7     | fc3137d96   | 323   |
| 396 | 8     | 1b1266f00   | 365   |
| 397 | 9     | 38f206e5e   | 399   |

## Resolution of the makeExo / Uint8Array contradiction

The Phase 2 builder used immutable ArrayBuffer because
`M.any()` argument guards invoke @endo/marshal's pass-style
check which rejects mutable typed arrays. kriskowal's
directive flipped the wire convention to Uint8Array.

**Resolved cleanly via `M.raw()`**: byte-argument guards
switched from `M.any()` to `M.raw()` (bypasses pass-style
check). Byte shape validated in method body. Uint8Array used
exclusively at developer-facing API. Verified empirically:
`E(exo).method(u)` with `M.raw()` accepts Uint8Array in-realm
where `M.any()` throws "Cannot pass mutable typed arrays".

The cross-vat marshal question (where @endo/pass-style's
byteArray helper still requires immutable ArrayBuffer) is a
future concern that lands with the actual sock listener / WS
upgrade PRs.

## Architectural surprise warranting maintainer confirmation

Phase 3 (#389) and Phase 8 (#396) BOTH have a `ResourceLedger`
exo with different shapes:
- Phase 3's: only `listBalances`.
- Phase 8's: `getBalance`, `chargeBalance`, `purchaseTokens`,
  `setQuota`, `listBalances`.

The consolidated `types.d.ts` cannot export both under the
same name. Fixer renamed Phase 3's to `AdminResourceLedger`;
Phase 8's keeps the canonical `ResourceLedger`. Documented on
the review-thread reply.

## kriskowal review-thread reply

<https://github.com/endojs/endo-but-for-bots/pull/393#discussion_r3345555603>

## Self-improvement signals

1. `git rebase --skip` discards in-progress cherry-pick rather
   than committing it. For "I resolved the conflicts" use
   `git cherry-pick --no-commit <hash>` + manual resolve +
   `git commit`, not `--skip`. (Recovered by re-doing phase-9
   via cherry-pick.)
2. New `.d.ts` files in a monorepo with project-wide prettier
   CI gate need `yarn lint:prettier` (check-only) before
   commit, not just `yarn format` (write-then-confirm). The CI
   gate surfaces drift the writer step glossed over.

## Liaison disposition

Dispatch root torn down. Layers #388, #389, #392, #393 all
settled. Remaining feedback:
- #394 per-comment items (lewd constants, bitwise rule
  relaxation, one-repo-per-daemon redesign).
- #343 CLI subcommands + systemd follow-up.
