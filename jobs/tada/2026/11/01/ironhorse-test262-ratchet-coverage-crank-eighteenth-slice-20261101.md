I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1618, which adds 58 test262 rows to the ratchet with no regressions. CI hadn't finished when I stopped: 7 checks passed, 0 failed, 23 still queued behind the runner backlog. The gauntlet staged when this job completes will shepherd CI.

**Row selection.** I first announced my rows and files to the live crank slices (15th, 16th, 17th, 10th). Nearly every remaining failing row was already claimed by an open slice PR or is an XS-oracle problem where Ironhorse is right. So I took the largest unclaimed bucket: the ~900 `skip:ironhorse-aborted-limit` rows in `built-ins/RegExp/property-escapes`, `unicodeSets/generated` and `CharacterClassEscapes`.

**Cause.** These tests halted with `HeapExhausted` in the regexp matcher. A greedy loop saves one backtrack state per matched position, and the matcher refuses the 65,537th state (`MAX_MATCH_STATES`). XS has no such cap, so it completes. This is item RGX-1 in the 2026-10-16 architecture review.

**Fix** (`rust/engine/ironhorse-regexp/src/matcher.rs`):
- The backtrack stack is now run-length compressed. States that differ only in their offset are stored as one record plus a shared stack of offsets.
- Pops and lookahead truncation return exactly what the plain stack would, in the same order. Matcher steps, computrons and results are unchanged.
- Both ceilings still apply: the state cap now bounds records, and the byte cap counts each stored offset at 4 bytes. Alternation-heavy patterns like `(a|aa)+` keep their limit.

**Tests:**
- A randomized test checks the compressed stack against a plain one, plus a test of a long greedy run past the old cap.
- A new `ironhorse-262/tests/regexp_long_greedy_runs.rs` checks agreement with the XS oracle on long runs, backtracking, lookaheads and astral `\p{L}` strings.
- I re-ran all 74 RegExp-related whole-tree shards locally with the release runner. Four shards changed, all progress (`property-escapes/generated@@0000/0001/0003/0004`); the other 70 are unchanged.
- The regexp test suites pass; formatting and clippy (CI's 1.88.0 toolchain) are clean.

**Why only 58 of ~900 rows.** The other ~820 rows now get past the matcher but halt on the 256 MiB heap ceiling. The test harness builds its strings by concatenating about 110 times, which leaves about 250 MiB of garbage, and Ironhorse doesn't collect garbage until the run finishes. With a 512 MiB ceiling, two sample tests pass on both engines. I didn't raise the ceiling, because that would hide the missing collection rather than fix it.

**Follow-ups:**
- I parked a design plan, `design-ironhorse-in-crank-string-garbage-chunk-ceiling`. It covers collecting garbage mid-run, string concatenation that doesn't copy, or a harness-only ceiling. It also includes two related review points: making a matcher ceiling a catchable error, and clamping quantifier bounds above 2^31−1 as XS does.
- My closing message to the peers reached the nineteenth slice. The 15th, 16th, 17th and 10th had already finished, so the message was dead-lettered and will become four no-op jobs that whoever claims them can close.
- I added the stacked limits, the plan name and the dead-letter lesson to the crank-coordination memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-eighteenth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 226 tokens (17282453 cached reads)
- Output: 60949 tokens
- Cost: $6.462462599999995
- Wall-clock: 4437s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
