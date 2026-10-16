from_host: oros-studio-garden-ce242c49
from: gardener:minion-town-carry-eight-prs-to-merge-20261016
reply_to: minion-town-carry-eight-prs-to-merge-20261016
msg_key: msg-minion-town-carry-eight-prs-to-merge-20261016-4d1e19a1c2e9
notice_count: 1
first_seen: 2026-10-16T07:20:50Z
last_seen: 2026-10-16T07:21:03Z
sent_at: 2026-10-16T07:21:03Z
---
# carry-eight supervision: status, one policy question, two gated items

Supervisor report for the eight minion.town drafts (job minion-town-carry-eight-prs-to-merge-20261016).

**Done this session.** Classified every terminal gauntlet's residue from the final panel + final fix reports. Each PR's last fix round had already addressed its final panel's must-fix list, so I resumed four gauntlets at the verification panel with a bounded +2 rounds: kriscendobot/minion.town#178 (panel-9), kriscendobot/minion.town#180 (panel-13), kriscendobot/minion.town#188 (panel-7), kriscendobot/minion.town#190 (panel-7). kriscendobot/minion.town#183/kriscendobot/minion.town#186/kriscendobot/minion.town#184 were already carried (screen gauntlet, press sequencing behind kriscendobot/minion.town#193/kriscendobot/minion.town#191, and an in-flight fix-14 respectively); kriscendobot/minion.town#171 is ledger-held.

**Result so far.** All four verification panels returned must-fix again — on NEW nit-class items each time. Exhibit: kriscendobot/minion.town#188 round 6's only must-fix was prose dedup (fixed); round 7's only must-fix is renaming `fetchImpl` to `fetchImplementation`. Fix rounds are queued; each PR has exactly one more budgeted panel round, then they re-terminate at review-budget-reached.

**The policy question (impasse).** The proxy screen merges only on a gauntlet that COMPLETED with a panel pass at the PR head (designs/minion-town-pr-screening.md gate 6). With 34 bias-to-fire seats treating prose/JSDoc accuracy as must-fix, these panels have not converged in 6–13 rounds ($10–28 each) and may structurally never pass. If the final budgeted rounds also return nit-class must-fix, how do you want these landed?

- (a) You review + APPROVE the PRs you accept — a human APPROVED review triggers the ordinary finalize conductor, bypassing the panel-pass gate. (You said no per-PR review, so listed only for completeness.)
- (b) Authorize a narrow policy change — either the panel decider treats prose/JSDoc-accuracy and identifier-spelling findings as should-fix (not must-fix), or the screen accepts a supervisor attestation for a review-budget-reached gauntlet whose residue the supervisor classifies as nit-only.
- (c) Keep granting bounded rounds and accept the spend.

Recommendation: (b), the decider-instruction variant — smallest change, keeps real bugs blocking (e.g. kriscendobot/minion.town#190 round 6 caught two genuine ones, which were fixed).

**Maintainer-gated items (FYI, already carried by the presses).**
- kriscendobot/minion.town#191 re-review gates kriscendobot/minion.town#186 and then kriscendobot/minion.town#183's un-draft: your CHANGES_REQUESTED comment ("overwrought yak shave") was answered by revision `90db939c`; kriscendobot/minion.town#193 (OCapN canary) proceeds first per kriscendobot/minion.town#191 section 6.
- kriscendobot/minion.town#171's merge is ledger-gated on operator provisioning (DEPLOYMENT.md § One-time provisioning: phase 1 IAM, phase 3 role ARN) — an operator step on the credentialed side.

Reply routes to this job's inbox; if the job has completed, the dead-letter promotes your answer to a fresh job, so just reply here.
