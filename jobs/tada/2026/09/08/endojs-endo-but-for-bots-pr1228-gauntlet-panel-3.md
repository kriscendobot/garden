The round-3 review is posted (COMMENTED, consistent with rounds 1 and 2 which also fell back to comment on the bot's own PR). Panel disposition is must-fix.

Panel round 3 complete for PR #1228. Ran the design panel in single-round mode against the PR head (`design/endo-claude-bare-caplet`, base `51b99651b`), which fanned 8 seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice, orthographer) and aggregated to disposition **must-fix**.

What I did:
- Resolved the PR head (endojs fork, branch `design/endo-claude-bare-caplet`, base `llm`) and got an isolated project worktree.
- Passed the real base merge-base SHA (`51b99651b63d…`, from `gh api …pulls/1228 --jq .base.sha`) to `panel.sh` per the origin-only base-normalization gotcha, not the bare `llm` ref.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` → terminal line `must-fix`.
- Posted the aggregate as a `gh pr review` on #1228. Request-changes is refused by GitHub on the bot's own PR, so it went out as a COMMENTED review carrying the full must-fix aggregate (same fallback rounds 1 and 2 used).

Load-bearing must-fix themes for the fix stage:
- The DD6 scope-narrowing ("OS confinement required → optional", pending maintainer confirmation) is asserted in prose but absent from § Open Questions, and stated as settled fact in `designs/README.md` (critic, skeptic).
- The "OS slice closes the residual" claim misattributes a mitigation to a threat (prompt-injection-via-tool-result) it structurally cannot address (skeptic).
- The `options.isolation` attestation is described as "observed and refused on" / "fails closed," but the mechanism cannot verify the caller's claim — prose overreads the guarantee (decomplector, critic).
- Should-fix spelling/style: `materialize` vs the API's `materialise`, new em-dashes, `openGuestMcp` verb inconsistency, `cancelled`→`canceled`.

I ran exactly one panel round, posted the verdict, and stopped — no fix, no un-draft, no loop, per stage scope.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1228-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (805295 cached reads)
- Output: 5376 tokens
- Cost: $1.0222465
- Wall-clock: 293s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
