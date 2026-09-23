---
ts: 2026-05-20T05:09:22Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/034953Z-result-liaison-73cdf1.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 74
    role: source
  - repo: endojs/endo
    pr: 3241
    role: target
---

Fast-forward append on `endojs/endo#3241` from `endojs/endo-but-for-bots#74`. Source has one new bot commit addressing boneskull's review on the upstream PR.

## Identity discipline note

User changed their global `git config user.email` from `kris@cixar.com` to `kriskowal@kriskowal.com` immediately before asking for this ferry. **The boatman's hardcoded attribution default is updated for this dispatch from `Kris Kowal <kris@cixar.com>` to `Kris Kowal <kriskowal@kriskowal.com>`.** The change applies forward; prior ferries in the session used the old default and are not retroactively changed.

The upstream PR's existing two commits are authored as `Kris Kowal <kris@agoric.com>` (yet a third Kris Kowal email). After this fast-forward append the upstream history will be mixed (`@agoric.com` for commits 1-2, `@kriskowal.com` for new commit 3). That's the cost of fast-forward append over force-push; the user can decide later if a full attribution-uniformity recompute is wanted.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #74 (OPEN, non-draft, MERGEABLE, **CHANGES_REQUESTED** addressed by commit 3, CI 23 SUCCESS / 4 unknown / 0 FAILURE).
- Branch: `design/audit-module-source-visitors`
- Head: `cb735078`
- Three commits:
  1. `01380110 fix(module-source): support 'export * as ns from src'` — `Kris Kowal <kriskowal@kriskowal.com>` (2026-05-01). **Already on upstream as `ca45b793` (content-equivalent).** Do not re-apply.
  2. `e9631f57 fix(module-source): supply Babel Hub so reserved-id diagnostic reports cleanly` — `Kriscendo Bot <noreply@anthropic.com>` (Anthropic-bot identity; 2026-05-05). **Already on upstream as `c7fef87b` (content-equivalent).** Do not re-apply.
  3. `cb735078 fix(module-source): apply boneskull review comments from endo#3241 (#74)` — `endolinbot <main.barn5084@fastmail.com>` (2026-05-20). **The new commit to ferry.** Strip the `(#74)` bot-internal suffix during the amend; rewrite to `Kris Kowal <kriskowal@kriskowal.com>`. Translate the `endo#3241` reference in the subject — it's an upstream-equivalent reference (the upstream PR being ferried to) and naturally drops in the squash since the new commit IS landing on #3241.

Proposed new subject: `fix(module-source): apply boneskull review comments`.

## Upstream

- Repo: `endojs/endo`, PR #3241 (OPEN, non-draft, MERGEABLE, **APPROVED** by boneskull at 2026-05-07T17:54:04Z).
- Branch: `kriskowal-module-source-1596`
- Current head: `c7fef87bc415615848d9f33f8cd8ba55ad8510c4`. Two commits both `Kris Kowal <kris@agoric.com>`.
- Title: `fix(module-source): Fix AST traversal and hidden variable censor error #1596` (substantive; user did not ask for changes — leave untouched).
- Branch is not protected; the boneskull approval will persist across a fast-forward append.

## Human

`Kris Kowal <kriskowal@kriskowal.com>` (new default). **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-module-source-74--20260520-050914--ca9df6/`. Project worktree on `endojs/endo:origin/kriskowal-module-source-1596` (detached at `c7fef87b`).

## Boatman direction

- Detach at upstream tip `c7fef87b` (not master). Fast-forward append per the boatman wisdom branch.
- Cherry-pick **only** `cb735078`. Do not re-apply commits 1 or 2 (already on the upstream tip).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'` (NEW default, replacing the prior session's `kris@cixar.com`).
- `git commit --amend --reset-author --no-edit` first to set author/committer to the new default.
- **Then a follow-up `git commit --amend -m '<new subject>' -m '<body verbatim minus fork-only refs>'`** to:
  - Strip the `(#74)` suffix from the subject.
  - Drop the `endo#3241` reference in the subject (the new commit is landing on #3241; the reference is now self-referential).
  - Final proposed subject: `fix(module-source): apply boneskull review comments`.
  - Preserve the body, but drop any `endojs/endo-but-for-bots#74` references and any `Co-Authored-By: Claude` / `🤖 Generated with [Claude Code]` trailers (run `git interpret-trailers --parse` per the standing discipline regardless of preliminary inspection).
- Verify with `git log c7fef87b..HEAD --pretty=fuller`: one commit, author + committer `Kris Kowal <kriskowal@kriskowal.com>`.
- **Fast-forward push** (`git push origin HEAD:kriskowal-module-source-1596`), no `--force`. Pre-flight ancestor check.
- Verify post-push: `gh pr view 3241 -R endojs/endo --json reviewDecision,headRefOid` should show `APPROVED` preserved and the new head SHA.
- **Title and body untouched.**
- Source-side cross-link comment on `endojs/endo-but-for-bots#74`: post under whichever identity is authenticated (kriskowal on this host). Name the new upstream head SHA, the appended commit, and confirm fast-forward.
- **Identity discipline on `endojs/endo#3241`**: NO direct comments.

## Out of scope

- Title/body edits on #3241.
- Comments on the upstream PR.
- Re-applying the prior two commits (already there).
- Any source-side changes.

## Expected report

≤300 words:
- Upstream head SHA after push + new commit SHA.
- Attribution verified (`Kris Kowal <kriskowal@kriskowal.com>` — note the new default).
- Push mode confirmed as fast-forward.
- Source-side cross-link URL.
- boneskull-approval persistence check.
- One-line `Self-improvement: ...` — flag any observations about the new attribution default for the gardener brief.

If blocked, `message`-to-liaison and stop.
