I replaced the PR body on endojs/endo-but-for-bots#1387 and posted the follow-up comment. No code changed; the head is still `dc9f9a251`.

- **PR body:** I replaced it with the BODY text from the job using `gh pr edit`. It still carries the `<!-- garden-job: endo-daemon-idempotent-start-build -->` marker. Read back from GitHub, the body matches the job text exactly except for one trailing newline, which GitHub drops.
- **Follow-up comment:** I posted the COMMENT text as a top-level comment: https://github.com/endojs/endo-but-for-bots/pull/1387#issuecomment-5904936057. Before posting I checked that no earlier run had already left a "Follow-up in dc9f9a251" comment, so there is no duplicate.

Both writes worked from endolin; the 403 seen on the oros-studio host did not come up. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-daemon-idempotent-start-pr1387-body-refresh.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (116761 cached reads)
- Output: 2701 tokens
- Cost: $0.4226442
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
