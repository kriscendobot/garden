Viability gate for endojs/endo-but-for-bots#1406 ("feat(claude): pin Claude Code 2.1.280 with dontAsk and no builtin plugins"): **proceed**. No clean, panel, fix or CI budget was spent.

Deciding question: Does `llm` still pin `@endo/claude` to Claude Code 2.1.232, with no other change to 2.1.280 or the confinement flags, while the garden hosts run 2.1.280?

Answer: yes.

Evidence:
- **PR state:** #1406 is open, unmerged and still a draft, with head `4a6d9152`. Its pinned base is `llm-d4124e6` (`d4124e6e40`). It has no reviews or comments yet.
- **No newer base history:** comparing `llm` with `d4124e6e40` returns `identical` (0 ahead, 0 behind). Nothing has landed on `llm` since the base was pinned.
- **The need still holds on `llm`:** `packages/claude/src/argv.js` still has `PINNED_CLI_VERSION = '2.1.232'` and no `--permission-mode` flag.
- **The host premise holds:** `claude --version` on this host reports `2.1.280 (Claude Code)`. `@endo/claude` on `llm` would therefore refuse to start on garden hosts, which is the problem this PR fixes.
- **Motivating context is current:** #1371 merged today (2026-10-01T08:37Z). Its review 5375148317 asked for this bump as follow-up 5.
- **Not superseded:** a search found no other PR on the repo that bumps this pin.

No follow-ups. The gauntlet can begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (169771 cached reads)
- Output: 1316 tokens
- Cost: $0.4086662
- Wall-clock: 22s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
