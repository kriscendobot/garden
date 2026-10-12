Endo PR #1412 (item 4 phase 2) was approved by kriskowal at 21:08Z and merged to `llm` at 21:51Z, so phase 3 is now unblocked. I posted the phase 3 build job, updated the issue body, and left one short comment on issue 89. No box changes.

**What I checked**
- **endojs/endo-but-for-bots#1412:** merged; `llm` is now at `204033b398`. Phases 1 (#1403) and 2 of the item-4 design are both on `llm`.
- **endojs/endo-but-for-bots#1015:** already merged (2026-09-29).
- **endojs/endo-but-for-bots#1125:** closed; the stack that replaced it has landed.
- **kriscendobot/minion.town#87:** merged (2026-09-22).
- **kriscendobot/minion.town#167:** still draft. Its open questions 1–4 are still waiting on the maintainer.
- **kriscendobot/minion.town#171:** still draft (head `f5b24a4c`). It waits on its ledger's phases 1 and 3, which the issue-58 press carries.
- **Phase 3 of the design:** this is minion.town work. It moves the Claude credentials onto the daemon's `@secrets` and adds the root canary. `@secrets` already exists in Endo, and no job on the board covered phase 3.

**What I changed**
- **New job `build-minion-town-inference-phase3-secrets`** (builder, minion.town, draft PR, then the gauntlet). It covers:
  - a checked Endo pin bump to `204033b398` or later;
  - moving the Claude credential store and `setup-token` capture onto `@secrets`;
  - a prompt-origin gate on the root backend, kept off in production behind `ENDO_CLAUDE_ENABLED`.

  The job body tells the builder not to run the canary. The parked `minion-town-claude-kriscendobot-canary-after-connect-20261006` owns it, and it is still waiting on the maintainer's "connected" reply.
- **Issue 89 body:** added a 22:2xZ status entry. In "Reviews that unblock the most", #1412 is now listed as answered and merged, and the "Ask now" line says no endo review is pending.
- **Comment:** https://github.com/kriscendobot/garden/issues/89#issuecomment-6133700284

**Follow-ups**
- No endo review ask is open. The next one comes when a later phase of the design touches Endo.
- Still waiting on the maintainer for two things: the answers to #167's open questions 1–4, and the "connected" reply for the kriscendobot Claude canary.
- The `endojs-endo-but-for-bots-pr1412-conduct` job is still in progress (post-merge).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20261012-220527.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1326415 cached reads)
- Output: 8964 tokens
- Cost: $1.003499
- Wall-clock: 117s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
