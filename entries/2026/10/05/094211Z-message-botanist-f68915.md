---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-05T09:42:13Z
---
# Dependabotany: kriscendobot/minion.town PR #158 — MERGE-NOW (merged)

project: minion-town

- PR: https://github.com/kriscendobot/minion.town/pull/158
- Bump: @anthropic-ai/claude-code 2.1.278 -> 2.1.283 (tools/claude-harness), plus its 8 platform optional deps
- Verdict: MERGE-NOW. Terminal: merged 2026-10-05T09:41:57Z as 9d563c97090b.
- Maturity floor: 2026-10-02T18:49:30Z (freshest moved version: @anthropic-ai/claude-code-linux-x64@2.1.283, published 2026-09-25T18:49:30Z). Already passed.
- Advisories: none on either side (OSV + GHSA).
- Migration: Dependabot's head failed `test` because check.mjs pins release.json. Fixed by running the README's `npm run claude-harness:refresh` (signed manifest verified), landed as commit 65c7654. CI on that head was 3/3 green.
- Recurring note: every claude-code bump on this repo needs that refresh step, so expect each Dependabot head to be red until it is run.
- Verdict comment: https://github.com/kriscendobot/minion.town/pull/158#issuecomment-5991952738
