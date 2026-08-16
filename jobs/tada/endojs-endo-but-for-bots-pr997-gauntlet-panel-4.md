The round-4 panel verdict is posted. Stage complete.

## Completion report

**Job:** Gauntlet PANEL round 4 for endojs/endo-but-for-bots PR #997 (`design(daemon): reassess worker retention, revocation, and the batch-flush retention root`) — a design-doc PR (2 files: `designs/worker-retention-and-revocation.md` +1339, `designs/README.md` sync).

**What I did:**
- Resolved the PR head (`kriscendobot:design/worker-retention-and-revocation`, base `llm`) and got an isolated project worktree at the PR head (`f341840e9`).
- Determined the correct base ref as the PR fork point `16fa8ebcc` (the branch is stacked on `upstream/llm`, so diffing against it isolates the 4 PR commits' actual changes: 2 files, +1399/−35).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode → **design panel, 7 seats** (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice). All 7 returned request-changes. Panel disposition: **must-fix**.
- Posted the aggregate as a review on PR #997.

**Verdict shape:** GitHub refuses `--request-changes` on the bot's own PR, so — matching rounds 1–3 on this same PR — I posted a **COMMENTED** review whose body leads with `**Disposition: must-fix.**` and carries all seven per-juror blocks verbatim.

**Recurring must-fix themes (for the fix stage):**
- README M3-vs-M4 milestone contradiction (`designs/README.md:4` note says M3; row/estimate/mermaid all say M4) — flagged by critic, copyeditor, pedant, novice, decomplector.
- `WorkerDiscipline` placed on the content-addressed incarnation *formula* vs. "request time" — identifier-churn/EQ consequence unstated (skeptic, decomplector, ergonomist).
- Q1's third retention window mis-traced (`answers`-map short-circuit → silent rebind, not a hang); an unenumerated fifth retention root (critic, skeptic).
- "partition-shaped" relabeling of single-sever cases Thread 1's own taxonomy classifies adversely (skeptic).
- `pinTransient` "every landed call site" claim false (leaks on error path at `host.js:2069`, `manager.js:6737`).
- No test catalog / no phasing for an all-races mechanism.

**Stage boundary honored:** ran exactly one round; did not fix, un-draft, or loop.

**Follow-ups:** none for this stage — the gauntlet's next-stage-owed heuristic picks up the must-fix disposition and dispatches the fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (944028 cached reads)
- Output: 6290 tokens
- Cost: $1.1176020000000002
- Wall-clock: 389s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
