The panel round is complete and the verdict is posted. This is a single-round panel stage — I stop here without fixing or un-drafting.

## Completion report

**Job:** Gauntlet PANEL round 2 for endojs/endo-but-for-bots PR #988 (`design(daemon): define byte-stable Git commit formulas`).

**What I did:**
- Provisioned an isolated project checkout of the PR head (`kriscendobot/endo-but-for-bots@design/daemon-commit-formula`, oid `d9d22ef26`) — the head lives in the fork, so I pointed `ensure-project-worktree.sh` at `kriscendobot/endo-but-for-bots`.
- Ran the panel in single-round mode against base `eb47ab674` (upstream/llm merge base). The diff is design-only (`designs/daemon-commit-formula.md` +437, `designs/README.md` +19), so the **design panel** (7 seats) fired: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice.
- Panel disposition: **must-fix**.
- Posted the aggregate verdict as a `gh pr review` on PR #988. `--request-changes` is disallowed on the bot's own PR (author = kriscendobot), so I posted it as a `--comment` review with the **must-fix** disposition stated at the top of the body. Confirmed posted (`state: COMMENTED`, submitted 2026-08-14T21:34:24Z).

**Key must-fix themes surfaced (for the next fixer stage):**
- Byte-stability rests on an unstated tree-sort algorithm — Git's directory-suffix (`/`) sort order vs. `readable-tree`'s plain lexical order diverges on name-prefix collisions (`foo` dir vs `foo.txt`); the projection step must state the canonicalization, and the test plan must include the distinguishing fixture (critic, skeptic).
- `FormulaRefStore.compareAndSwap`'s `expected` type permits the direct-ref-without-`terminal` combination the prose forbids — encode as a discriminated union (decomplector, ergonomist).
- No cycle/depth bound on symbolic-ref chains; no fallback for non-conforming actor lines (skeptic).
- `designs/README.md` dependency graph wires only 2 of the 5 relationships in the doc's own table (critic, skeptic).
- New 437-line doc violates CONTRIBUTING.md "one sentence per line" throughout — needs a reflow pass (pedant); plus copyedit/novice prose-structure fixes (undefined "partition" jargon, five-topic paragraph, forward references).

**Follow-ups:** Next gauntlet stage (fixer) owns addressing the must-fix items. No garden-repo changes were made.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr988-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 31 tokens (782300 cached reads)
- Output: 5260 tokens
- Cost: $0.9923069999999999
- Wall-clock: 307s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
