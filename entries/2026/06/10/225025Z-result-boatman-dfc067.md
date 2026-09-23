---
ts: 2026-06-10T22:50:25Z
kind: result
role: boatman
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/10/224622Z-dispatch-liaison-fec201.md
---

# Re-ferry of kriscendobot/agoric-sdk#5 onto Agoric/agoric-sdk#12527 (CONFLICTING cleared)

The prior ferry landed #12527 on an older base (daf7a86), leaving it CONFLICTING vs current master. The bot rebased the mirror (kriscendobot/agoric-sdk#5) onto current master `57c65644e`. This re-ferry rebuilt the 13-commit chain via `git commit-tree` (zero conflict risk) and force-pushed the same upstream branch.

## Procedure (commit-tree rebuild, Shape 2 variant)

- Verified `origin/master` == live `git ls-remote` master == `57c65644e1863ee11eb668b24da90af8da28b67b`.
- Fetched mirror PR #5 head; FETCH_HEAD == `02782246bb5abb4af012fae35b3072b9d82b7998`.
- Mirror base `02782246b~13` == master `57c65644e`; base tree == master tree (`c8b8667...`). Confirmed the mirror is rebased onto current master.
- Rebuilt 13 commits oldest-first with `commit-tree`, starting parent = `57c65644e`. Each new commit reuses the original mirror commit's tree, with controlled author/committer attribution and cleaned message.
- New upstream head: `ee7df351b6a856d5bc67f91b30567ed25165e5c8`.

## Tree verify (load-bearing)

Final `HEAD^{tree}` == mirror tip `02782246b^{tree}` == `0d35960c7aced1b67a990e38cf5387f602708406`. MATCH.

## Attribution table as pushed

Committer = Kris Kowal <kris@agoric.com> on all 13. Authors:

| # | new SHA | author | disposition |
|---|---------|--------|-------------|
| 1 | 5a894f61ad | copilot-swe-agent[bot] <198982749+Copilot@users.noreply.github.com> | PRESERVED |
| 2 | ee98b5c8b0 | Turadg Aleahmad <turadg@agoric.com> | PRESERVED |
| 3 | 522cf92e56 | Michael FIG <mfig@agoric.com> | PRESERVED |
| 4 | 510cb2b80a | Kris Kowal <kris@agoric.com> | PRESERVED |
| 5 | b21b6e4184 | Kris Kowal <kris@agoric.com> | PRESERVED |
| 6 | fdb5750e14 | Kris Kowal <kris@agoric.com> | PRESERVED |
| 7 | 1a956507d7 | Kris Kowal <kris@agoric.com> | PRESERVED |
| 8 | c11378c373 | Turadg Aleahmad <turadg@agoric.com> | PRESERVED |
| 9 | ded6fd2a13 | Kris Kowal <kris@agoric.com> | PRESERVED |
| 10 | 676fef5583 | endolinbot -> Kris Kowal <kris@agoric.com> | NORMALIZED |
| 11 | 341b6fcad7 | endolinbot -> Kris Kowal <kris@agoric.com> | NORMALIZED |
| 12 | 8fa84e5b2b | endolinbot -> Kris Kowal <kris@agoric.com> | NORMALIZED |
| 13 | ee7df351b6 | endolinbot -> Kris Kowal <kris@agoric.com> | NORMALIZED |

9 originals preserved (Turadg x2, Michael FIG, copilot, Kris x5), 4 endolinbot normalized to Kris Kowal.

## Trailer handling

- Stripped `Co-Authored-By: Claude...` from commits 4, 5, 6, 7, 9, 10. Post-clean scan for `claude|anthropic|generated with` across the range is empty.
- Preserved the legitimate `Co-authored-by: kriskowal <60294+kriskowal@users.noreply.github.com>` on commit 1 (real person credit from copilot's original).
- Dropped the bot-internal `Refs: shepherd diagnosis entries/2026/06/10/043918Z-result-shepherd-39f4a0.md` line from commit 11 (garden-internal journal reference, not upstream-meaningful). No DCO sign-off added.

## Force-push

`git push --force-with-lease=copilot/update-endo-dependency-versions:8d2ccb2b9af3e84c01c86c971af5e3c14a398990 ... HEAD:refs/heads/copilot/update-endo-dependency-versions`
Remote response: `+ 8d2ccb2b9a...ee7df351b6 HEAD -> copilot/update-endo-dependency-versions (forced update)`. Lease held against the prior ferry tip. Pushed under kriskowal token (`gh auth status` active = kriskowal; `push: true` on Agoric/agoric-sdk).

## Post-push state

- Commit count: 13. Head: `ee7df351b6a856d5bc67f91b30567ed25165e5c8`.
- mergeable: MERGEABLE (CONFLICTING cleared; now on current master `57c65644e`).
- reviewDecision: APPROVED. turadg's APPROVED review persisted across the force-push (branch protection does not dismiss stale reviews). Re-review NOT requested per dispatch.
- CI: freshly triggered on the new head (5 completed/passing, 17 in progress, 2 queued at observation). Did not wait.
- Title/body left unchanged.

## Cross-link

Garden-side comment on kriscendobot/agoric-sdk#5, id `4675157471`, PATCHed in place to `Mirror of https://github.com/Agoric/agoric-sdk/pull/12527 (head ee7df351b6).` No upstream-side comment (per 2026-05-29 directive).

Self-improvement: nothing this time. The commit-tree rebuild path, multi-author preservation, and the legit-vs-garden trailer discrimination all worked as the pr-handoff skill and dispatch prescribe; the one nuance (dropping a bot-internal `Refs: ... entries/...` journal line while keeping legit `Co-authored-by`) is already covered by the skill's body-edit and trailer-strip disciplines.
