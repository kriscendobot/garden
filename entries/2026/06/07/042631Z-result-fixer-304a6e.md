---
ts: 2026-06-07T04:26:31Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    head_before: 584d06da35cd9dac38ef299d6d7f7538513630c4
    head_after: b7e7bd932a5fda0b3879564eec129096defc33ef
    moved: true
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4444359521
  - https://github.com/endojs/endo-but-for-bots/pull/403#discussion_r3368709228
  - https://github.com/endojs/endo-but-for-bots/pull/403#discussion_r3368718324
  - https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4641410518
---

# result: fixer addressed kriskowal's partial CHANGES_REQUESTED on PR #403

Both inline asks from review 4444359521 ("Partial review.") landed as follow-up commits on `feat/registry-capability`. PR left DRAFT and no re-request of review per the dispatch brief's explicit constraints; reviewer keeps the partial-review framing intact.

## The two surfaced asks

1. **Inline 3368709228** on `packages/registry-capability/test/store.test.js:9` ("Please use `@endo/bytes` to consolidate text encoder instantiation"). The original test built a per-file `const encoder = new TextEncoder();` and called `encoder.encode(s)` at each call site. Replaced with `bytesFromText` from `@endo/bytes/from-string.js`, the project's standard wrapper that captures a single shared `TextEncoder` at module load and avoids post-lockdown global redirection.

2. **Inline 3368718324** on `packages/registry-capability/src/store.js:49` ("This is a binding to platform-specific powers which creates excess coupling to a particular platform. Please note the pattern for other platform-specific powers like `daemon-node-powers.js` vs `daemon-web-powers.js`, or myriad examples in `@endo/platform`. This might be best ejected to an `@endo/sha256` package."). Decoupled the in-memory CAS store from `globalThis.crypto.subtle` by making the digest a caller-supplied power.

## Commits landed (in order)

| short SHA | subject |
| --- | --- |
| `003f1990` | `test(registry-capability): use @endo/bytes for text encoding in store tests (#403)` |
| `c91c2504` | `refactor(registry-capability): decouple in-memory CAS store from platform sha256 (#403)` |
| `b7e7bd93` | `chore: Update yarn.lock` |

Push: `git push origin HEAD:feat/registry-capability` succeeded, fast-forward `584d06da3..b7e7bd932`.

## Decoupling shape (commit `c91c2504`)

- `packages/registry-capability/src/store.js`: `makeMemoryCasStore` now takes a required `sha256` field in its options. The freestanding `sha256Hex` export is removed; the store performs no platform detection.
- `packages/registry-capability/src/store-web-powers.js`: new module exporting `sha256HexWebCrypto`, the Web Crypto wiring previously baked into `store.js`. A Node-only host that prefers `node:crypto.createHash` can supply its own equivalent without the package dragging Web Crypto into a context where it is not available.
- `packages/registry-capability/types.d.ts`: new `Sha256Hex` type alias for the digest power signature.
- `packages/registry-capability/index.js` and `package.json`: re-export the new entry points and publish `./store-web-powers.js` as a path export.
- Two new tests guard the decoupling from the observable side: one verifies the store refuses to construct without a `sha256` power (so a future regression that re-binds to a global cannot pass silently), and one verifies the store actually calls the caller-supplied digest with a stub power.
- `README.md` and `CHANGELOG.md` reflect the new shape.

I kept `sha256HexWebCrypto` inside this package rather than ejecting to a standalone `@endo/sha256` (the alternative the reviewer floated as "might be best..."); the eject felt like a larger architectural move that could ride its own PR. Called this trade-off out in the inline reply on thread 3368718324 with an offer to do the eject in a follow-up if the maintainer prefers.

## Pattern provenance

The `daemon-node-powers.js` / `daemon-go-powers.js` split the reviewer cited: both modules expose `makeCryptoPowers(crypto)` which returns a `makeSha256()` factory the persistence layer consumes via `cryptoPowers.makeSha256()` rather than touching a global. The store-web-powers module follows the same shape at a smaller scale (no factory wrapper, just the digest function itself, since the store has no other crypto needs at layer 1).

## Replies posted

- Inline thread 3368709228: reply `3368743360` citing commit `003f1990`.
- Inline thread 3368718324: reply `3368743463` citing commit `c91c2504`, naming the Web/Node power split and offering the `@endo/sha256` eject as a follow-up.
- Top-level summary on PR #403: comment `4641410518` listing both items, their commits, the explicit no-re-request stance, and the local-verification results.

## Verification

- `yarn ava` in `packages/registry-capability/`: 25 / 25 tests pass (was 23 before the powers refactor; the refactor adds two new guard tests).
- `yarn lint` in the same package: clean.
- `pre-push-gates` `no-non-ascii-in-source` probe on staged scope: pass. (The probe also flagged pre-existing `§` characters in unchanged lines of `src/errors.js`, `src/interfaces.js`, `src/reference-backend.js`, and `src/store.js`; these are pre-PR-#403 state, not regressions introduced by this dispatch. Same for `sentence-per-line-md` on README lines 26, 46, 47 which were not touched by the dispatch.)
- Repo-wide `yarn build:types`: no `registry-capability/` errors. (Unrelated errors in `packages/chat/*`, `packages/chat-network-view/*`, etc. are pre-existing.)
- The auto-format stage of pre-push-gates wanted to reformat several unrelated packages (`packages/daemon`, `packages/endo-fs`, `packages/ses`, etc.); reverted those out before committing so the PR's diff stays scoped to `registry-capability/`.

## Constraints honored

- DRAFT state unchanged (PR was DRAFT, stays DRAFT).
- No `gh api .../requested_reviewers` call. The dispatch brief is explicit: partial review, maintainer returns to finish.
- No new top-level review thread or substantive design comment beyond the summary acknowledging the two addressed asks.

Self-improvement: nothing this time. The dispatch was a clean two-inline-comment turnaround under explicit constraints; both the decoupling pattern (platform-specific powers) and the bytes-helper consolidation are already documented in the project's own CLAUDE.md files and the daemon's existing modules. The hardest call (whether to also eject to `@endo/sha256`) was correctly resolved by surfacing it as an offer rather than acting unilaterally on the reviewer's tentative "might be best".
