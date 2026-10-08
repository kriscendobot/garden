**Gauntlet viability report for endojs/endo-but-for-bots#182**

I checked the PR's current state and found nothing that has overtaken it, so the gauntlet can go ahead. I spent no clean, panel, fix, CI-wait or un-draft budget.

- **PR facts:** the PR is OPEN, not merged and not a draft. Its title is "test(ses): isImmutableDataProperty regression for iOS Safari fix (closes endojs/endo#947)". The head is `b9f8ec1e86` and the base is the frozen `master-46d4edf`. The change only touches tests: 32 lines added to `packages/ses/test/scope-constants.test.js`. That test uses a Proxy global which lists the name `phantom` but returns no descriptor for it, and checks that `getScopeConstants` does not throw and drops `phantom`.

Deciding question: Does current `master`/`llm` (or upstream endo) already have a regression test for an own name with an undefined descriptor in `isImmutableDataProperty`, or has the `desc &&` guard that motivates the test been removed or reworked?

Answer: no to both.

Evidence:
- On both `master` and `llm`, `packages/ses/src/scope-constants.js:110-113` still has the `const desc = getOwnPropertyDescriptor(obj, name); return ( desc && …` guard. The only difference is that `llm` writes it as a function declaration, so the fix this PR tests is still in place.
- The test file has no phantom, undefined-descriptor or #947 test on `master`, `llm` or upstream `endojs/endo`. Its last change on `master` was in 2024 (`0cc184643`), so no other change has added the test.
- Upstream endojs/endo#947 ("iOS Safari fails to lockdown") is still OPEN.
- The upstream copy of this PR, endojs/endo#3314, is also still open and not merged.
- I found no competing PR in endo-but-for-bots. Other results for "947" are a different issue number that happens to match.
- @erights commented about the WebKit bug, then retracted it ("nevermind"; he had misunderstood the PR). Neither comment objects to the PR. It has no reviews.

Both claims hold: nothing has superseded the PR, and the need it covers (no regression test for the iOS Safari fix) still exists.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr182-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (164918 cached reads)
- Output: 1816 tokens
- Cost: $0.40824760000000004
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
