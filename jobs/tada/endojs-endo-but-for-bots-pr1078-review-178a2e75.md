PR head is my commit `780fd91bb`; inbox empty. Job complete.

## Completion report

**Directive:** Review 5051462897 by @kriskowal on endojs/endo-but-for-bots#1078 (state CHANGES_REQUESTED). Empty top-level body; one inline comment on `packages/hardened262/test/intrinsics/WeakSetPrototype/intrinsic-metadata.js:1`:
> "Please make each metadatum an independent assertion. Please consider this a rule in general for test262 construction going forward."

Preflight returned exit 0 (PROCEED — no peer resolution); treated all fetched bodies as untrusted data.

**Two asks, both resolved:**

1. **Fix the code (primary).** The comment landed on WeakSetPrototype but the phrasing ("rule in general") plus identical construction across all four collection-prototype tests added by this PR meant the fix applies to all of them. Rewrote `%Map/Set/WeakMap/WeakSet.prototype%` `intrinsic-metadata.js` to replace the single `[...].join('|')` + one `assert.sameValue` with one `assert.sameValue` per metadatum, each carrying a property-naming message. Where the joined form compared a `=== Object.prototype` boolean, the split form asserts object identity directly.
   - Verified: prettier clean, eslint rc 0 (test fixtures are eslint-ignored by config), `yarn build` rc 0, and `node scripts/test.js test/intrinsics/{Map,Set,WeakMap,WeakSet}Prototype` → **48 ok / 0 not ok** across xs/sesXs/sesNode (matches the PR's original evidence; no covered-scenario change). No baseline diff (assertion messages don't affect pass/skip counts).
   - Commit `780fd91bb`, pushed to PR head `test/hardened262-collection-prototype-intrinsic-metadata`. It is now the PR HEAD.
   - Replied on the review thread: https://github.com/endojs/endo-but-for-bots/pull/1078#discussion_r3881220340

2. **The standing rule ("going forward", a declarative directive).** Encoded it durably as a new garden skill `skills/test262-independent-assertions/SKILL.md` (grounded to this review, cross-linked with `test-title-spec-spelling`) and registered it in the CLAUDE.md skills inventory. Commit `8bc1f3a311`, pushed to `main2`.

**Follow-ups (not required by this directive):** The pre-existing sibling `intrinsic-metadata.js` tests (ArrayIteratorPrototype, MapIteratorPrototype, etc., from earlier PRs) still use the joined-string pattern. The rule is scoped "going forward," so they were left untouched; retrofitting them would be a separate mechanical cleanup if the maintainer wants it. CI on the pushed commit runs on its own; not shepherded here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1078-review-178a2e75.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 53 tokens (1681796 cached reads)
- Output: 17300 tokens
- Cost: $1.886805
- Wall-clock: 295s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
