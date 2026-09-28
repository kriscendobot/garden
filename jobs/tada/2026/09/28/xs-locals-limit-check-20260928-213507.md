**Result: not yet landed.** Moddable's parse-time check for the 65535-locals-per-frame limit is not upstream.

Checked on 2026-09-28, read-only through the GitHub API (no interaction with upstream):

- **Default branch:** it's `public`, not `master`. Its tip is still **`b6e06ba70`** ("cleanup (thanks Peter)", 2026-09-04T19:34:19Z), the same commit recorded on 2026-09-14. There have been no upstream commits since.
- **`master`:** stale, tip `48ee02d8c` from 2026-06-17 ("version bump 8.2.3").
- **Newest release:** **9.5.0**, published 2026-09-05. Its tag resolves to exactly `b6e06ba70`, and its notes cover changes only through 2026-09-04, so the fix isn't in it. The fix is expected in the next release (probably ~early October, going by the monthly cadence).
- **XS parser/codegen sources at the tip:** `xsScope.c`, `xsSyntaxical.c` and `xsCode.c` have no local-count or frame-slot check. The only `65535` hits are in `xsCode.c` (lines 305 and 350), where it picks the wider opcode encoding for large indexes; that code doesn't reject anything. The last change under `xs/sources` is `f723e8f1c` (2026-09-01, "don't use undefined behavior to detect overflow"), which is not this fix.
- **Other branches:** `XS-14.1`, `XS-14.2`, `XS-14.3`, `zephyr`, `mcrun`, `idf-v5`, `pebble`, `matter_esp32` and `revert-937-fix-ts` are all older than 2026-09-04. None were checked for the fix.

Nothing changed: no commits, no follow-up jobs, and the schedule `schedules/xs-frame-locals-limit-upstream-watch.md` is still active. It ticks again in a week.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs-locals-limit-check-20260928-213507.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (307736 cached reads)
- Output: 2587 tokens
- Cost: $0.44655120000000004
- Wall-clock: 39s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
