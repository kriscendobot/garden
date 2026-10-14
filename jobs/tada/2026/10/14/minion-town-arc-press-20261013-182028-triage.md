# Triage report: minion.town arc press 2026-10-13 18:20

I closed two PRs this tick (#32 and #50) and classified the 50 that remain open in `kriscendobot/minion.town`. I made no implementation, merge or carry-job changes. I did not comment on issue 58 because no checklist box changed.

"Issue 58" is the arc tracker kriscendobot/garden#58, and "issue 89" is kriscendobot/garden#89 (the Claude-on-minion.town arc). I read the predecessor checklist report from fresh `origin/journal2`.

**Proxy screen:** `minion-town-screening.sh status` returned **active** (authorized by kriskowal, resumed 2026-10-09T08:46:29Z, base `*`).

## Closed (category 2: superseded or stale)
- **#50** (`whoami` tool): kriskowal asked for it to be closed in his 2026-09-05 review because minion.town does not do identity-based access control. Closed with that reason.
- **#32** (Endo daemon startup contract): its head moves the whole test suite to AVA and deletes `vitest.config.ts`. The maintainer has since made Vitest the house runner (directive on #87, carried by #108). The branch has been idle since 2026-09-05, and its objective is already checked. Closed; the comment says to rebuild the deploy-coherence guard fresh on Vitest if it is still wanted.

## Category 1: serves an unchecked garden#89 objective
| PR | Objective | Next verb |
|---|---|---|
| #183 (non-draft, CI green, head `07e6a4d9`) | #89 item 4, phase 3 | Proxy-screen decision. **Inconsistency:** the gauntlet verdict is `held-draft` (remaining phases belong to `minion-town-claude-kriscendobot-canary-after-connect-20261006`), but the PR is not a draft. The screen should re-draft it or confirm the ledger before any merge. |
| #167 (design, draft) | #89 items 4 and 6, root canary principal | Let the queued `pr167-gauntlet-20261013-undraft` run, then conduct. |
| #186 (draft) | #89 items 4 and 6, root canary build | Let the queued `pr186-gauntlet-panel-1` run. Its live validation is blocked on a maintainer login/MFA and on a missing `endolin-garden1` EC2 instance; both are already in the maintainer inbox. |
| #171 (draft) | #89 item 1, automatic production validation | Panel round 8 has run; continue the gauntlet to a terminal state. |

## Category 1: serves an unchecked garden#58 objective
| PR | Objective | Next verb |
|---|---|---|
| #93 (non-draft) | Garbage collector (credit-free half) | Weave onto a pinned base. Its screen gauntlet halted on a floating base, then re-run the gauntlet. |
| #126 (design) | Distributed CAS and DynamoDB | Maintainer review. |
| #123 (design) | Node replaced by endor | Maintainer review. |
| #124, #125, #127 (designs) | Persistence and sharding plan family, which feeds the #126 objectives | Maintainer review. |
| #144 (design, red CI, halted) | Credits governance and growth | Shepherd the `ci-billing-blocked` red CI, then re-run the gauntlet. |
| #85 (draft, review budget reached) | Clip publish capability (the publish half of the open primary box) | kriskowal wrote on 2026-10-02 "expand scope… run a gauntlet, and retcon". It needs a retcon, then the maintainer's merge/un-draft decision. |
| #142 (design, red CI, halted) | Clip lifecycle as capabilities (comes from #85's review) | Shepherd the CI billing failure, then re-run the gauntlet. |
| #88 (design) | Immutable clip and nonce locator (comes from #85's review) | Run the gauntlet to completion, as kriskowal asked on 2026-09-04; it was never finished. |
| #184 (draft) | Automatic validation for the checked #58 boxes (the prod probe under-fires) | Run the queued `pr180-panel9-pr184-panel5-resume-20261014` job. |

## Category 3: gap-revealing probes (stay draft; do not push toward merge)
- #105, #106, #115 and #116: the #89 item 4 inference tracks. On #106 the bot itself posted "hold, do not rebase or promote" until a Claude API token exists.
- Unmarked prototype: #84 (CLIPOMETER esbuild). It is conflicting, and its follow-ups are parked in `plan/`. Leave it.

## Live but not tied to a 58/89 objective
These belong to other arcs or are platform work. Nothing has superseded any of them, so none were closed.
- **git-remote arc:** #177, #178, #180 and #181. #180 needs panel 9 (queued); #181 is held until #180 converges, with fix-5 parked.
- **UI and guest shell:** #179, #170, #168, #129, #131 and #173. These are review-budget-reached or draft and await maintainer merge or un-draft. Per memory, production runs ahead of `main` for `guest.{js,html}` (#129), so this group needs a retcon before merge.
- **Shell-to-JS stack:** #151 → #152 → #153 → #154. #153 is halted on its fix-1 stage; the rest have reached their review budget. Next verb: fix #153, then merge the stack in order.
- **Other designs and docs:** #37 (approved 2026-08-21 but halted on a floating base; it needs a weave, and a build plan is parked), #78, #95, #101 (written by kumavis), #114, #121, #132, #133, #141 (still needed: `main` still says port 3003), #147.
- **Stale refresh asks the maintainer made on 2026-09-05:**
  - #58: e2e tests; conflicting. The ask was "refresh and run the gauntlet"; it needs a weave, then the gauntlet.
  - #59: transport documentation; already refreshed, needs a gauntlet.
- **Stale but not superseded:**
  - #82: conflicting. It is about OAuth MCP scopes, which the maintainer still allows.
  - #100: conflicting, CI red on the known baseline B1 failure.
  - #108: Vitest holdouts. Two `node --test` packages remain on `main`.
- **#102** (written by dckc): conflicting. Guest MCP invite is still unwired on `main` (`inviteRemote` throws), so the PR is not superseded. Leave it with its human author.

## For the successor (the carry slice)
- The highest-value carries are the #183 draft/non-draft mismatch, the #93 weave, and the queued #167, #186 and #184 gauntlet jobs.
- The maintainer review gate is still #167, plus the persistence designs #123–#127.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-arc-press-20261013-182028-triage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2234581 cached reads)
- Output: 13208 tokens
- Cost: $1.4811882000000003
- Wall-clock: 221s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
