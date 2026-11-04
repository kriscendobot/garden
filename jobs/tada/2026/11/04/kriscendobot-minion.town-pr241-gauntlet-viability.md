Viability result for #241: `viability=proceed`. The PR is open and draft, at head `12ff97f9`, based on `main-9196892`.

Deciding question: Is the step 1 subscription freeze from the course-correction design still unimplemented on `main`, with that design still the maintainer's approved direction? Yes.

Evidence:
- **Not superseded:**
  - `main` is still `9196892`, which is the PR's base, so there is no newer base history. The head is 2 commits ahead and 0 behind.
  - Code search for `legacyClaudeSubscription`, `ENDO_CLAUDE_LEGACY_SUBSCRIPTION`, `onboarding-frozen` and `bareCredentialContract` returns 0 hits in the repo. GitHub code search only indexes the default branch, so this reflects `main`.
  - `src/endo/claude/agents.ts` on `main` has no deprecation text. `DEPLOYMENT.md` on `main` has no deprecation decision; its only match is the credentials line.
  - No other PR in the 30 most recent (back to #210) implements step 1. #229 (provider UI) and #238 (workbench design) belong to later steps and change no Claude account, wiring, agents or harness files.
- **Need still holds:**
  - kriskowal approved endojs/endo-but-for-bots#1543 on 2026-11-04 and asked for the design to be conducted and built (https://github.com/endojs/endo-but-for-bots/pull/1543#pullrequestreview-5761476590).
  - At its head `c27d13c6`, `claude-bare-course-correction.md` still lists this exact step 1: the flag, the deprecation marks, the `--bare` probe, and no responder removal.
  - The harness pin on `main` is still 2.1.310, the version whose text the PR's contract pins.
  - The later API-key jobs `build-api-key-agents-p3-provider-ui`, `p4`, `p5` and `api-key-agents-canary-and-retirement` are still on the board, so the sequence is live.
- **Competing proposal:** #217 (namespace-confined subscription CLI) is open and has had no activity since 2026-10-23, with no reviews or maintainer comments. It predates the approval of #1543 and has not displaced it.
- **Review state:** #241 has no comments or reviews, so nothing there objects to it.
- **Unmerged design:** #1543 itself is still unmerged because its own gauntlet halted on a floating base (status comment 2026-11-04T02:30Z), with the conduct job queued. This is a landing-mechanics issue, not a change of direction, and the approval stands.

I spent no clean, panel, fix, CI-wait or un-draft budget and changed no repository.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (170789 cached reads)
- Output: 3957 tokens
- Cost: $0.5028257999999999
- Wall-clock: 110s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
