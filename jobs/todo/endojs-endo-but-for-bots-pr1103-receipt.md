---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# receipt (auto) — completion receipt for endojs/endo-but-for-bots PR #1103 (closed)

tier: mentor
fallback-tier: minion

This OPEN-and-now-closed PR was completed by the garden. Emit its COMPLETION
RECEIPT deterministically — run the generator, which builds the per-engagement
rows + the maintainer-review heuristic, posts the PR comment (identity-pinned
gh), and archives the receipt in the journal, all idempotently:

    scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1103

It is fail-open and idempotent (journal archive file + comment marker guards),
so a re-run never double-posts. Report the archive path and the posted comment
URL. See designs/pr-completion-receipts.md and scripts/jobs/pr-receipt.sh.

PR: https://github.com/endojs/endo-but-for-bots/pull/1103
