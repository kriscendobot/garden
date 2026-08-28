Job complete. Summary report follows.

---

## Completion report — remove the exact-current-head approval guard

**What I did.** Removed the garden's exact-current-head approval freshness guard with prejudice, per kriskowal's approved review on endojs/endo-but-for-bots#889. A still-effective trusted-maintainer `APPROVED` review now authorizes a PR even after its head moves or is rebased; the merge authority no longer requires the review's `commit_id` to equal the current `headRefOid`.

**Core semantic change.** `scripts/jobs/handlers/pr-maintainer-approval-gh.sh` — the single authority both `ci-wait-merge.sh` (merge spine) and `approval-reconciler.sh`/`pr-mergeable-gh.sh` delegate to — was rewritten to compute each maintainer's **effective (latest) review state** and authorize when a maintainer's effective state is `APPROVED` and no maintainer's is `CHANGES_REQUESTED`. GitHub dismissal (`state: DISMISSED`), a later `CHANGES_REQUESTED` (hard veto, even across maintainers), and untrusted approvers still refuse. `COMMENTED`/`PENDING` reviews are ignored so they can't mask a standing approval.

**Preserved unchanged:** trusted-maintainer requirement, the `reviewDecision` CHANGES_REQUESTED/REVIEW_REQUIRED veto, CI-green requirement, the CI-freshness binding of green to the post-rebase head in `ci-wait-merge.sh` (a separate gate keyed off `headRefOid` for CI, not approval), live-base rebasing, and all other conductor gates.

**Files changed (12):**
- Executable: `pr-maintainer-approval-gh.sh` (logic), `pr-mergeable-gh.sh` + `approval-reconciler.sh` (comments/job-body prose/log labels; both only delegate).
- Tests: `pr-maintainer-approval-gh-test.sh` (19 cases incl. earlier-head-authorizes, dismissal, changes-requested-supersedes, re-approval, COMMENTED-doesn't-mask, cross-maintainer veto), `ci-wait-merge-test.sh` (T21 inverted → pre-rebase approval merges; new T21b → dismissal on pre-rebase head still blocks), `approval-reconciler-test.sh` (case B relabeled).
- Instructions: `roles/conductor/AGENT.md`, `roles/liaison/AGENT.md`.
- Designs: `conductor-rebase-before-merge.md` (dated amendment + revised claims), `gardening-state-machine.md`, `approval-reconciler.md`, `post-verdict-addressee.md`.

**Verification (all green):** pr-maintainer-approval 19/0, ci-wait-merge 56/0, approval-reconciler 15/0; `bash -n` clean on all modified scripts; `shellcheck -S warning` clean (only the pre-existing `GARDEN_TAG` SC2034); double-space and claude-md-inventory-drift checks rc 0.

**Landed & reported.** Committed as `068564273c22ad358cd82a1db2f51cd723db7795`, pushed to `origin/main2` on the first CAS attempt. Posted the top-level completion summary on PR #889 (issue-comment 5455890230) citing the SHA, semantic change, and commands run. Did **not** merge the PR — the serial orchestration `endojs-endo-but-for-bots-pr889-approval-guard-removal` owns final conduct.

**Follow-up (unrelated, pre-existing).** The `tests/checks/run.sh` suite has one failing gate — `maintainer-inbox-information-hiding` flags `roles/scholar/AGENT.md` as an off-allowlist maintainer-inbox reference (introduced 2026-08-14 by commit 56039f63d6, untouched by this job). It is red at the base commit independent of my diff; worth a separate fix to add scholar to the gate's allowlist.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-current-head-approval-guard-remove-5053510672.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 198 tokens (12810103 cached reads)
- Output: 59031 tokens
- Cost: $9.4417425
- Wall-clock: 928s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
