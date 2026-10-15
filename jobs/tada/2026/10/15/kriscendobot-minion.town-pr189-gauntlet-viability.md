**Viability: PR #189 can proceed** (kriscendobot/minion.town, "design(shell): narrow clip iframe embedding to Minion Town").

I only read state for this check. I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing.

Deciding question: Is it still true that no newer design or implementation has settled how the signed-in shell embeds live clips in iframes, and do current clip responses still refuse every frame ancestor? Yes on both counts.

Evidence:
- **PR state:** open, draft, not merged. It was opened at 2026-10-15T06:20Z and has no comments or reviews yet. It touches one file, `designs/clip-shell-framework.md` (+202/−74), with no runtime changes.
- **Base is current:** the base `main-ad0257e` (`ad0257e`) is identical to `main`, so nothing newer has landed on main since the PR was cut.
- **Premise still holds:** `src/endo/gateway/isolation-headers.ts` on main still sends `frame-ancestors 'none'` and `X-Frame-Options: DENY`. So the shell can still only show inert cards, which is the problem this design addresses.
- **Not superseded:** I searched all PRs for iframe / frame-ancestors / clip-shell work. The other open shell PRs (#179, #188, #190) cover gutter names, refresh and order, not iframe embedding. No other PR offers an alternative embedding contract.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (198727 cached reads)
- Output: 1292 tokens
- Cost: $0.3573774
- Wall-clock: 67s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
