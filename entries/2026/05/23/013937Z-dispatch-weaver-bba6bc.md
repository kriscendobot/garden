---
event: dispatch
role: weaver
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/weaver--bba6bc
repo: endojs/endo-but-for-bots
pr: 347
branch: mirror/3033-ocapn-cbor
trigger: kriskowal directive 2026-05-23T01:38:37Z on #347 — "Please change the merge base to master and reconstruct."
---

# Weaver dispatch: reconstruct PR #347 onto master

PR #347 currently bases on `llm`; kriskowal wants it rebased onto `master` with the base changed accordingly.

Procedure:
1. Sync bot-master to current endo-upstream/master (per `feedback_bot_master_reset_to_actual.md`, may be no-op).
2. Identify the commits unique to mirror/3033-ocapn-cbor (the PR's own changes — not in llm, not in master).
3. Rebase or cherry-pick those commits onto fresh bot-master.
4. Resolve conflicts per skills/conflict-resolution/SKILL.md.
5. Force-push the rebuilt branch.
6. Change the PR base via `gh pr edit 347 --repo endojs/endo-but-for-bots --base master`.
7. Verify with `gh pr view 347 --json baseRefName,mergeStateStatus`.
8. Post a top-level PR comment with the new head SHA, what commits were carried, and confirmation that the base was switched.
