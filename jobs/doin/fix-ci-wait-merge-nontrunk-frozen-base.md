---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# ci-wait-merge.sh: refuse to merge onto a non-trunk frozen snapshot base

Garden repo (kriscendobot/garden, main2). `scripts/jobs/gardening/ci-wait-merge.sh`
`unfreeze_base_if_frozen()` (around line 401) only recognizes frozen snapshots named
`(llm|main|master)-<sha>`; any other `<feature-branch>-<sha>` base returns 0 and the
conductor proceeds to merge ONTO the snapshot, stranding the content off the trunk
(the #621 failure class). Observed on endojs/endo-but-for-bots#1343 (base
`feat/daemon-provisioning-grants-5feadae`, a snapshot of draft #1042's head); the
conductor agent caught it by hand (journal tada 2026-10-02
endojs-endo-but-for-bots-pr1343-conduct).

Fix: when the base matches `<name>-<hex sha>` and `<name>` exists as a live branch on
the repo but is not llm/main/master, refuse the merge with a distinct exit/reason
(block for maintainer decision: retarget to trunk, retarget to the live feature
branch, or land the parent PR first), never merge onto the snapshot. Add a test.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-05T05:28:37Z
