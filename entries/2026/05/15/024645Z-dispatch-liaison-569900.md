---
ts: 2026-05-15T02:46:45Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/021448Z-result-liaison-af033c.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Follow-up re-ferry of `endojs/endo-but-for-bots#109` over `endojs/endo#3256`. The user asked to ferry again ~35 minutes after the prior two-commit re-ferry landed at upstream `b5c3168655`. The source has advanced by **one new commit**:

- `cfa440f2 chore: Update yarn.lock` (endolinbot, 2026-05-15T02:24Z)

The prior two commits (`24560074` syrup-frame package + `069c24d6` consumer opt-in) are still at the same SHAs in the bot-side branch. This is a clean append on the source side, not a rebase or restructure.

**Approach**: cherry-pick-on-prior-tip per the boatman wisdom branch (`entries/2026/05/14/061345Z-result-boatman-bf7290.md`). The upstream tip `b5c3168655` is healthy and represents the work intended; just append the yarn.lock commit on top with attribution rewrite. **No force-push needed** — a fast-forward push appends the new commit. This preserves kumavis's APPROVED review at its commit-OID anchor without any concern about dismissal.

**Source**: `endojs/endo-but-for-bots#109`, branch `feat/syrups-package`, head `cfa440f2c00b1ea9766473fc0452682a251befcd`. State OPEN, MERGEABLE.

**Upstream**: `endojs/endo#3256`, branch `feat/syrups-package`, current head `b5c3168655a98ef17534cf21bf0d2dcc47332d78`. State OPEN, APPROVED (kumavis). Current master is `0ec70c6dd`.

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true** (user asked for the ferry).

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109-yarnlock--20260515-024633--569900/`. Project worktree on `endojs/endo:feat/syrups-package` (detached). Note: the bare clone's `feat/syrups-package` ref may still point at the pre-ferry `acddddba` if the bare clone wasn't fetched since the prior ferry; the boatman fetches fresh and works from the actual upstream tip `b5c3168655`.

**Boatman direction**:

- Cherry-pick **just the new commit** `cfa440f2` onto the upstream tip `b5c3168655`. Do not re-apply the two prior commits — they're already there.
- Use the `cherry-pick + commit --amend --reset-author --no-edit` pattern with local `user.name`/`user.email` set to `Kris Kowal` / `kris@cixar.com`.
- **Fast-forward push** (`git push origin HEAD:feat/syrups-package`), not force-push. The new commit appends without disturbing the prior two commits or their review anchors.
- Strip bot trailers; verify with `git interpret-trailers --parse` and `git log b5c3168655..HEAD --pretty=fuller`.
- **Title and body untouched**. User did not ask for title/description changes; the existing PR shape (two commits, now three) still matches.
- Source-side cross-link comment on `endo-but-for-bots#109`: post a brief comment under whichever identity is authenticated (kriskowal on this host); short — name the new upstream head SHA and that the yarn.lock advance was appended.
- Identity discipline: no direct comments on `endojs/endo#3256`. Steward-routed comment unlikely to be useful for a one-commit yarn.lock advance.
- kumavis's APPROVED review should remain in place (no force-push means no risk of dismissal even with `dismiss_stale_reviews` enabled, though endojs/endo:master is not protected anyway).

**Expected report** (≤300 words): upstream head SHA after push, new commit SHA, attribution-verified, source-side cross-link URL, confirmation of fast-forward push (not force-push) and kumavis-approval persistence, one-line `Self-improvement: ...`. If anything blocks (a conflict on yarn.lock — should be impossible since the prior two commits already exist on upstream), `message`-to-liaison and stop.
