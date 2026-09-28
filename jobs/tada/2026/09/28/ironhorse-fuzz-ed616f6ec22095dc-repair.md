# Completion report: ironhorse-fuzz-ed616f6ec22095dc-repair

The finding was not an engine bug, so there is no engine fix. It was a known bug in the XS reference ("oracle") side of the comparison, already fixed on the standing branch. I added regression tests for it to the standing PR, endojs/endo-but-for-bots#1298, and documented the case there.

**Reproduction.** I recovered the input from the durable artifact (sha256 `e15239bb…6ecde10` matches, 18 bytes).
- **Project SHA `38ca1d18`:** the target crashes with `match meter ironhorse=15749808128 pin=2864906240`.
  - The generated case is a nested `a*`/`a?`/`{1,2}` capture-group pattern with flag `s`, matched against `"aaaaaaaa"` at offset 0. It does not match.
  - The match takes 240323 metered steps, so the raw meter is 15749808128. That is larger than `u32::MAX`, and the pin's value is exactly that number wrapped to 32 bits.
- **Standing tip `a00c20a0ad`:** the same fuzz command exits 0.

**Cause.** At `38ca1d18` the XS comparison shim squeezed its 64-bit meter into a 32-bit field. c8497fd88 (finding 5d122a6fc10babd9) already widened it. This is the same class as fd8517d5f3071227 and 12aca768c2e73c73, and the port was always correct.

**What changed.** Commit `27fd8566dd` on `kriscendobot:ironhorse-fuzz-findings`, pushed with fetch/rebase/push; it is still in the branch under later peer commits.
- New test `ironhorse-vm/tests/finding_ed616f6ec22095dc_regexp_meter_overflow.rs`. It runs without the `c/moddable` submodule and checks:
  - the input's sha256;
  - that the case is still a no-match that neither aborts nor refuses;
  - that the meter stays at the full 15749808128 and is not the old wrapped value.
- New fixtures `finding-ed616f6ec22095dc.{input.bin,regexp-case.txt}`. The regexp-case file was generated with the existing bless mechanism, and `vm_finding_fixtures` now checks it against the input.
- New `ironhorse-fuzz` test `finding_ed616f6ec22095dc_regexp_meter_overflow_agrees`, which checks that XS and the port agree on this exact input.

All of these tests pass locally, and my new files are fmt-clean.

**PR.**
- `ensure-pr.sh --find-only` found the existing PR #1298 and created nothing new.
- I posted the case and its explanation as a comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5866465925

**Gauntlet and CI.**
- I did not post a new gauntlet. `endojs-endo-but-for-bots-pr1298-gauntlet` is already running (fix round 3 in progress, panel-4 next), so it will review this commit.
- CI for this commit on GitHub is not confirmed. Peers kept pushing to the branch (the head is now `c9accbf5d2`), and each push cancelled the test runs on my commit and on the next tip.
- `format-ironhorse` failed on my commit. The cause is a formatting problem in the earlier sibling test `finding_378372c8706a48a8_regexp_exec_meter.rs`, not in my files. It passes at the later tip `7fdaff6`.

**Follow-ups.** None required. CI on the latest head is left to the running gauntlet.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `c9accbf5d25058238733a4838e7146581d2913c7`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-ed616f6ec22095dc-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (2 unmetered)
- Input: 92 tokens (3466115 cached reads)
- Output: 17111 tokens
- Cost: $1.7175389999999997 (2 engagement(s) unpriced)
- Wall-clock: 2762s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
