---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 071a9f
dispatch_root: dispatches/fixer--071a9f
repo: endojs/endo-but-for-bots
branch: claude/claude-sandbox
pr_number: 486
model: sonnet
---

RSVP kriskowal's review on PR #486 (review id 4548846674,
2026-06-22T23:56:14Z, https://github.com/endojs/endo-but-for-bots/pull/486#pullrequestreview-4548846674):

> This looks to be on track to me. We should reason through and
> communicate the risks of credentials leaking through the sandbox
> environment. I believe `claude` must mask these out for
> subcommands it uses through tool calls, but that is worth
> validating.

Plus 8 inline asks:
1. `buffered-channel.js:15` — "Prefer makeExo over Far every time."
2. `buffered-channel.js:1` — duplicates `@endo/exo-stream` (buffered
   reader/writer with backpressure); designer being dispatched to
   consolidate (SKIP — designer's scope).
3. `docs/claude-sandbox-directory.md` — "Guiding principle" idiom
   out of vogue.
4. `claude-client-module.js:98` — use passable context consistently;
   daemon has a cancellation-kit utility that could be extracted.
5. `claude-client-module.js` — use `@import` JSDoc style (gardener
   meta: strengthen rule for builders + reviewers).
6. `claude-client.js:65` — could be more succinct with
   `@endo/streams` + map reader (see daemon's CapTP setup).
7. `claude-client.js:217` — magic number should be threaded as
   option (gardener meta: juror should anticipate).
8. `buffered-channel.js:53` — model with `@endo/stream` pipe and
   pump.

PR author is kumavis (external) but the bot has push access on
kumavis branches per repo convention; the most recent commit
`87bfd5d5a` "docs(claude-sandbox): credential-exposure risk +
review nits" is from the bot already. Continue iterating.

Gardener-meta notes (items 5 and 7) will be relayed to gardener
inbox in a separate message.
