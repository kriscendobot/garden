cadence: weekly
last_dispatched: 2026-07-27T02:35:02Z
job_basename_prefix: ebfb-llm-designs-groom
---
# Weekly `llm` designs-directory grooming — Sunday

Act as a gardener and groom the `designs/` directory of
`endojs/endo-but-for-bots` on the current `llm` branch.

Each run:

1. Fetch the current `llm` branch and work from a fresh isolated worktree. Read
   the repository instructions before changing anything.
2. Audit `designs/` and its indexes for status drift, superseded or duplicate
   designs, broken internal links, stale PR/issue references, dangling dependency
   edges, unfiled documents, and open questions that have since been answered by
   merged work. Verify referenced PR and issue state live rather than guessing.
3. Make conservative documentation-only grooming changes. Preserve historical
   design content; mark or link supersession instead of deleting history. Do not
   redesign active work or silently decide unresolved maintainer questions.
4. Run the repository's applicable formatting, link, and documentation checks.
5. If the result is byte-identical, complete with a no-change report and open no
   PR. If changes are warranted, reuse the existing open bot-authored weekly
   grooming PR when safe; otherwise open one bot-authored PR against `llm` with a
   deterministic weekly-grooming branch. Never open multiple concurrent grooming
   PRs.

Report the files and design records examined, changes made, checks run, PR URL if
any, and maintainer decisions intentionally left unresolved. Bot identity only;
do not merge and do not comment on unrelated upstream work.
