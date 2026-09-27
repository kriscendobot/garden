Finding `931a687135cabb0c` was a fault in the XS oracle's number formatting, not an Ironhorse bug. So there's no engine fix, and I added regression tests to the standing PR instead. No earlier attempt at this job had committed or pushed anything, so this run started from scratch.

**What the finding is:**
- I restored the 5-byte input from the durable artifact, and its sha256 matches (`dca671e3…`).
- I reproduced it at `38ca1d18` with the fuzz service's prebuilt `differential_source` binary. The input generates `((310378496 + (310378496 + (43 + false))) * (…same…))`, which is `620757035²`, and both engines compute the same double, `385339296501991232`.
- They differ only in how they print it:
  - **XS** prints `385339296501991200`. That is exactly halfway between two neighbouring doubles (`…168` and `…232`), and reading it back gives `…168`, so it does not round-trip.
  - **Ironhorse** prints `385339296501991230`. That is what ECMA-262 §6.1.6.1.20 requires, and Node/V8 print the same.
- This is the same class as the earlier finding `05264cccae42245a`. The standing branch already handles it, because the comparison checks Ironhorse's output against the oracle's exact double rather than XS's spelling. On the branch tip, `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1` exits 0 (I ran it with the full oracle built).

**Changes, in commit `f798d12809` on `ironhorse-fuzz-findings`:**
- `rust/engine/ironhorse-vm/tests/finding_931a687135cabb0c_tie_dtoa.rs`, plus the input saved as `fixtures/finding-931a687135cabb0c.input.bin`. This test doesn't need the XS submodule, so CI runs it. It replays the exact bytes through a copy of the generator and checks three things: the program completes, the output is `…230`, and XS's spelling reads back as a different double. It passes (3/3).
- `ironhorse-fuzz` test `finding_931a687135cabb0c_tie_dtoa_agrees`, which runs the differential check against the oracle. It passes locally, but CI can't run it because it needs the submodule.
- The push went through on the first try after fetching and rebasing. The only uncommitted change left in the checkout was `packages/floot/package.json`, which was modified by the cache setup rather than by this job. I reverted it and did not commit it.

**PR:** `ensure-pr.sh --find-only` found the existing standing PR, endojs/endo-but-for-bots#1298 (draft, base `llm-387ea66`), and its head is now `f798d12809`. I posted a comment there documenting this finding and why no fix was needed: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855298541

**Follow-ups:**
- I did not run the gauntlet on #1298, because gauntlets now run only when the maintainer triggers them. Nothing in this finding blocks one.
- I added a note on this re-discovery, and how to tell it apart from the other number-formatting class, to the garden memory file.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-931a687135cabb0c-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 3 host(s) (3 unmetered)
- Input: 44 tokens (1456628 cached reads)
- Output: 10874 tokens
- Cost: $1.1169736 (3 engagement(s) unpriced)
- Wall-clock: 684s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×2

<!-- garden-usage-end -->
