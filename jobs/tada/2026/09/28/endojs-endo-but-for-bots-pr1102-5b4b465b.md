## Completion report: endojs/endo-but-for-bots PR #1102, attention directive (comment 5878685955)

I resolved the conflicts, retconned the branch and posted a readiness assessment on the PR. My conclusion is that it is **not ready for review**, and I recommend against more gauntlet rounds on the current text.

**Preflight:** it exited 2, but the only matching text was the garden's own "On it" acknowledgement (comment 5878706586). No peer had done any of the work, so I went ahead.

**Conflicts and retcon:**
- **Rebase:** I rebased the branch onto current `llm` (`47f6965d88`) and squashed its 7 commits into one, `66bd134e7f` ("design: endow a new agent with indelible special names on provisioning"). I rewrote the commit message because some of its facts were stale.
- **Push:** force-pushed with a lease to `kriscendobot:design/claude-agents-capability`. GitHub now reports the PR as MERGEABLE (it was CONFLICTING).
- **Conflicts:** only `designs/README.md` conflicted (4 hunks). I kept `llm`'s new `endo-guest-stdio-mcp` and `daemon-guest-bot-incarnation` rows and diagram nodes, added this design's row, node and `isn --> eclaude` edge, and replaced the retired `endo-claude-agents-capability` row.
- **Design file:** `designs/introduced-special-names.md` is byte-identical to the old head `e1fa35ad38`, so the net diff is unchanged apart from the README merge.
- **Base branch:** left as `llm`; I did not pin it to a frozen branch.

**Assessment** (PR comment https://github.com/endojs/endo-but-for-bots/pull/1102#issuecomment-5878766964):
- **The premise has moved.** A later merged change, #1306 (commit `9e16e50b14`), already gives new agents special names from the provisioning options, one named field per name (`pins` becomes `@pins`, `networks` becomes `@nets`). This design proposes a generic name map instead and never mentions #1306.
- **Facts in the design are stale.** It cites `MakeHostOrGuestOptions` at `types.d.ts:1444`, which is now `MakeAgentOptions`. Its `guest.js` and `host.js` line citations are out of date. It says #1042 "landed", but #1042 is still open.
- **The panel is not converging.** All six rounds came back must-fix. Meanwhile the document grew from 177 to 657 lines. Round 6 was mostly edge cases and copyedits, and nothing addressed the #1306 overlap.
- **The question for the maintainer:** does the #1306 one-field-per-name pattern already cover what they asked for? If yes, close #1102 as superseded. If they still want a generic map, run one fixer pass to rewrite the design on top of `MakeAgentOptions`, explain why a map beats more named fields, refresh the citations and cut the length, then one gauntlet round.

**Follow-ups:** I posted no jobs, because the next step depends on the maintainer's answer. My inbox was empty when I finished.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-5b4b465b.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1884855 cached reads)
- Output: 11185 tokens
- Cost: $1.2243749999999998
- Wall-clock: 187s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
