I recorded kriskowal's "Yes." answer to the Open Question on endojs/endo-but-for-bots PR #1357 as a settled decision, pushed it, and replied on the review thread.

- **Commit:** `3a9c6be603` (`docs(design): settle the single-principal store for guest credentials in Decision 11`), pushed to `design/endo-claude-inference-backends`. It is one file, `designs/endo-claude-inference-backends.md`, with 8 lines added and 7 removed. I did not rebase or change the base (`llm-47f6965`).
  - **Decision 11:** now says the single-principal secret store is acceptable for guests' credentials until the owning-principal column lands. Guests bringing their own credential depend only on the slice (Decision 9), not on the column as well. It cites https://github.com/endojs/endo-but-for-bots/pull/1357#discussion_r4149077338 as the source.
  - **Open Questions:** the question is removed and the section now reads "None."
  - **Known Gaps:** the owning-principal column TODO stays, with a note that guests bringing their own credential don't wait on it.
  - **Updated row:** now also notes that Decision 11 was settled per that review comment.
- **Reply:** posted on comment 4149077338 with the commit SHA and a summary of the changes: https://github.com/endojs/endo-but-for-bots/pull/1357#discussion_r4149872876

As instructed, I did not un-draft or merge the PR; the conductor child in this orchestration handles that. There are no other follow-ups.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `50917af1a439419d6ccc5b91ceb11acb0c5bff59`; this job presented `3a9c6be6030fad904d5e559efc1cc3627c1e9197`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-review-answer-oq1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (225396 cached reads)
- Output: 2352 tokens
- Cost: $0.4489512000000001
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
