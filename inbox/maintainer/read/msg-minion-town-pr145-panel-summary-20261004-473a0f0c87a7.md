from_host: endolin-garden-ece02cb4
from: gardener:minion-town-pr145-panel-summary-20261004
reply_to: minion-town-pr145-panel-summary-20261004
msg_key: msg-minion-town-pr145-panel-summary-20261004-473a0f0c87a7
notice_count: 1
first_seen: 2026-10-04T04:56:15Z
last_seen: 2026-10-04T04:56:27Z
sent_at: 2026-10-04T04:56:27Z
---
kriscendobot/minion.town#145 (ci.minion.town self-hosted ephemeral runner): merge-decision summary

State: draft. Head 31577bd. The gauntlet stopped at its review budget (6 rounds). CI is green on 31577bd: all 3 checks passed, and they ran on the self-hosted runner ci-minion-town-0fdb85b6-*.

Panel coverage: the latest head has NONE. Round 6 reviewed a3c861f. 31577bd answered it, and its main change is a rewrite of the scrub (controller +82/-28): a once-per-boot snapshot keyed by inode, type, mode and owner, plus cgroup-mount checks for systemd-private dirs. No panel has read that rewrite. It is also undeployed: the live host still runs the older controller, so the green CI does not exercise the new scrub. The rewrite has only been tested in a sandbox with a non-root stand-in for root.

Open objections after round 6. The fix-6 report says 31577bd addressed all of round 6's must-fix and should-fix items: root-ownership trust in the scrub, typist's bare Function type, the integrator's secrets-table row, the scribe summary, and the comment corrections. What remains:
- Any defect in the unreviewed snapshot scrub. FOLLOW-UP-WORTHY, not blocking. It is the third design of this mechanism in three rounds, and the doc already says a malicious job (docker means root-equivalent) can outlive the scrub anyway, through /opt/actions-runner tampering or IMDS → off-host runner. So the scrub is hygiene against non-malicious residue, not a security boundary. Running the selftest after the rollout covers it.
- migrator: no automated fallback to hosted runners when the single host is down; only manual CI_RUNS_ON. FOLLOW-UP-WORTHY. The doc now tells people to check the host first.
- saboteur: a small race between isPrivate and the jitconfig mint. TASTE/NOISE. Exploiting it needs repo-admin, the same tier that controls the allowlist.
- archivist: missing JSDoc on the exported minter helpers. TASTE.
- fast-checker: property tests. TASTE. Every branch is already covered by examples.
- spec-keeper, duality-auditor, coverage-auditor (no c8 for a node --test Lambda), releaser, warden: NOISE. Nothing applies to this repo.

SECURITY POSTURE (the main thing to act on, and it is not in the diff):
- The live secret minion/ci-runner-github-token is STILL the kriscendobot gh OAuth token, with scopes repo, workflow, gist and read:org. The build report flagged this on 9/30. Secrets Manager shows the secret was created and last changed 2026-09-30T19:46Z, so it has never been rotated, and it was last read 2026-10-04.
- That token can read and write every repo kriscendobot can reach, not just minion.town. Only the minter Lambda can read it, and the host never holds it. But a stolen Lambda role, or any bug in the minter, gets the bot's whole GitHub reach.
- The doc's target is a fine-grained PAT with Administration: write on minion.town only. That is GitHub's minimum for repo-level runners on a user-owned repo, and still broad: it also covers repo settings and visibility. The minter re-checks that the repo is private on every mint and every prune.
- Only a person can create that PAT. Rotate with:
  printf '{"token":"%s"}' "$NEW" | deploy/aws/ci-runner/provision-ci-runner.sh --seed-token-stdin
- Inherent residual risk, documented: jobs are root on the host, and a malicious job can persist or exfiltrate the instance role and mint a rogue runner. This is acceptable only because the repo is private (verified PRIVATE today) and the host is isolated. Never make the repo public while this runner is attached.

Bottom line: MERGE AFTER NAMED SMALL STEPS. The code needs no more fixes, and another gauntlet would most likely churn on scrub taste. Before or with the merge:
(1) Rotate the token to the fine-grained PAT. This is your act.
(2) Roll out in this order: provision-ci-runner.sh (minter first), then deploy-ci-runner-host.sh, then reboot, then run the ci-runner selftest. That validates the unreviewed scrub on the real host.
(3) Squash-merge, as the PR body asks.
If you want the new scrub reviewed by a panel before merging instead, that would be a single panel pass on 31577bd, not a seventh fix loop.
