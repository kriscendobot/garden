I added the must-fix summary renderer and wired it into `gauntlet.sh`. It's pushed to `main2` as `2b15c580f34`, and the full `gauntlet-test.sh` suite passes (89 passed, 0 failed).

**What a gauntlet that ends early now posts**
- Applies to review-budget-reached, halted and parked-ci-billing; held-draft gets no summary.
- The terminal PR status comment keeps its existing count line and adds a summary from the new script, `scripts/jobs/gardening/gauntlet-mustfix-summary.sh <journal-dir> <base> <last-round> [max-iterations]`. It uses no LLM and always exits 0.
- **Header:** how many must-fix items are unaddressed, a verdict, rounds spent against `max_iterations`, and cost so far. Cost adds up the `- Cost: $` lines already stamped on the panel and fix reports, so no new metering was needed. If `max_iterations` isn't passed, it is read from the gauntlet's own tada report.
- **Trend line:** for each round, how many items were raised, fixed and carried over.
- **Class counts:** persistent, new in the last round, and addressed-then-reintroduced.
- **Item list:** each item shows its class, the round it was first raised, the juror seat, `file:line` when one appears, and truncated text. The list is capped at 12 items with "… and N more" after that.
- **Verdict rules** (documented in the script header, first match wins, where L is the number of items left after the last round):
  1. L = 0 → converging.
  2. At least half of L are persistent → stuck on N persistent items.
  3. L is smaller than the previous round's count → converging.
  4. Anything else, including a single round → moving target.

**Matching items across rounds:** an item is identified by its seat plus its normalized text, so a reworded finding counts as new. This assumes the bullet shape `panel-run-record.sh` writes (`must-fix items (N):` followed by `- seat: text` lines); the script reads the last such block in each panel report.

**Untrusted text:** must-fix text is treated as data. Control characters, backticks and `[ ] < > | * ~ !` are stripped, leading `#`/`>` are removed, `@` becomes `(at)`, and each item is cut to 160 characters. The whole list sits inside a fenced `text` block.

**Fail-soft:** if a report has no structured list, the summary prints the count (or "unknown") plus "list unavailable".

**Tests:** new subtest 21 in `gauntlet-test.sh` covers a persistent item, a moving-target series with a reintroduced item, a shrinking (converging) series, two old-format reports, an oversize list, and a hostile item. The existing review-budget test (g3) now also checks that the posted comment includes the summary ("stuck on 2 persistent items").

**Follow-ups**
- Real panel stage reports are written in prose by the model and often don't include the `must-fix items (N):` bullet block. Those will show "list unavailable" until the panel stage reliably keeps that block, for example by having the gauntlet's panel-stage prompt require it. That is not part of this change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/gauntlet-mustfix-summary-renderer.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1340373 cached reads)
- Output: 17938 tokens
- Cost: $1.2052506000000003
- Wall-clock: 590s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
