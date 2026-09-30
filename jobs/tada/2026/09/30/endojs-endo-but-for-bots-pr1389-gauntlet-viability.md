I read the PR and what's around it. It is still live: the maintainer asked for it about an hour and a half before it was opened, and no newer design has replaced it. The gauntlet can begin.

**Findings**
- **PR facts:** #1389 is open, a draft, and unmerged. Title: "design(sturdyref): layer-1 SturdyRef shim contract (handler + enliven)". Head `9ed5707c96` on `design/sturdyref-shim-contract`, base frozen `llm-7ff30af` (`7ff30afbce`). It was opened 2026-09-30T04:51Z. It changes two files: it adds `designs/sturdyref-shim-contract.md` and edits `designs/README.md`. There are no reviews or comments yet.
- **Why it exists:** kriskowal commented on endojs/endo-but-for-bots#695 at 2026-09-30T03:28Z (issuecomment-5903472512). The comment laid out a 9-layer SturdyRef stack, and item 1 is exactly this PR: a first-wins global `SturdyRef` shim built from a handler that defines `enliven`, like HandledPromise or Proxy. The comment also asked for a stack "for incremental and holistic review". That was under two hours ago, so the need still holds.
- **Supersession check:**
  - `designs/` on `llm` has only `sturdy-refs-endor-syscall.md` for SturdyRefs, which is not this contract.
  - Since 2026-09-28, no commit on `llm` touches the shim design.
  - The other open SturdyRef PRs either work *with* this one or are older work it reconciles:
    - #774 has been rewritten as this design's layer-1 build, and its body links back to #1389.
    - #737, #695 and #871 are other layers of the same stack.
    - #697–#704, #539 and #541 predate the maintainer's new layering.
  - None of them displaces #1389.

Deciding question: Is #1389 still the current, unreplaced layer-1 SturdyRef shim contract that the maintainer asked for on endojs/endo-but-for-bots#695 (2026-09-30), with no newer shim design on `llm` or in another PR?
Evidence: Yes. The maintainer asked for exactly this shim at 03:28Z today and the PR opened at 04:51Z. `llm` has no competing shim contract. #774 has been rewritten to implement this design and links back to it. The remaining SturdyRef PRs are other layers or older work that this design reconciles.

Nothing in any repo changed, and no later gauntlet stage was run.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1389-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (161136 cached reads)
- Output: 1642 tokens
- Cost: $0.3959872
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
