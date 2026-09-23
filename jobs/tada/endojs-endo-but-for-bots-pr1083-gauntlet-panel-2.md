The round-2 review is posted (COMMENTED, 04:54:57Z), and it aligns with round 1's design-panel treatment. The stage is complete: a single design-panel round, disposition **must-fix**, verdict posted. No fixing, un-drafting, or looping.

One follow-up worth surfacing: the initial run with the dispatched bare base `llm` (which panel.sh normalizes to the fork's `origin/llm`) reviewed a spurious 4280-file diff as a *code* panel, because this fork's `origin/llm` is ~5 weeks stale relative to `upstream/llm`. I corrected by passing `upstream/llm` (the PR's true merge-base) explicitly.

---

Ran the round-2 panel stage for endojs/endo-but-for-bots PR #1083 ("docs: design npm registry as directory tree").

**What I did:**
- Resolved PR head (`kriscendobot:design/npm-registry-as-directory-tree`) and got an isolated project worktree.
- First panel run with base `llm` → normalized to the fork's `origin/llm`, which is ~5 weeks stale vs `upstream/llm`. It produced a spurious 4280-file/327k-line diff and ran as a **code** panel; multiple seats (assessor, stylist, packager) independently flagged the stale base and confirmed the real diff is docs-only. Its `must-fix` cited files (`packages/capn-web/src/types.js` etc.) not in this PR, so I discarded it as invalid.
- Verified the true base: `merge-base HEAD upstream/llm` = `059e18d07`, real diff = exactly the 3 design docs (`designs/npm-registry-as-directory-tree.md`, `designs/registry-capability.md`, `designs/README.md`).
- Re-ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1083 upstream/llm`. It correctly sensed a **design** panel (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice), decided cleanly (exit 0), disposition **must-fix**.
- Posted the aggregate as a `gh pr review` on #1083. Request-changes is blocked on the bot's own PR, so it went as a **comment** review whose body states "disposition: must-fix" prominently (matches how round 1 posted).

**What changed:** one review comment on PR #1083; no code/garden changes, no fix, no un-draft.

**Must-fix items for the next round:** resolver-locality/round-trip claim (critic), `resolutionHash` input change (skeptic), `lookup` string-vs-array overload footgun (decomplector, ergonomist), misleading-pronoun invariant inversion at lines 153-157 (copyeditor).

**Follow-up:** the gauntlet dispatches bare base-ref `llm`, but panel.sh normalizes it to the fork's `origin/llm`, which here was stale enough to silently flip a design-doc PR into a 4280-file code-panel review. The fork's `origin/llm` should be re-synced (or the panel should fall back to `upstream/llm` when `origin/<base>` lags upstream) so future rounds don't need the manual base correction.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1083-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 74 tokens (2876983 cached reads)
- Output: 17833 tokens
- Cost: $2.7894295000000002
- Wall-clock: 425s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
