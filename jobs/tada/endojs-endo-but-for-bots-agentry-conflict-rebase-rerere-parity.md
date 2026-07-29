Implemented and pushed `670e13cd46` to PR #881’s branch.

- Isolated eval fixture and conflict-rebase test Git commands from ambient rerere config.
- Confirmed host globals had rerere enabled/autoupdate enabled.
- Verified with direct AVA run: 13 conflict-rebase tests passed; ESLint passed.
- Note: `yarn workspace @endo/agentry test` could not launch due to missing executable shims in the warmed dependency cache; direct AVA CLI was used.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-agentry-conflict-rebase-rerere-parity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 159s

<!-- garden-usage-end -->
