**Verdict: PR #1381 can go into the gauntlet (`viability=proceed`).**

I rechecked the PR on this pass and nothing has changed. It is still open, unmerged and a draft. The head is still `e26b2dec6b` and the base is still `llm-7ff30af` (`7ff30afbce`), which is the current `llm` tip. It is a docs-only PR that marks `designs/hardened-text-codecs-shim.md` as Implemented (Phases 1–2) and updates `designs/README.md` to match.

The previous attempt reached the same verdict but wasn't recorded because its final lines were in the wrong order. This report fixes the order.

Deciding question: Does `designs/hardened-text-codecs-shim.md` on current `llm` still say "Not Started" while the implementation has in fact landed, with no other PR already reconciling it?

Answer: yes, to all three parts.

Evidence:
- **The motivating mismatch still holds.** On `llm`, the design still has `**Status** | Not Started`. The only commit that has touched the file is `6d2f3a03a0` (#84, 2026-05-08).
- **The implementation has landed.** On `llm`, `packages/ses/src/permits.js` permits `TextEncoder`/`TextDecoder` and both of their prototypes. `packages/ses/test/text-codecs.test.js` and `text-codecs-missing.test.js` exist. This matches the PR's claim that upstream endojs/endo#3322 and #3340 are in `llm`.
- **Nothing has superseded it.**
  - #259, an earlier implementation PR, was closed.
  - #304, a status sweep, was merged but left this design at Not Started.
  - #1349, the XS smoke test, is a residual the PR cites, not a competitor.
  - #1355, the URL half, edits the next row in the README; the PR body already notes that as a merge conflict to resolve, not a replacement.

The gauntlet can start with clean → panel → fix-loop → un-draft.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1381-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (237537 cached reads)
- Output: 2485 tokens
- Cost: $0.7309176
- Wall-clock: 88s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
