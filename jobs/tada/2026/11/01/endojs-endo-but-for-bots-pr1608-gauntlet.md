gauntlet-status: not-viable
viability-result: overtaken
repo: endojs/endo-but-for-bots
pr_number: 1608
# gauntlet endojs-endo-but-for-bots-pr1608-gauntlet - not viable

the premise was overtaken. Deciding question: Is #1608 the only open PR that fixes the revoked-Proxy `[[Call]]`/`[[Construct]]` test262 rows on base `llm-9a14ddf`, so that no other PR has displaced it? Option: close as superseded.

## Viability report

#1608 should not enter the gauntlet. It duplicates the open PR #1607, which was opened earlier and covers everything #1608 does and more.

Deciding question: Is #1608 the only open PR that fixes the revoked-Proxy `[[Call]]`/`[[Construct]]` test262 rows on base `llm-9a14ddf`, so that no other PR has displaced it?

Evidence:
- **#1608's state:** it is open, still a draft, not merged, and has no reviews or comments. Its base is `llm-9a14ddf`, which is still the tip of `llm` (0 commits ahead), so nothing has landed on the base since.
- **#1607 is an earlier duplicate:** https://github.com/endojs/endo-but-for-bots/pull/1607 ("typeof a revoked function proxy, revoked new.target, Proxy completions") was opened at 09:13Z on the same `llm-9a14ddf` base. #1608 was opened at 09:54Z.
  - It is also a draft, and its gauntlet record is still in the journal with the clean stage queued.
  - It fixes the same 4 shards as #1608, all fail → pass: `built-ins/Proxy`, `built-ins/Proxy/revocable`, `language/expressions/typeof` and `built-ins/Function/internals/Construct`. It also fixes a fifth, `Object/seal` (`seal-proxy`).
  - It takes the same approach in the same four files: `make_proxy` copies `XS_CAN_CALL_FLAG` from the target, a new typeof-callability helper reads that flag, and GetPrototypeFromConstructor throws a TypeError for a revoked `new.target`.
- **The two PRs cannot both land:** they edit the same files, so whichever merges second will conflict.
- **#1608's description is wrong about overlap:** it says none of #1599–#1606 overlap its rows, but it never checks #1607, which was opened 41 minutes earlier and overlaps it completely. The "eleventh" and "thirteenth" crank slices picked the same work.
- **The need still exists, but #1607 covers it:** the test262 failures are still real, so the open question is which PR lands, not whether the fix is needed.

A caveat for the maintainer: #1607's PR shows a "Gauntlet terminal — halted" comment, because its clean stage failed once and was declared not retryable. The journal still lists that gauntlet as running. If #1607 is abandoned, #1608 could be revived as the replacement, but it would then be missing the `Object/seal` completion fix.

Option: close as superseded

I spent no clean, panel, fix, CI-wait or un-draft budget, and changed nothing on GitHub or in the garden.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1608-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (430354 cached reads)
- Output: 2703 tokens
- Cost: $0.5545388
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
