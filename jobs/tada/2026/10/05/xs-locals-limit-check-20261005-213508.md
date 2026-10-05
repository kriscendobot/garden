The fix has not landed upstream yet. The schedule stays in place and will tick again next week.

**What I checked (read-only, through the GitHub API, with no interaction upstream):**
- **Tip:** `Moddable-OpenSource/moddable`'s default branch is now `public`, not `master`. Its tip is `b6e06ba705` ("cleanup (thanks Peter)") from **2026-09-04T19:34Z**, which is the same sha the job recorded on 2026-09-14. The repo's `pushed_at` is 2026-09-05T00:25Z, so nothing has been pushed since. The old `master` branch stopped at 2026-06-17 (`48ee02d8cf`, 8.2.3).
- **Releases:** the newest is **9.5.0** (published 2026-09-05). Its tag points at that same commit `b6e06ba705`, so it adds nothing beyond the tip. Its release notes don't mention a frame-locals limit, a parse-time locals rejection or this fuzz finding.
- **Source at the tip:** I searched `xs/sources/xsSyntaxical.c`, `xsScope.c` and `xsCode.c` for `65535`, `0xFFFF` and "too many locals/variables". The only hits are two `if (value > 65535)` lines at `xsCode.c:305` and `xsCode.c:350`. They pick the operand width (1, 2 or 4 bytes) when encoding local and closure indexes; they don't reject anything. There is still no check at parse time.

**Changes:** none. Nothing was committed, and `schedules/xs-frame-locals-limit-upstream-watch.md` was not retired.

**Follow-ups:** the commit and tag watch on `public` should keep going. The Iron Horse port (`ironhorse-port-xs-frame-locals-limit`) doesn't depend on this. The schedule's spec still says "master". Future runs should check `public`, since that is where the 2026-09-04 baseline lives.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs-locals-limit-check-20261005-213508.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (284957 cached reads)
- Output: 2204 tokens
- Cost: $0.4789754
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
