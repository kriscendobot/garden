Implemented and pushed class, derived construction, `super`, public/static fields, private elements/brands, and decorator reporting to the shared draft PR.

- Head: `9ffddfcb1ffcb7b36d2cc0b2a331bcda0782b8e0`
- PR: https://github.com/endojs/endo-but-for-bots/pull/970
- Requested slice: covered `1 → 4,176`; unsupported `8,679 → 4,580`; skipped `91 → 15`; no failures/infrastructure.
- Decorators: removed blanket skip; 2 covered, 22 pinned-parser exclusions.
- Validation passed: affected official Test262 slices, full Rust workspace, focused regressions, fuzz decoder, and exact corpus `1,711/1,711`.
- Pins and exact computron expectations remain unchanged.
- Remaining unsupported cases are named overlapping cross-feature gaps, chiefly async generators, `for-of`, `with`, and proposal syntax.
- PR remains open and draft.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-05-derived-classes-private-decorators.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 53 tokens (1573485 cached reads)
- Output: 22728 tokens
- Cost: $2.0675095 (1 engagement(s) unpriced)
- Wall-clock: 5659s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
