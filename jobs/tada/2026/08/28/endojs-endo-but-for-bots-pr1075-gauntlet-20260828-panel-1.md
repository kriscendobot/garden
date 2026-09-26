The panel review is posted. This stage is complete.

## Completion report

**Job:** gauntlet stage PANEL round 1 for endojs/endo-but-for-bots PR #1075 (`test(hardened262): cover %AsyncFunction% intrinsic metadata`).

**What I did:**
1. Resolved the PR head (endojs org, branch `test/hardened262-asyncfunction-intrinsic-metadata`, base `llm`) and set up an isolated project worktree.
2. Ran the jury panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree. It fanned all seats and decided disposition: **`must-fix`**.
3. Composed the aggregate verdict from `$GARDEN_PANEL_RUNDIR/round-1.md` and posted it to the PR as a `gh pr review`.

**Panel outcome — must-fix.** The vast majority of seats approved (clean, single-commit, test-fixture-only addition faithfully mirroring the sibling `%GeneratorFunction%`/`%AsyncGeneratorFunction%` tests; `prover` confirmed it is load-bearing via a taming-removal mutation). The gating finding came from `corner-prober`: the file's header comment claims lockdown tames the async-function constructor into an "inert stand-in" that throws on invoke, but **no assertion exercises that behavioral claim** — every assertion is a structural/identity check. Three advisory should-fix items (distinctness vs global `Function`, async class methods, frozen-prototype check) and comment-only items (a `.length` self-contradiction in the copied header comment) were also captured.

**Posting note:** `--request-changes` was rejected by GitHub ("Can not request changes on your own pull request" — the bot authored the PR), so I posted the verdict as a `--comment` review carrying the must-fix disposition in the body. Verified present as a `COMMENTED` review by `kriscendobot`.

**Follow-ups:** none for this stage — I stopped after posting per the single-round contract (no fix, no un-draft, no loop). The next gauntlet stage (fix-loop) owns the must-fix remediation.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1075-gauntlet-20260828-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 25 tokens (711043 cached reads)
- Output: 5634 tokens
- Cost: $1.1285234999999998
- Wall-clock: 325s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
