The design is complete and the draft PR is open. Here is my completion report.

---

**Job: regularize pass-style src file naming — endojs/endo-but-for-bots**

**What I did.** Surveyed the current state of `packages/pass-style/src/` and the whole-repo naming landscape, then authored a design proposing a single convention and a full rename plan, landed as its own draft PR against `llm` (not folded into #475).

**Findings that shaped the design:**
- `pass-style/src/` mixes camelCase (`byteArray.js`, `passStyleOf.js`, `makeTagged.js`, `typeGuards.js`, `copyArray.js`, `copyRecord.js`, `deeplyFulfilled.js`) with kebab-case (`iter-helpers.js`, `make-far.js`, `safe-promise.js`, `internal-types.js`) and one hybrid (`passStyle-helpers.js`).
- The camelCase set follows **no** rescuable "named after its export" rule: `byteArray.js`/`copyArray.js`/`copyRecord.js` export `*Helper` records and `typeGuards.js` is a grouping with no same-named export.
- Repo-wide, kebab-case base names outnumber camelCase roughly **500 to 37** across `packages/*/src`.
- The `test/` dir already carries two byte-array test files differing only by convention (`byteArray.test.js`, 404 lines; `byte-array.test.js`, 23 lines), a near-collision the mixed convention masks.

**What the design recommends.** Kebab-case as the single convention (majority house style, filesystem-safe, no principled camelCase rule to preserve), with concrete tables for the 8 src renames, 3 test renames (including the byte-array test merge), every import/reference edit site, the two comment-only sibling references in `harden`/`ses`, and a note that the tsconfig globs need no edit. No exported-symbol changes. It surfaces the genuine maintainer decisions as open questions: kebab-vs-camel ratification, whether to coordinate with upstream `endojs/endo` (which could flip the choice toward camelCase to reduce upstream churn), whether to regularize the whole passable family (marshal, patterns) or pass-style alone, and the test-reconciliation shape.

**What changed.**
- Added `designs/pass-style-src-file-naming.md` and registered it in `designs/README.md`.
- Opened draft **PR endojs/endo-but-for-bots#1293** (head `design/pass-style-src-file-naming`, base `llm`), verified draft/open state via `gh pr view`.
- No code renamed; implementation is deliberately a separate follow-up.

**Follow-ups.** The PR is left draft per the manual-gauntlet regime; the maintainer promotes it to design-panel review with **run the gauntlet #1293** when ready. Once the convention is ratified, a `build`/`fix` job implements the rename (rename-only PR against the appropriate base, run `yarn lint`/`yarn test`/`yarn test:types` before push).

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pass-style-src-naming.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2292424 cached reads)
- Output: 24116 tokens
- Cost: $2.7224289999999995
- Wall-clock: 380s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
