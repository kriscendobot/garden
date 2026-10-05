PR #1426 can enter the gauntlet: it is open and nothing has superseded it, and the gap it fills is still there on `llm`.

**Deciding question:** Does current `llm` still lack a Chat-side display of the Familiar's `familiar:security-warnings`, with no other PR or commit providing one?

**Answer:** Yes, `llm` still lacks it and nothing else provides it.

**Evidence:**
- **PR state:** #1426 is open, a draft, and unmerged. It was opened 2026-10-05T11:54Z by job `build-familiar-localhttp-protocol`, has no reviews or comments, and its head is `d9acaed022`.
- **Base:** the PR sits on the frozen snapshot `llm-395c485`. Comparing that snapshot to `llm` shows `llm` 0 commits ahead, so nothing newer has landed on the trunk that could have displaced it.
- **Design status on `llm`:** the "Not yet implemented" list in `designs/familiar-localhttp-protocol.md` still names "Chat security warning banner — renderer-side display of warnings from the `familiar:security-warnings` IPC channel". That is the PR's stated purpose.
- **Code on `llm`:**
  - `packages/chat/security-warning-banner.js` does not exist (404).
  - A code search for `onSecurityWarnings` finds only `packages/familiar/preload.mjs` and two design docs. No Chat consumer exists, so the warnings are still sent but never shown.
  - The PR also fixes a delivery race: `electron-main.js` sends the warnings only once, while the page is usually still loading, so they are lost.
- **Competing work:** a PR search for "security warning banner" finds only #1426.
- **Out of scope here:** Layer 6 (iframe sandbox) and the MessagePort bridge stay open, assigned to `familiar-chat-weblet-hosting`. That does not overlap with this PR.

No clean, panel, fix or CI-wait budget was spent, and no repo changes were made.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168124 cached reads)
- Output: 1485 tokens
- Cost: $0.4086048
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
