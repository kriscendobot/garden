Panel round 4 complete. The review is posted.

## Completion report

**Job:** Gauntlet stage PANEL round 4 — endojs/endo-but-for-bots PR #1226 (`docs(designs): a stdio MCP server scoped to one guest's tool surface`).

**What I did:**
- Resolved the PR head (endojs/endo-but-for-bots @ `design/endo-guest-stdio-mcp`, base `llm`) and got an isolated project worktree.
- Passed the real merge-base SHA `51b99651b63d4e652f9af4eae603422783233182` to `panel.sh` (not the bare branch name, per the origin-only base-normalization gotcha).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode. It fanned the design-panel seats and printed disposition **must-fix**.
- Posted the aggregate verdict as a `gh pr review`. `--request-changes` was rejected by GitHub (self-authored PR), so I fell back to `--comment` with a **"Must-fix before merge"** heading in the body — the shape the next-stage-owed heuristic recognizes for bot-authored PRs. Verified posted as a COMMENTED review by kriscendobot at 21:39:58Z.

**Verdict:** must-fix. The panel surfaced cross-document/security findings requiring changes — chiefly:
- `SO_PEERCRED` peer check keys on a recyclable pid (unstable identity for the security boundary); the pid-vs-uid "or" is under-specified against the concurrent-adapter topology (critic, decomplector, skeptic).
- Argument-scope check specified `reject-only` here conflicts with `endo-claude.md` DD2's "rejects **or attenuates**"; the "teardown-on-reprovision" firm requirement is asserted but not committed to by the owning lifecycle doc (skeptic).
- Construction-time failures lack the discriminated error shape request-time failures get (ergonomist).
- Several prose/grammar should-fixes and a `no-latin-shorthand` "e.g." hit (copyeditor, pedant).

**Follow-ups:** Next gauntlet stage (fix loop) owns remediation — I did not fix, un-draft, or loop. No garden-repo changes were made.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (655754 cached reads)
- Output: 4869 tokens
- Cost: $0.923751
- Wall-clock: 260s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
