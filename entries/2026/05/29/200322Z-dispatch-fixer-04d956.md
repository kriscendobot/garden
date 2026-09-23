---
ts: 2026-05-29T20:03:22Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo
to: "*"
dispatch_root: /home/kris/dispatches/fixer--04d956
short_id: 04d956
prs:
  - repo: endojs/endo
    pr: 3276
    role: upstream
  - repo: endojs/endo-but-for-bots
    pr: 336
    role: mirror
refs:
  - https://github.com/endojs/endo/pull/3276#pullrequestreview-4388440170
  - entries/2026/05/21/174925Z-result-boatman-ef16be.md
---

# dispatch: fixer — carry naugtur's feedback from endojs/endo#3276 review onto the bot mirror

## Task

Address the review feedback at
<https://github.com/endojs/endo/pull/3276#pullrequestreview-4388440170>
(naugtur, MEMBER, state COMMENTED, submitted 2026-05-29T09:41:21Z) on
the bot-side mirror PR `endojs/endo-but-for-bots#336`. The single
inline comment is on `packages/ses/src/module-instance.js:379`:

> Is a situation possible where all calls to the deferring notify
> happen before `upstreamNotify` can be obtained? I was trying to
> come up with when that could happen and I thought of unused live
> bindings.

## Topology you are walking into

- **Upstream PR**: `endojs/endo#3276` (kriskowal-authored, OPEN,
  base `master`, branch `kriskowal-star-export-cycle-rename`).
  Current HEAD at the review time: `f4aad15aa73d854a0e74728fe3cc5f02b3f7c016`.
- **Bot mirror PR**: `endojs/endo-but-for-bots#336` (CLOSED on
  2026-05-22T00:22:20Z after the boatman ferried; branch
  `fix/issue-59-star-export-cycle` still exists at SHA
  `f89a2361e99d6c684035444322a1cda1bb4d2ab1`).
- Between the boatman's ferry (single squashed commit
  `702dc3a59` on 2026-05-21) and naugtur's review (today,
  `f4aad15a`), the upstream branch advanced. The bot mirror branch
  has not. Bring the mirror current to upstream state before
  applying the response, so the addressing-SHA you reply with is
  meaningful.

## Reading the comment

Naugtur is asking a *question*: can all the deferring-notify calls
fire before `upstreamNotify` is obtained? They suggest "unused
live bindings" as a plausible trigger. This is a substantive
technical question about a race / ordering invariant.

Both outcomes are first-class per `roles/fixer/AGENT.md` § Operating
norms:

- **Verified, no change needed** — if the code or its tests
  already prove the race cannot happen, reply with the
  file:line citations or a passing-test name and stop. No empty
  commit; the reply is the artifact.
- **Code change** — if the race or an analogous one is real,
  land the smallest fix (and a regression test demonstrating the
  prior failure mode), in a single follow-up commit on the
  mirror branch.

Read `packages/ses/src/module-instance.js` around line 379 and
trace the deferring-notify lifecycle before deciding.

## Mirror handling

- Branch `fix/issue-59-star-export-cycle` exists on
  `endojs/endo-but-for-bots` at `f89a2361`. Either:
  (a) reopen PR #336 and push the fixer's commits to the same
      branch (reopens with the original review thread context), or
  (b) close (already closed) + open a fresh mirror PR from the
      same branch (loses the prior thread, but cleaner if #336's
      review state would interfere).
  Prefer (a). If GitHub blocks reopen for any reason, fall back
  to (b) and surface the choice in the report.
- Sync the mirror branch to current upstream `f4aad15a` (rebase or
  cherry-pick of the upstream advance, whichever is cleaner) before
  applying the fixer's commit. The boatman ferried a single
  squashed commit upstream; the mirror's pre-ferry commit history
  is acceptable as the baseline.

## Authorization scopes for this dispatch

- **Mirror posting** (`endojs/endo-but-for-bots#336`): authorized
  by the repo's standing relaxation in
  `journal/projects/endo-but-for-bots/README.md` § Standing
  authorizations. Reactjis, comments, top-level summaries on the
  mirror PR are fine without per-action authorization.
- **Upstream posting** (`endojs/endo#3276`): NOT authorized in
  this dispatch. Do not post the reply on the upstream review
  thread. The fixer's reply lands on the mirror PR; the boatman's
  later mirror-cross-link convention can surface it upstream when
  the next ferry happens (or the maintainer can quote-cite by
  hand). Recording this restriction explicitly so the fixer does
  not assume the standing-relaxation extends to `endojs/endo`.

## Acceptance

- Mirror PR #336 (or a fresh sibling) carries the addressing commit
  (if a fix is warranted) or a top-level reply with the verified-
  no-change reasoning (if not).
- The mirror branch is rebased onto current upstream `f4aad15a`
  before any fixer-authored commit.
- A short top-level summary on the mirror PR records the
  disposition (fix landed at SHA X, or verified-no-change with the
  reasoning).
- `chore: Update yarn.lock` is a separate commit if dependencies
  moved (unlikely for an SES-internal fix).
- The result entry names the disposition, the addressing SHA (if
  any), and the upstream review URL.

## Notes

- The mirror branch's pre-ferry commit history is preserved; the
  fixer's follow-up commit (or commits) ride on top of the rebase.
- naugtur is a `MEMBER` of `endojs` (per the GH API
  `author_association` field). Under the gardener's 2026-05-29
  update to `journal/projects/endo-but-for-bots/README.md` §
  Authority structure (every commenter on `endo-but-for-bots` is
  maintainer-equivalent; the named non-exhaustive list does not
  enumerate naugtur but the general rule covers them), naugtur's
  review carries maintainer weight on this PR. On `endojs/endo`,
  the topic-scoped erights / maintainer-only rule still applies,
  but naugtur's `MEMBER` association on the upstream review is
  itself maintainer-equivalent there too.

## Report

Return:
- Disposition: fix-landed / verified-no-change / surfaced-for-
  separate-PR.
- Addressing SHA on the mirror branch (if applicable).
- Mirror PR state (reopened #336 or new PR number).
- One-line summary of the technical answer to naugtur's question.
- Final `Self-improvement: ...`.

The liaison writes the matching `result` entry on your return and
tears down this dispatch root.
