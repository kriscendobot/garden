---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-05T15:46:39Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/912

# Dependabotany ledger: endojs/endo-but-for-bots - PR #912 setup-node v6→v7.0.0 → MERGE-NOW (pending maintainer approval)

**Verdict: MERGE-NOW.** `actions/setup-node` v6.x → **v7.0.0**, a `github-actions`
ecosystem major bumping all 24 `uses:` pins across 10 workflows to
`820762786026740c76f36085b0efc47a31fe5020`.

- **Base-ref census (llm):** setup-node pinned at a mix of v6.2.0 / v6.5.0
  (max v6.5.0), uniformly behind v7.0.0. Not superseded by base or any sibling PR.
- **Pin provenance:** lightweight tag `v7.0.0` → commit `820762786026740c76f36085b0efc47a31fe5020`,
  equal to the pin the diff carries. Owner `actions/setup-node` confirmed. Resolved 2026-08-05.
- **Advisory:** no open advisory affects `actions/setup-node` (actions ecosystem). No CVE closed or introduced.
- **Source:** both v6.5.0 and v7.0.0 use `runs.using: node24`; consumed inputs
  (`node-version`, `node-version-file`, `cache`) all present in v7.0.0. Major = internal
  ESM migration + new cache outputs + dummy-`NODE_AUTH_TOKEN` removal. Benign. Publisher
  `gowridurgad` is a recurring setup-node releaser (no new-releaser signal).
- **Maturity:** v7.0.0 published 2026-07-14T02:46:05Z; floor 2026-07-21T02:46:05Z, passed.
- **CI:** all 26 check-runs green on head `2dbc601e1c88aa716988f26026e61dac209025cb`
  (incl. zizmor, check-action-pins). No consuming-code migration needed (inputs stable); none pushed.

**Disposition executed through the conductor spine
(`ci-wait-merge.sh endojs/endo-but-for-bots 912 --merge`): CI GREEN, then BLOCKED
at the intact maintainer-approval gate** — no current APPROVED review on the head
(`reviewDecision` empty; GitHub reports MERGEABLE/BLOCKED). The PR is left open,
mergeable, and green. A single maintainer approval is the only remaining blocker;
the next conductor pass merges it. Verdict comment:
https://github.com/endojs/endo-but-for-bots/pull/912#issuecomment-5193984915

Row retained (not terminal): the merge has not completed. When schedules resume,
the daily backstop sweep re-attempts the conduct; on maintainer approval it merges
and this row is removed. Maintainer alerted via the bus.

Self-improvement: nothing this time.
