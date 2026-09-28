I rebased endojs/endo-but-for-bots#1345 onto live `llm` and force-pushed it. The PR needs a fresh maintainer approval before the conductor can merge it.

**What changed**
- **Rebase:** the single commit is now `1d69bc1d07` on `llm` at `47f6965d88` (it was `4b0bd5abea` on `llm-efabaed`). I pushed with `--force-with-lease` pinned to the old head.
- **Base:** left as live `llm`, as the job asked, even though the weaver role normally pins a new frozen base.
- **Diff against `llm`:** still only `designs/{AGENTS,ARCHIVE,README}.md`, and Prettier passes on `README.md`.

**How I resolved the `designs/README.md` conflict**
The only design-doc change that reached `llm` since `llm-efabaed` is the `daemon-guest-bot-incarnation` design (Implemented, #1306/#1227). I kept both sides:
- **Summary table:** kept `llm`'s new row, and kept this PR's change of `endo-content-locators-magnet-urn` to In Progress.
- **Dependency graph:** kept the PR's node labels that show each design's status, and added `llm`'s new node with a matching IMPLEMENTED label. The new graph edge, the M3 row and the estimates row merged without conflict.
- **Totals:** the extra row made the PR's recounted totals one short, so I updated them: 76 Complete/Implemented, 240 indexed records, 242 files in the raw count. I added one sentence saying this row landed on `llm` during the pass. The "all 239 ledger records" line is now 240.
- **Not changed:** `ARCHIVE.md` still says 239, because it records what that 2026-09-27 pass audited.

**PR comment:** posted https://github.com/endojs/endo-but-for-bots/pull/1345#issuecomment-5878175948. It sums up the rebase and how I resolved the conflict, and asks for re-approval.

**Follow-up:** once kriskowal re-approves the rebased head, the conductor can merge. If `llm` moves again first, the conductor can re-run its merge attempt.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/1345 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1345-weave-20260928.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1413612 cached reads)
- Output: 8223 tokens
- Cost: $1.0356784
- Wall-clock: 106s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
