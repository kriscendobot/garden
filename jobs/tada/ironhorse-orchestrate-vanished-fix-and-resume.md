Root cause: a single stale synced snapshot could classify a completing child as `gone`. Fix `9393c3ce6d` adds bounded re-sync/re-read before that terminal verdict, with deterministic regression coverage. `orchestrate-test.sh`: 41 passed.

Deployed: leader broadcast confirmed `main2` at `39f509d00d`, which includes the fix.

Budget: all Ironhorse stage/gauntlet ledgers total 3,307,979 billable tokens; `2,080,000 - 3,307,979 = -1,227,979`. Per maintainer authorization, launch enforcement uses the mechanism-consistent child-ledger total: `2,080,000 - 1,329,482 = 750,518`.

Resume-3 launched successfully with 21 children, serial/halt, cap 750,518. The leader promoted and claimed `ironhorse-js-08-async-generators-for-await`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-orchestrate-vanished-fix-and-resume.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 737s

<!-- garden-usage-end -->
