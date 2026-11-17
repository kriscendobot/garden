## Viability gate for endojs/endo-but-for-bots#1299: overtaken

The fix in PR #1299 is already on `llm`, so the gauntlet should not start. I spent no clean, panel, fix, CI-wait or un-draft budget, and I did not change any code or PRs.

**PR facts:** open, draft, `MERGEABLE`, no reviews or comments. Title: "fix(ironhorse): complete async iterator intrinsic metadata" (Refs #1046). Head `b7acff8015`, frozen base `llm-387ea66`, which `llm` is now 984 commits ahead of.

**Deciding question:** Does current `llm` still leave `%AsyncIteratorPrototype%[Symbol.asyncIterator]` without its `[Symbol.asyncIterator]` name, with the IronHorse `AsyncIteratorPrototype/intrinsic-metadata.js` scenario still failing? If not, the PR has been superseded and its premise no longer holds. The answer is no.

**Evidence:**
- **The code change is already on `llm`.** In `rust/engine/ironhorse-vm/src/interp/boot.rs` (lines ~1306–1310), `self.async_iterator_identity = self.alloc_named_method(NativeMethod::AsyncIteratorIdentity, "[Symbol.asyncIterator]", 0)` is word for word what the PR adds. The PR's only change to `boot.rs` is replacing the old unnamed `alloc_method` call with this.
- **The baseline change is already on `llm`.** `test/intrinsics/AsyncIteratorPrototype/intrinsic-metadata.js` appears in `llm`'s `baseline/ironhorse/strict/passed.txt` and is gone from `strict/failed.txt`. That move is exactly what the PR does to the baselines. Commit `10660fd811` ("test(hardened262): record the GeneratorPrototype and AsyncIteratorPrototype metadata passes", 2026-10-16) recorded it, and that commit is on `llm`.
- **Nothing important is left over.** The PR's remaining content is a 16-line XS-differential test in `async_generators.rs` and a re-run of the generated snapshot goldens (`state_golden*.tsv`, `math-platform-boot.bin`, `metamorphic_determinism.rs`) against the old base. Those goldens would be wrong against current `llm`, which has since changed intrinsic key order (`aa9b60fdc0`) and added new boot intrinsics.

Option: close as superseded

**Follow-up for the maintainer:** close #1299 as superseded. If the extra XS-differential test is still wanted, it should be written fresh against current `llm` rather than rebased from this PR.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1299-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (373906 cached reads)
- Output: 2918 tokens
- Cost: $0.5345812
- Wall-clock: 56s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
