**Viability gate: kriscendobot/endo PR #2** (`feat(cjs-module-analyzer): sync quoted export handling from cjs-module-lexer 2.2.0`)

I only read state for this gate: no clean, panel, fix, CI-wait or un-draft budget was spent, and I changed nothing.

Facts: the PR is open, not merged and not a draft. Its head is `063ecd8886`, and its base is the frozen `master-2708cac` at `2708caccaf`. It has no comments or reviews. It changes two files: `packages/cjs-module-analyzer/index.js` (+224/−42) and its test file (+29/−4).

Deciding question: has the quoted/escaped export-name parity with cjs-module-lexer 2.2.0 (adding `readStringLiteral`, removing the `strictReserved` filter) already landed some other way, or has the analyzer it patches been retired?

Evidence:
- **Not superseded.** The analyzer at the tip of `endojs/endo` master, `endojs/endo-but-for-bots` `llm` and `kriscendobot/endo` master still has the `strictReserved` set and the `if (!strictReserved.has(name))` filter (around lines 56 and 98). None of them has `readStringLiteral`.
- The recent commits under `packages/cjs-module-analyzer` on master and `llm` are only lint, format and build chores (latest: `b467b827e3` "chore: lint everything" on 2026-07-17, `ee5bdae93d` prettier on 2026-08-19). No open or merged PR in endojs/endo or endo-but-for-bots does this parity work. The nearest is endo-but-for-bots#1019, an open design to merge the Rust module lexer, which does not change this JavaScript analyzer.
- **The premise still holds.** The tracking issue kriskowal/garden#55 ("Tracking upstream cjs-module-lexer") is still open. `@endo/cjs-module-analyzer` is still a workspace dependency of `module-source` and `compartment-mapper` on master. The AST-based CJS parser that landed in endojs/endo#3220 sits beside the analyzer rather than replacing it.

Notes for the later stages:
- The frozen base is about three months behind master, and master has had a lint commit in this package since then, so expect to rebase or weave onto current master and fix some lint.
- The PR body says the AVA suite was never run, so it is unverified in CI so far.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-endo-pr2-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177397 cached reads)
- Output: 2179 tokens
- Cost: $0.44295539999999994
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
