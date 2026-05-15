---
ts: 2026-05-15T03:19:23Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/061345Z-result-boatman-bf7290.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: 3232
    role: target
---

Follow-up fast-forward ferry of `endojs/endo-but-for-bots#75` over `endojs/endo#3232`. The source has advanced by **two new bot-side commits** since the last ferry landed `f87bf84257` per `entries/2026/05/14/061345Z-result-boatman-bf7290.md`:

- `29979718 test(random): simplify magic-multiplier test to direct constant check (#75)` (endolinbot, 2026-05-14T23:03:17Z) — the `(#75)` parenthetical is bot-internal and should be stripped during the attribution-rewrite amend, same pattern as the recent #244 ferry which stripped `(fix lint job on #244)`.
- `8eb47912 chore: Update yarn.lock` (endolinbot, 2026-05-15T02:23:25Z) — clean lockfile.

The prior six commits (`e73cc37d` through `f87bf84257`) are intact at the same SHAs and already on upstream; do not re-apply them.

**Approach**: cherry-pick-on-prior-tip per the boatman wisdom branch. Fast-forward append, no force-push.

**Source**: `endojs/endo-but-for-bots#75`, branch `kriskowal-random-chacha12`, head `8eb4791204a0b1949b5d0bbfbf67261d696d533a`. State OPEN, MERGEABLE.

**Upstream**: `endojs/endo#3232`, branch `kriskowal-random-chacha20`, current head `f87bf84257dc848203503dbc24014db95527eb80`. State OPEN, REVIEW_REQUIRED, **MERGEABLE: CONFLICTING** against current master `0ec70c6dd`. The conflict is a pre-existing concern (the boatman wisdom comments in `entries/2026/05/14/061345Z-...` named a 33-line drift on `packages/random/test/random.test.js`); it is **not in scope for this ferry**. The boatman's job here is to bring the upstream head into sync with the source content, not to resolve the master-merge conflict. A future weaver dispatch can rebase #3232 onto master if the user asks.

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true** (user asked for the ferry).

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-chacha12-75-append--20260515-031908--efb1d3/`. Project worktree on `endojs/endo:kriskowal-random-chacha20` (detached). Note: source branch name differs from upstream (`kriskowal-random-chacha12` on source vs `kriskowal-random-chacha20` on upstream — the latter is the historical name from the original ferry pre-rename; per recent re-ferry pattern the upstream branch stays at this name).

**Boatman direction**:

- Cherry-pick **just the two new commits** (`29979718` and `8eb47912`) onto the upstream tip `f87bf84257`. Do not re-apply the prior six commits — they're already there.
- Use the `cherry-pick + commit --amend --reset-author --no-edit` pattern with local `user.name`/`user.email` set to `Kris Kowal` / `kris@cixar.com`.
- **Strip the `(#75)` suffix** from commit `29979718`'s subject during the amend; rewrite to `test(random): simplify magic-multiplier test to direct constant check`. Keep the body content as-is (only the bot-internal source-PR-number reference comes out).
- **Fast-forward push** to `kriskowal-random-chacha20` (no `--force` or `--force-with-lease`).
- Strip bot trailers; verify with `git interpret-trailers --parse` and `git log f87bf84257..HEAD --pretty=fuller`.
- **Title and body untouched.** User did not ask for title/description changes.
- Source-side cross-link comment on `endo-but-for-bots#75`: post under whichever identity is authenticated (kriskowal on this host); name the new upstream head SHA and confirm fast-forward append.
- Identity discipline: no direct comments on `endojs/endo#3232`. Skip steward routing unless something unusual surfaces.
- **The master-merge conflict is pre-existing and out of scope.** Surface it in the report so the user knows the state; do not attempt to rebase onto master.

**Expected report** (≤300 words): upstream head SHA after push, two new commit SHAs in order, attribution-verified, source-side cross-link URL, push mode (fast-forward), state of the master-merge conflict after push (still CONFLICTING is expected), one-line `Self-improvement: ...`. If anything blocks (cherry-pick conflict on the bot's own two new commits against the prior tip — unlikely since they were authored on top of the same six commits — or any other surprise), `message`-to-liaison and stop.
