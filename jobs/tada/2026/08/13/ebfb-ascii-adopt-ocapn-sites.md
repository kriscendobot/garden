Implemented and opened draft PR https://github.com/endojs/endo-but-for-bots/pull/980 against frozen base `llm-a54c3ad`.

- Adopted `@endo/ascii` for SwissNum strings, cryptographic prefixes, and hub string swissnums.
- Preserved immutable wrapping, `TextDecoder`, and binary swissnum behavior.
- Added runtime dependency, composite metadata, changeset, focused tests, and separate lockfile commit.
- Verification: focused tests passed 3/3 across all three SES configurations; full OCapN suite passed 537 tests per configuration; thixotrope passed 30 tests with 3 skips; lint/typecheck had 0 errors; five review probes passed. Deliberately broken adoption paths failed the new tests.
- The repository-wide harness was not verified because unrelated daemon and filesystem-exec tests timed out and left hung processes under heavy host load. CI is running.
- Self-improvement: reported the local-verification timeout/process-cleanup gap to `role/liaison`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-ascii-adopt-ocapn-sites.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 4797s

<!-- garden-usage-end -->
