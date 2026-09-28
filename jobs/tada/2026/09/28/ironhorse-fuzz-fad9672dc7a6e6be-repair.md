Finding `fad9672dc7a6e6be` is now covered by a regression test on standing PR #1298. No engine change was needed: the fix was already on the branch, and Ironhorse was producing the correct answer all along.

**Where it stood when I started:** nothing from the earlier attempt was on the `ironhorse-fuzz-findings` branch, in the PR, or in the journal, so I started over.

**What I did:**
- **Reproduced it.** The input decodes to `flflo;` and its sha256 matches. The generator turns it into a program equal to `-(494927872 ** 2)`, which is exactly `-244953598482448384`. At `38ca1d1893` the fuzz target panics with `oracle="-244953598482448380" ironhorse="-244953598482448400"`.
- **Classified it.** It's the same XS number-printing quirk as sibling finding `e0fe14e41d5074a6`. Both strings name the same double; XS prints a 17-digit form, while Ironhorse prints the shortest form that JavaScript's spec requires (as V8 does).
- **Confirmed the fix is already there.** The branch's change to compare numbers by their exact double value (`fdb9fef6e0` and related commits) covers this. The input no longer triggers a failure at branch head `f221f47b09`.
- **Added the regression test.** It's `rust/engine/ironhorse-vm/tests/finding_fad9672dc7a6e6be_large_integer_dtoa.rs`, which reads the exact input bytes from `tests/fixtures/finding-fad9672dc7a6e6be.input.bin`. It checks that the generated program matches the finding, that it runs to completion with result `-244953598482448400`, and that the XS, shortest and exact spellings are the same double. It passes and is formatted correctly under both the 1.91.1 and 1.88.0 rustfmt.
- **Checked that the test really guards the fix.** When I forced the shared number formatter to print 17 digits, the test failed (`-…380` vs `-…400`); after I undid that change, it passed.
- **Pushed and documented.** Commit `a60453be79` is pushed to `kriscendobot:ironhorse-fuzz-findings`. `ensure-pr.sh` picked up the existing PR #1298 rather than opening a new one, and this finding's write-up is at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5865350370.

**Gauntlet:** I didn't start a new one. PR #1298 already has a gauntlet running, and its round-3 review job (`endojs-endo-but-for-bots-pr1298-gauntlet-panel-3`) is waiting in `todo/`. It checks out the PR head when it runs, so it will review this commit.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-fad9672dc7a6e6be-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 3 host(s) (3 unmetered)
- Input: 50 tokens (1646255 cached reads)
- Output: 12713 tokens
- Cost: $1.1681350000000001 (3 engagement(s) unpriced)
- Wall-clock: 509s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
