---
tier: mentor
dispatch: automatic
fallback-tier: minion
---
# Rebalance the Garden 1 and Garden 2 monk pools after the Claude quota reset

Maintainer directive from https://github.com/kriscendobot/garden/issues/89#issuecomment-5745084854: Claude quotas have reset on Gardens 1 and 2; rebalance their monks now.

Rebalance the Anthropic worker capacity on `endolin-garden-ece02cb4` and `endolin-garden2-5bcdff64` only. Read fresh `budget/live/` samples plus `config/budget-pools`, `config/worker-leveling`, and the two `hosts/` records before acting. The configured two-host monk fleet envelope is 6 with physical caps of 4 each; with both weekly windows freshly reset, the calibrated-capacity allocation is expected to be 4 monks on `endolin-garden-ece02cb4` and 2 on `endolin-garden2-5bcdff64`, but verify the live evidence and supported proportional-allocation logic rather than blindly copying those numbers.

Apply any count changes through the supported host-local `set-workers.sh monk` path or remote `send-host-op.sh ... op=set-workers kind=monk` sysop path. Wait for remote acknowledgments, confirm the journal host declarations and scaler reconciliation/live units as far as each host's evidence permits, and report exact before/after counts. Do not change cleric counts, the foreman brake, or unrelated hosts as part of this narrowly-scoped rebalance. If the automatic `budget-level.sh` controller is frozen by the known `oros-studio-garden-ce242c49` missing-cap configuration, do not turn this operational request into a code/config repair; perform the supported manual rebalance and name that separate follow-up in the report.

Reply on the issue thread with the completed rebalance and verification evidence. Never close the issue.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-89
issue_url: https://github.com/kriscendobot/garden/issues/89#issuecomment-5745084854
submitter: kriscendobot
----- END ISSUE NOTE -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-19T20:48:30Z
