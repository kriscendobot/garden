---
role: shepherd
model: gpt-5.6-terra
priority: urgent
---
Shepherd endojs/endo-but-for-bots#714 in response to the trusted maintainer directive https://github.com/endojs/endo-but-for-bots/pull/714#issuecomment-4981830543.

Re-fetch the live PR head, all reviews, review threads, comments, and status checks. Drive CI and review follow-ups to green/settled within the shepherd role, preserving requested-changes signal rather than dismissing it. Push only to the bot-authored PR branch, post the required completion summary with addressing SHAs and verification, and re-request maintainer review only after the PR is genuinely ready. This job is explicitly authorized by kriskowal comment 4981830543 for the necessary PR-branch pushes and PR replies/comments. Do not merge.
