---
ts: 2026-05-14T05:56:05Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/004700Z-dispatch-liaison-c5d710.md
  - entries/2026/05/14/021530Z-result-liaison-c34620.md
  - entries/2026/05/14/041650Z-message-liaison-dc1f5b.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: 3232
    role: target
---

Re-ferry #75 → #3232 (second pass; first pass landed at upstream `4d3c96994` per `entries/2026/05/14/021530Z-result-liaison-c34620.md`).

**Two complications since the last ferry**:

1. **Source PR #75 was rebased.** Old source tip `836928335` is no longer ancestor of new tip `bb24053ae`. Their merge-base is `c513f1ab`. The bot rewrote the source's history; logical content largely overlaps but SHAs are all new, plus 3 new commits at the top.

2. **Upstream PR #3232 was independently force-pushed by the user (kriskowal)**, not by the boatman. Old upstream tip `4d3c96994` (my prior force-push) is no longer ancestor of current upstream tip `04664e52e`. The user re-applied essentially the same logical content with deeper history (his own pre-rebase commits like `docs: Document thunk module policy` are now visible on the upstream branch).

3. **Three new bot-side commits since the prior ferry**:
   - `bb24053ae test(random): pin random = randomUint53 * 2 ** -53 equivalence (#75)` — new test
   - `ccb207c46 chore(changeset): consolidate chacha12 changesets per #75 review`
   - `35039ccee fixup(ocapn)!: revert gratuitous randomNumber rename (#75)` — REVERT, addresses prior over-rename

The first two are straight forward progress; the third is a maintainer-directed REVERT (gratuitous rename of `randomNumber` was bad, getting reverted). Both source and upstream content drift exists per `git diff bb24053ae 04664e52e` (mostly `.github/workflows/*` files that exist only on the upstream repo; one test file `packages/random/test/random.test.js` has 33 fewer lines on upstream — the boatman should investigate).

**Verification** (liaison-side, before dispatch):
- `chacha12-fast-check-test` package still present in source `bb24053ae` (chacha12 surface still has `{next, getState, clone, fillRandomBytes}` plus `makeChaCha12FromState`). Forward-progress invariants hold.

**Source**: `endojs/endo-but-for-bots#75`, branch `kriskowal-random-chacha12`, head `bb24053ae686f998403cdd4b08f26a095e9cc5c9`. State OPEN, MERGEABLE.

**Upstream**: `endojs/endo:kriskowal-random-chacha20`, current head `04664e52e6783a999750ea65c2255fbc29167326` (PR #3232).

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true**.

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--re-ferry-chacha12-75--20260514-055521--5ed7e5/`.

**Boatman direction**:
- Recompute the procedure from scratch (source was rebased; merge-base with upstream/master may have moved).
- Force-push to `kriskowal-random-chacha20` to update #3232. The prior tip `04664e52e` will be replaced; review-thread anchors on it will be invalidated. **Acceptable**: the user himself is the one who force-pushed it last, so the in-flight review-thread sensitivity is lower than for the gibson042-anchored thread on the original `b61c928e` (which the prior ferry preserved).
- Rewrite all commits to `Kris Kowal <kris@cixar.com>` (author + committer); verify zero bot trailers.
- **Identity discipline**: the explanatory PR comment and any title update on #3232 go via `message`-to-`steward` journal entry (per the rule landed at main `8580728` / journal `cac9cbb`). The steward (kriscendobot) posts on its next cycle. Source-side cross-link comment on `endojs/endo-but-for-bots#75` is fine to post directly.
- Investigate the `packages/random/test/random.test.js` 33-line drift; if upstream lost a test, surface that in the result entry (it might be intentional removal that would need to land in the source; or it might be a stale workflow file leak).

**Expected report**: upstream PR head SHA after force-push, attribution-verified, source PR forward-link comment posted, message-to-steward (with proposed comment body for #3232) committed, journal `result` entry, `Self-improvement: ...`. If anything blocks (the .test.js drift looks substantive, or the boatman discovers further divergence), `message`-to-liaison and stop.
