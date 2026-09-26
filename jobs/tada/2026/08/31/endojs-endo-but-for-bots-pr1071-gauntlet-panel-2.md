Review posted. Panel round 2 complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1071 — gauntlet PANEL stage, round 2 (single round).

**What I did:**
- Resolved the PR head: `endojs/endo-but-for-bots` branch `design/ocapn-single-hint-per-transport`, head `733f3f5`, base `llm` (`beb5d47`). PR is a single design-doc change (`designs/ocapn-network-transport-separation.md`, +173/−60).
- Set up an isolated project worktree keyed to this job's base at head `733f3f5`.
- Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1071 beb5d47…`). It ran the 7-seat design panel (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice) and returned disposition **must-fix**.
- Posted the aggregate as a `gh pr review` on #1071. `--request-changes` is rejected by GitHub on the bot's own PR ("Can not request changes on your own pull request"), so it went up as a **COMMENTED** review carrying the full must-fix aggregate (submitted 2026-08-31T03:53Z, author kriscendobot).

**Verdict drivers (must-fix):**
- `advertisedAuthority` is load-bearing in the worked example but undocumented in prose and absent from every interface/contract (critic, skeptic, ergonomist, copyeditor, novice all flag it).
- The example's bind config (`port: 443`) contradicts the cited minion.town Caddy deployment (Caddy owns 443, proxies to `127.0.0.1:8931`) — the design's own grounding evidence (critic).
- The `codecName` "can't disagree" invariant is asserted in prose but not structural in the `OcapnNoiseTransport` interface, which exposes only a bare `codecName: string` and no `codec` object (decomplector, novice).

**Follow-ups:** none from this stage — I did not fix, un-draft, or loop (single-round mode by design). The next gauntlet stage (fix-loop) owns remediation. Note for downstream: the panel verdict is carried in the stage-result marker below, since request-changes could not be recorded as a review state on the bot's own PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1071-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (661307 cached reads)
- Output: 5301 tokens
- Cost: $0.9288884999999998
- Wall-clock: 404s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
