Review posted (COMMENT event, id 5111849046) with the must-fix verdict clearly headed — request-changes was forbidden because the bot authored the PR. All job steps complete.

## Completion report

**Panel stage — round 2, endojs/endo-but-for-bots PR #695** (`design/sturdy-refs-agent-surface`)

- Created an isolated project worktree of the PR head (fork owner `endojs`, branch `design/sturdy-refs-agent-surface`, head `2eab44c7db`).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against `origin/llm`. It sensed a **design** panel and fanned 7 seats (copyeditor, critic, decomplector, ergonomist, novice, pedant, skeptic); all 7 completed `ok`.
- Disposition: **must-fix** (panel exited RC=0 — decided cleanly). Recorded to journal `panel-runs/endojs-endo-but-for-bots-695/a5f2bd15006d.md`. Every seat requested changes; substantive must-fix findings centered on: the design's stated distributed-confinement invariant contradicting the live `GuestInterface` surface; the tool round-trip flow being unbuildable on the shipped sturdyref representation (missing CapTP box/unbox dependency, uncited sibling `sturdy-refs-endor-syscall.md`); phased-work ordering ahead of its own prerequisites; an admission table that mis-enumerates the real name-hub methods; and undefined load-bearing terms (`locator`, `formula`).
- Posted the full aggregate as a `gh pr review` on #695 (id `5111849046`). Used the **REST reviews endpoint with `event=COMMENT`**, not `gh pr review --request-changes`, for two reasons discovered at post time: (1) GraphQL rate limit was exhausted (0/5000; REST core had headroom), and (2) GitHub forbids `REQUEST_CHANGES` on a bot-authored PR ("Can not request changes on your own pull request"). The body is headed **"round 2 verdict: must-fix"** so the fix stage can read the must-fix items.

**Notes / follow-ups**
- Two prior attempts of this stage were reaped: headless `claude -p` exits at end-of-turn, so a backgrounded/`setsid` panel dies with the session (cgroup teardown). The panel only survives when the turn blocks on it in the **foreground** — that is how this attempt completed. Worth noting for panel-stage robustness.
- The gauntlet transition is driven by the stage-result marker below (→ `fix` stage `endojs-endo-but-for-bots-pr695-gauntlet-fix-2`).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 88 tokens (2564578 cached reads)
- Output: 21741 tokens
- Cost: $2.9096229999999994
- Wall-clock: 639s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
