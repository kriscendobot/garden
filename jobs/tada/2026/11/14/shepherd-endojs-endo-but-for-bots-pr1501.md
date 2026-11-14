---
handed-off: endojs-endo-but-for-bots-pr1501-weave-after-pr1613
deliverable-complete: false
---
**Shepherd report: endojs/endo-but-for-bots#1501** (feat(space-floot): preview edit-tool diffs; draft; head `d4117a1e`; frozen base `llm-9a14ddf`)

CI is not green yet, and pushing to this PR can't make it green. The remaining work is a weave onto llm once a fix for the base lands. I've parked that as a successor job.

**What's failing**
- Only two checks are red: `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`. Everything else in the rollup passes.
- Both fail on `built-ins/stage3-math/054.js` and `055.js`. The engine's results for `Math.asinh(1.7)` and `Math.acosh(2.3)` differ from the XS oracle's in the last digit: `1.300820426840647` vs `1.3008204268406467`. The tests that fail are `corpus_conversion_equivalence` and `generated_multi_crank`.
- The cause is the known runner change: `ubuntu-latest` became ubuntu-26.04, and its glibc rounds asinh/acosh differently from the glibc-2.39 values the tests expect.
- The PR doesn't cause this. Its diff touches only space-floot, chat test, designs and changeset files, and no ironhorse code. The PR is behind on nothing: `llm-9a14ddf...llm` is 8 ahead, 0 behind. Rerunning won't help, because the lanes would run on the same runner again.

**Fix status**
- **#1613** (`fix(ci): run the XS oracle lanes on Ubuntu 24.04`): its CI is green, it is ready for review (not a draft) and mergeable, and no review has been recorded. It targets the same frozen base, `llm-9a14ddf`. It is waiting on the maintainer to merge it.
- **#1585** is a competing draft fix that accepts both roundings. A parked plan, `endojs-endo-but-for-bots-pr1501-weave-after-pr1585`, already waits on it to weave #1501.

**What I did**
- I didn't push anything to #1501. Copying #1613's workflow change into an unrelated PR would mix scope and duplicate the fix.
- I parked a sibling plan, `endojs-endo-but-for-bots-pr1501-weave-after-pr1613`, blocked on https://github.com/endojs/endo-but-for-bots/pull/1613. It weaves #1501 onto a fresh llm snapshot and confirms both oracle lanes go green. Whichever fix lands first, the weave now fires instead of waiting forever on a draft that may never merge. If the other fix's weave has already turned the PR green, the second plan is a no-op.

**Follow-up for the maintainer:** merge #1613 (or #1585). That unblocks the weave, which should clear #1501's last reds.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1501.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (624956 cached reads)
- Output: 5051 tokens
- Cost: $0.6768272
- Wall-clock: 715s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
