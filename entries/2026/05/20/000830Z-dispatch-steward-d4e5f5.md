---
ts: 2026-05-20T00:08:30Z
kind: dispatch
role: steward
to: fixer
dispatch_id: d4e5f5
dispatch_root: /home/kris/dispatches/fixer--d4e5f5
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Dispatch fixer d4e5f5 — rigorous SmallCaps treatment in JSON pathway (PR #290)

kriskowal on PR #290 (`https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4493261993`, 2026-05-20T00:07:18Z):

> @kriscendobot I'm also concerned about smallcaps strings getting inadvertently misinterpreted. That's a huge footgun, but patterns can usually catch that. As long as we're using JSON, we need a rigorous treatment on SmallCaps.

Context: PR #290 is the lal pi-harness refactor. Prior round's a0ee8b5e8f54 deemphasized smallcaps in agent.js by rewriting `packages/lal/primer/smallcaps.md` and renaming the prompt's `## SmallCaps` section to `## Message numbers`. The maintainer's followup raises a *deeper* concern: even with the prompt deemphasized, smallcaps-encoded strings can flow through the JSON args pathway and get inadvertently misinterpreted on decode.

Ack landed at 00:07:35Z (👀 on issue_comment 4493261993).

The fixer dispatch needs to:
1. Identify the JSON-decoded args pathways in `packages/lal/src/pi-agent-core/` (and the tool-arg flow generally — `validateAndFixupArgs`, `makeExecuteTool`, `convertToLlm`).
2. Identify where smallcaps-shaped strings (`"+N"`, `"#alias"`, `""`, `"%percent"`, etc.) could land in tool args after JSON decode and be misinterpreted as smallcaps tokens by downstream consumers.
3. Add pattern-based detection (per the maintainer's "patterns can usually catch that" hint) to either: (a) reject ambiguous strings at the JSON boundary, (b) auto-quote them via the SmallCaps escape convention, or (c) constrain the tool-arg surface to a non-overlapping subspace. Pick whichever is most rigorous + lightest.
4. Add tests in `packages/lal/test/` that exercise the footgun: an LLM-emitted JSON arg containing a string like `"+5"` or `"#main"` that, without rigorous treatment, would be misread as a message number / alias / tag.
5. Keep this as one focused commit (or 2-3 if the change naturally splits between detection + tests).

Run `yarn lint:prettier` locally before push.

Report: pathways identified, the strategy you picked and why, commit shas, push result, test results, and any follow-up the next maintainer round will likely want.
