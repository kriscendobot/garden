The round-6 panel review is posted. Panel disposition is must-fix.

## Completion report

**Job:** Gauntlet PANEL round 6 for endojs/endo-but-for-bots PR #1157 (`docs: design indelible registry in every guest inventory`), a design-only PR (`designs/npm-registry-indelible-guest-inventory.md` + `designs/README.md`), head `4041fd590` on `design/npm-registry-indelible-guest-inventory`, base `llm`.

**What I did:**
- Set up an isolated project worktree of the PR head.
- Resolved the real base SHA `e84a4c83c049f1b113436c0fcceddfb5be9be9a4` from the GitHub API (not the bare `llm` branch) per the origin-only base-normalization gotcha.
- Ran the design panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). Nine seats returned; aggregate disposition: **must-fix**.
- Posted the aggregate to PR #1157 as a `gh pr review`. The bot authored this PR, so GitHub rejects `--request-changes` on an own PR (as in every prior round); posted as a `COMMENTED` review carrying the explicit `disposition: must-fix` header, matching rounds 2–5.

**Panel outcome (must-fix drivers):**
- critic: safety bound (bounded aggregate exposure) deferred to an unspecified downstream backend; root-rotation tooling has no follow-up.
- skeptic: unstated lifecycle — what keeps the shared registry root alive at zero live guests.
- ergonomist: migration-failure/quarantine has no operator-visible surface; "seating hook" used as a settled term before it's defined.
- pedant / copyeditor / novice: term-italics inconsistency, `phases 1-2` capitalization, cross-reference/parallel-structure lapses.
- decomplector, orthographer: comment-only / approve.

**Follow-ups:** None for this stage. This was exactly one panel round — no fix, no un-draft, no loop, per the staged-gauntlet contract. The next gauntlet stage owns the fix-loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1157-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (735652 cached reads)
- Output: 4488 tokens
- Cost: $0.94983
- Wall-clock: 504s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
