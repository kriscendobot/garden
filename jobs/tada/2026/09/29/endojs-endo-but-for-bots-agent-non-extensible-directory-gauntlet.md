gauntlet-status: not-viable
viability-result: overtaken
# gauntlet endojs-endo-but-for-bots-agent-non-extensible-directory-gauntlet - not viable

the premise was overtaken. Deciding question: Is #1378 the only PR that adds the requested non-extensible own-directory option for new agents, so that nothing else already covers it? No. #1368 came first and covers the same work more fully. Option: close as superseded.

## Viability report

I've found an earlier duplicate PR (#1368) for the same request, so I'm reporting this one as overtaken.

## Viability report: endojs/endo-but-for-bots #1378

**Result: overtaken.** A PR opened about ten hours earlier (#1368) already does the same thing, so this gauntlet should not start.

- **PR facts:** #1378 is open and still a draft, with no reviews or comments. It was opened 2026-09-29T17:15Z at head `417e9a17`, on the frozen base `llm-1706e63`. `llm` has no commits past that base.
- **The request still stands.** kriskowal asked for "a follow-up job to introduce an agent maker option to make the agent's own directory non-extensible" (https://github.com/endojs/endo-but-for-bots/pull/1102#issuecomment-5884356929). Nothing on `llm` does this yet.
- **But another PR already answers it:** https://github.com/endojs/endo-but-for-bots/pull/1368, "feat(daemon): support non-extensible agent directories". It was opened by kriscendobot at 2026-09-29T07:27Z, is still a draft, and uses the same base (`llm-1706e63`). It cites the same comment and adds the same opt-in option to `provideGuest` and `provideHost`. The rules match #1378: existing names can be changed or removed, but no new name can be added or a removed one re-added. The option is also saved so a restarted agent keeps it. #1368 covers more ground: it adds help docs (`help.md`, `help-text-data.js`) and unit tests in `pet-sitter.test.js` and `formula-record.test.js`. #1378 has neither.
- **Why there are two:** two jobs were posted for this one request. `endojs-endo-but-for-bots-agent-maker-nonextensible-directory` (already completed) produced #1368, and `endojs-endo-but-for-bots-agent-non-extensible-directory` produced #1378.

Deciding question: Is #1378 the only PR that adds the requested non-extensible own-directory option for new agents, so that nothing else already covers it? No. #1368 came first and covers the same work more fully.

Evidence: #1368, opened 2026-09-29T07:27Z on the same base `llm-1706e63` and citing issuecomment-5884356929, adds the option (`nonExtensible`) to both `provideGuest` and `provideHost`, with the same rules, persistence, docs and unit tests. #1378 was opened about ten hours later as a duplicate from a second job posted for the same request.

Option: close as superseded

Follow-ups for the maintainer:
- Close #1378 and send #1368 through the gauntlet instead.
- Two questions from #1378's description are worth answering on #1368:
  - **Option name:** #1368 calls it `nonExtensible`; #1378 calls it `nonExtensibleDirectory`.
  - **Can the host still add names later?** Should the host be able to add new names when it re-provides an agent that is already locked?
- The two job basenames for this request differ, so re-posting it did not dedupe and created the second PR.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-agent-non-extensible-directory-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (276527 cached reads)
- Output: 2440 tokens
- Cost: $0.45452139999999996
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
