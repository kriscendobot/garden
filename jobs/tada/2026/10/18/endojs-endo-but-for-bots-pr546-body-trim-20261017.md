I replaced the body of https://github.com/endojs/endo-but-for-bots/pull/546 with the trimmed text from the job, word for word. The edit went through on this host (`endolin-garden-ece02cb4`); the 403 the oros-studio bot token hit did not happen here.

- **What I ran:** I wrote the text between the BODY markers to a temporary file and ran `gh pr edit 546 -R endojs/endo-but-for-bots --body-file <file>`.
- **Before:** the PR was open, titled "feat: support .ts runtime modules via erasable type syntax", and its body was 4298 characters.
- **Check:** I fetched the body back after the edit and compared it with the file I sent. They match except for one trailing newline at the end.
- **Nothing else changed:** the title, base, head, labels and draft state are untouched. I made no garden commits.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr546-body-trim-20261017.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (122465 cached reads)
- Output: 2277 tokens
- Cost: $0.422033
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
