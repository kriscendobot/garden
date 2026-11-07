I'm reporting `viability=proceed` for PR #228. It is still open, nothing newer has replaced it, and the design that has since merged still depends on it.

Deciding question: Does `main` still lack an agent chat Clip design or implementation, and does the merged design work still expect #228 to be that chat surface?

Answer: yes to both.

Evidence:
- **PR state:** #228 is an open, unmerged draft. It adds one file, `designs/agent-chat-clip.md`, on top of the frozen base `main-443519e`. It has no reviews or comments, and its four open questions for the maintainer are still unanswered.
- **The merged design depends on it:** PR #238 merged on 2026-11-04 and put `designs/api-key-agent-workbench.md` on `main`. That design lists `agent-chat-clip.md` as its companion, "under review in [#228]". It also says the chat Clip belongs to the companion design, not to itself. Its canary phase (W6) runs inside that chat Clip and follows the companion design's chat-Clip phases.
- **Nothing on `main` replaces it:** There is no `agent-chat-clip.md` or other chat-Clip design in `designs/`, and no chat-related file anywhere in the tree. Recent agent work on `main` is different. It is the API-key agent step and detail view behind a flag, the mail list with Retry now and Dismiss, `api-key-agent-directory-authorization.md` (#250), and subagent-delegation fixes. None of it is a chat Clip. The newer directory-authorization design adds isolation rules for Clips in general but doesn't design the chat surface.
- **The original need still holds:** Tracker issue #227 for the minion.town Claude API arc is open and its phases are still moving (#229, endojs/endo-but-for-bots#1543/#1575). The finish line it states, messaging an agent and getting a real reply, still assumes the chat surface this PR specifies.
- **Similar PRs are different work:** #202 ("Chat, a New Clip form for talking with introduced peers") is a separate peer-chat form and still a draft. #88, which this design depends on for nonce locators, is also still an open draft, so open question 1 (wait for #88 or ship a stopgap) is still live and isn't a reason to stop.

I spent nothing on clean, panel, fix, CI or un-draft, and made no changes.

Follow-up: the gauntlet's later stages can start. Before un-draft, the maintainer still needs to answer the PR's four open questions, as the garden's open-questions convention requires.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr228-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (188901 cached reads)
- Output: 1920 tokens
- Cost: $0.4819322
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
