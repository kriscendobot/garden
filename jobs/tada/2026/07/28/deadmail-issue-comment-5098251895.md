Job complete.

## Report

**Intent picked up:** the dead-lettered message carried mhofman's comment on kriskowal/garden#9 — create a local PR on the bot fork targeting **upstream** Moddable HEAD, succinct description, referencing the test case, adding a Moddable-suite test if one exists.

**Delivered: [kriscendobot/moddable#2](https://github.com/kriscendobot/moddable/pull/2)** (OPEN, MERGEABLE, 3 files, +56/−1)
- **base** `upstream-public` — new branch on the fork pinned at `Moddable-OpenSource/moddable@23b4d6b0` ("version bump 8.3.1", current upstream `public` HEAD), so the diff is genuinely against upstream HEAD, not the agoric fork. **head** `xs-flat-value-stack`, one commit.
- **Engine fix:** in `fx_Array_prototype_flatAux` (`xs/sources/xsArray.c`), *moves* `73aad47b`'s leaf `mxPop()` to the end of the `if (fxHasIndex)` block — upstream HEAD already has the leaf pop, so this is a move, and it now also drops the nested-branch sub-array reference that stayed resident for the whole traversal.
- **Tests (yes, Moddable has a suite beyond test262 — `$MODDABLE/tests`, copied into a test262 checkout as `test/moddable`):** added `tests/xs/built-ins/Array/prototype/flat/value-stack.js` and `.../flatMap/value-stack.js` in that suite, test262 frontmatter + `assert` style.

**Verified by execution** (x86-64 linux, `make -f xst.mk GOAL=release`, XS 17.9.1; before = `23b4d6b0`, after = PR#2 branch):

| suite | before | after |
| --- | --- | --- |
| the two new tests (test262 runner, strict + sloppy) | both `JavaScript stack overflow` | 4 cases, no failures |
| test262 `built-ins/Array` (6112 cases, real tc39 harness) | 6 failures | the same 6 |
| `$MODDABLE/tests/xs/built-ins` | 6 (4 pre-existing + the 2 new) | the 4 pre-existing |
| `$MODDABLE/tests/xs/language` | 0 | 0 |

**New finding that fixed my earlier caveat:** the minutes-long reproducer runtime I reported on 07-07 was never the leak — it was array construction. Under XS, `new Array(N)` + index assignment (or `.fill(ref)`) is quadratic; `push` is linear (300000 elements: 3 m 56 s vs **0.15 s**). Built with `push`, the nested overflow trips at `xst`'s stock 256K-slot stack in 0.15 s, so the Moddable test needs no small-`stackCount` build.

**Also observed (pre-existing, not ours):** `$MODDABLE/tests/xs/issues` aborts stock `xst` at case ~#287 with glibc `free(): double free detected in tcache 2` — logs byte-identical before and after the patch. Noted in the issue reply as an aside.

**Other changes:** garden `main2` commit `2d8f5d15df` appends a "Follow-up (2026-07-28)" section to `skills/agoric-chain-snapshot/repro/xst-release-ab/README.md` (PR link, the fast-reproducer table, the verification table, the `xst`-enters-test262-mode-when-`../harness`-resolves recipe). Replied on the issue thread at [#issuecomment-5101383382](https://github.com/kriscendobot/garden/issues/9#issuecomment-5101383382); issue left open for the submitter.

**Scope:** fork-only. No interaction with `Moddable-OpenSource/moddable` upstream (only read-only API reads and public source builds); no `agoric/agoric-sdk` interaction.

**Follow-ups for the maintainer:** (1) whether to also re-target/close PR#1 now that #2 supersedes it against upstream HEAD; (2) whether the ideal upstream change is #2 alone or #2 plus `73aad47b`'s unrelated `fxSortArrayItems`/`xsmc.c` hunks (already upstream at HEAD, so #2 is complete as-is); (3) whether Moddable should hear about the `tests/xs/issues` double-free abort.
