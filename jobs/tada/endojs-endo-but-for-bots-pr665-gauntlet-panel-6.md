The panel review is posted. Panel round 6 disposition is **must-fix**.

## Completion report

Ran gauntlet PANEL round 6 (single-round mode) against endojs/endo-but-for-bots PR #665 ("designs: release-automation notice for .js exports-key cleanup on major bumps"), a design-doc PR on branch `design/release-automation-major-bump-exports-trigger` (base `llm`, base SHA `80adff589f`, head `4b2670a41`).

- **Isolated project checkout** obtained via `ensure-project-worktree.sh` on the PR head.
- **Panel** run with `GARDEN_PANEL_SINGLE_ROUND=1`; terminal disposition: `must-fix`.
- **Verdict posted** to PR #665 as a `gh pr review`. Request-changes was rejected by GitHub ("Can not request changes on your own pull request" — the panel bot `kriscendobot` authored the PR), so I fell back to a `--comment` review with a bold `**Panel round 6 disposition: MUST-FIX**` header prepended to the full aggregate. Confirmed posted (COMMENTED, 18:38:02Z).

**Must-fix items surfaced this round** (design-panel seats): em-dash used 21× throughout the new design doc (forbidden — `skills/em-dash-style`); literal `…` (U+2026) ellipsis on two lines (needs ASCII `...`); plus request-changes findings from critic/skeptic/decomplector/novice on the design's own survey-evidence integrity (the "three spellings actually used" / bare-unquoted overclaim, the `lucky-planes-resolve.md` double-cited-yet-malformed contradiction, manifest immutability not structurally enforced, and forward-reference ordering). Orthographer approved; ergonomist comment-only.

**Follow-up:** the gauntlet driver posts the fix stage next (panel round-6 must-fix → fix round 6); I did not fix, un-draft, or loop, per single-stage scope.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr665-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (888563 cached reads)
- Output: 5364 tokens
- Cost: $1.0807645000000001
- Wall-clock: 420s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
