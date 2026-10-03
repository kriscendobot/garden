Viability verdict for kriscendobot/minion.town PR #148: **proceed**. The gauntlet may begin.

**PR facts:** The PR is open, unmerged and still a draft. It is titled "feat(claude): run confined inference through the Claude CLI backend". The head is `build/claude-cli-provider` at `6f604ae4c71f`, and the base is the frozen `main-ec8db3f`.

Deciding question: Is the production Claude CLI provider wiring that #148 adds (`cli-provider.ts`, `credential-vault.ts`, `cli-launch.ts`, vendored `@endo/claude`) still missing from `main`, and does the maintainer still want it run through the gauntlet? Yes.

Evidence:
- **The work is not on `main`.** None of `cli-provider`, `credential-vault`, `cli-launch` or `vendor/endo-claude` exists in the current `main` tree.
- **Nothing newer replaces it.** Only #146 has merged since the base `ec8db3f` (2026-10-03 05:53Z). #146 switches in-flight inference cancellation to upstream `@endo/cancel`; it is next to #148's work but does not do it. #148 itself says it supersedes the older #105.
- **The maintainer still wants it.** kriskowal's CHANGES_REQUESTED review at 2026-10-03 12:34Z explicitly asks: "Please run a gauntlet and verify that it fixes Botese," and asks that #148 reach the guest through the daemon's own socket and client rather than copying daemon code. The bot answered at 13:21Z with fixes at `6f604ae`: the duplicate MCP socket and relay were removed, Claude now launches the daemon's own `@endo/agent-mcp-stdio` client, and the Botese check came back clean.
- **The motivation still holds.** This is child 1 of orchestration `minion-town-claude-cli-production-20261003`, which implements kriskowal's Track A decision from 2026-10-03. The production canary (child 2) builds on it.
- **The earlier halt was not about the PR.** The previous gauntlet (`kriscendobot-minion-town-pr148-gauntlet`) halted because its viability stage was retried until the retry limit ran out. The last failure was classed as transient, so this restage is valid.

Follow-up for the next stage: #146 landed on `main` after this PR's frozen base, and #148 also changes the cancellation contract (`086797f`). Expect a cancellation-area conflict when the PR is next rebased onto `main` (a weave).

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (166568 cached reads)
- Output: 1705 tokens
- Cost: $0.4196856000000001
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
