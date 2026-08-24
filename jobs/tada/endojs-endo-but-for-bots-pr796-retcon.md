Retconned PR #796 and force-pushed head `13017fa0b`.

- Restaged five commits: `crc32`, `daemon`, `zip`, design docs, then separate `chore: Update yarn.lock`.
- Preserved the exact pre-retcon tree (`git diff --exit-code` empty; matching tree hash).
- Package typechecks and ESLint completed without errors. CRC32 passed 18 tests, daemon hashline passed 67, and zip passed 13.
- Posted summary: https://github.com/endojs/endo-but-for-bots/pull/796#issuecomment-5402413002
- Follow-up: GitHub CI is running. The warm dependency cache omitted runnable Yarn binary links, so local checks required direct binary invocation.

Self-improvement: report the warm-cache binary-link defect for garden tooling follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-retcon.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 299s

<!-- garden-usage-end -->
