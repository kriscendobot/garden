Viability check: PR #1671. Result: **proceed**.

Deciding question: Has anything newer on `llm` or in another PR changed or replaced the prompt-template design, or dropped the need to correct the `{{var}}` wording before draft build #1640 can be reworked? **No.**

Evidence:
- **PR state:** #1671 is an open, unmerged draft created 2026-11-17T12:00Z. It has no comments or reviews. It changes three design files only: `designs/endopi-prompt-templates.md`, `designs/endopi.md` and `designs/README.md`.
- **Base:** The base is `llm-0368767` at `0368767778`. A compare of that commit against live `llm` shows `llm` is 0 commits ahead, so nothing has landed since the base was pinned.
- **The design file on `llm`:** `designs/endopi-prompt-templates.md` was last changed in `f4a9dc6d13` (2026-05-15, the original pi-harness raft). Nothing has replaced it since, and it still uses the `{{var}}` wording this PR corrects.
- **Other PRs:** A title search finds only #1640, the draft build for prompt templates, which is still open and unmerged. The design exists to turn #1640 toward Pi's `$1`/`$@` argument grammar (its § *Delta from #1640*). No competing design PR exists.
- **Motivating premise:** The board asked for a concrete template format and argument-substitution design. That need still holds because the build it guides has not landed.

Follow-ups: none. The design leaves two questions for the maintainer: whether `{{name}}` placeholders should survive as an Endo-only extension (it recommends no), and whether agents may invoke templates (it recommends user only). These are for maintainer review and do not affect viability. I spent no clean, panel, fix or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1671-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (128048 cached reads)
- Output: 1185 tokens
- Cost: $0.41605359999999997
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
