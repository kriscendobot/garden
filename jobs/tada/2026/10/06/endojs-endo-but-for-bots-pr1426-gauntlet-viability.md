**Viability report: endojs/endo-but-for-bots#1426** ("feat(chat,familiar): render the Familiar security-warning banner")

The gauntlet can begin: nothing has replaced this PR and the problem it fixes is still present on `llm`. A recheck just now shows the PR is still open and a draft. Its head has moved to `5666a29bc4` since the last panel round, which ran on `646201a3a6`. It is based on the frozen `llm-395c485`.

Deciding question: Does current `llm` still lack the Chat security-warning banner, with no other PR or newer change delivering it?

Evidence:
- **The design still lists the work as open.** On `llm`, the Status section of `designs/familiar-localhttp-protocol.md` still names the "Chat security warning banner" (renderer-side display of the `familiar:security-warnings` warnings) as not yet done.
- **`llm` has no banner of its own.** `packages/chat/` on `llm` has no security-warning module.
- **Nothing newer has replaced it.** `llm` is 24 commits ahead of the pinned base, and none of them touch `packages/familiar/*` or the chat entry point.
- **No competing PR exists.** A repo search for this work finds only #1426.
- **The motivating problem is still present.** The Familiar sends the warnings once, before the page is listening, so they are dropped. Chat still has no banner to show them.
- **Review history so far.** No human has reviewed the PR. The bot panel has run six rounds, all must-fix; those are code-quality findings, not a sign the PR is obsolete.

No clean, panel, fix, CI-wait or un-draft budget was spent, and nothing in the garden or the project changed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1426-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (292723 cached reads)
- Output: 2552 tokens
- Cost: $0.9466124
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
