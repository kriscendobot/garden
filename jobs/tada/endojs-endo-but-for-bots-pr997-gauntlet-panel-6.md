Panel round 6 complete.

**What I did**
- Resolved PR #997 head (`kriscendobot:design/worker-retention-and-revocation`, base `llm`) and got an isolated project worktree.
- Ran the panel in single-round mode. The panel kept dying on ~10-minute session-reap teardowns because it was a child of my agent process, so I relaunched it fully detached (`setsid`) to survive teardowns and accumulate progress in the rundir.
- **Caught a base-ref defect:** the first completed run diffed against the worktree's local `llm`/`origin/llm`, both ~502 commits stale (`67dfc18b1`), which inflated to a spurious 3431-file diff and made the panel run as a **code** panel — producing false must-fix findings against `packages/claude-sandbox/…` and `packages/daemon/manager.js`, files not in this PR. The careful seats (assessor, typist, spec-keeper, releaser, changeset-auditor) all independently flagged this. The recent `fix(panel): normalize a bare local base branch` maps `llm`→`origin/llm`, which is *also* stale here, so it wouldn't have helped.
- **Re-ran with the correct base `upstream/llm`** (merge-base `16fa8ebcc`), yielding the real 3-file design-doc diff. The panel then correctly sensed a **design panel** and fanned the design seats.

**Result:** design panel, single round, **must-fix** (panel.sh exit 0). 5 seats request-changes (critic, skeptic, ergonomist, copyeditor, novice), 2 comment-only (decomplector, pedant). Must-fix themes: the Thread-5 admission-cap "own contribution" is undefined so its named attack isn't demonstrably closed; `designs/README.md` summary rows drop the load-bearing `<session>` edge discriminator; `makeRetainedValue` sibling return-shape divergence; typist-hostile glyphs; and prose-density/forward-reference/unglossed-jargon issues.

**What changed:** posted the aggregate as a `COMMENTED` `gh pr review` on PR #997 (`## Panel verdict — round 6 (design panel) · disposition: must-fix`, submitted 2026-08-16T14:10:14Z) — matching the prior rounds' shape the next-stage-owed heuristic recognizes (request-changes is rejected on the bot's own PR).

**Follow-ups**
- The gauntlet base-ref keeps resolving to a stale `llm` in the fork clone; rounds 1/3 ran as code panels on the spurious diff for the same reason. The panel/gauntlet base-ref resolution should prefer `upstream/<branch>` (or verify a local base against its upstream) when the fork mirror is stale — several jurors filed this as a proposed-rule. Worth a garden fix so future rounds don't need this manual correction.
- Stage owes a fix round next (must-fix); I stopped here per the single-stage contract (no fix, no un-draft, no loop).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 86 tokens (2973557 cached reads)
- Output: 26504 tokens
- Cost: $3.3378925000000006
- Wall-clock: 2493s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
