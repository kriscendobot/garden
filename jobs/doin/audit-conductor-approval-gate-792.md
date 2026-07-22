---
role: fixer
---
# Audit + tighten the conductor merge gate: PRs must not merge without a maintainer approval

Garden-infra (`main2`) change — no PR (garden convention). Work in an ISOLATED worktree off
`origin/main2` per `roles/COMMON.md` § Per-subagent worktrees (`git worktree add --detach
"$(scratch_dir infra-approval-gate)" origin/main2`; explicit-pathspec commit; push `HEAD:main2`
via a rebase CAS loop). Editing the deployed root tree directly is a defect (COMMON.md:213).

Maintainer @kriskowal directive (2026-07-22, via the liaison), prompted by
endojs/endo-but-for-bots#792 ("feat(daemon): serve content through HTTP web seeds"), which
**merged by the bot on 2026-07-18 with ZERO reviews present** — kriskowal's only review landed
4 days AFTER the merge. A conductor merged a feature PR with no maintainer approval. Fix the
class, not just the instance.

## Part 1 — root-cause (evidence first, no guessing)

- Read the #792 merge trail on `journal2`: `jobs/tada/merge-endo-but-for-bots-pr792-http-web-seed.md`,
  `…-restored.md`, `gauntlet-endo-but-for-bots-pr792-http-web-seed.md`, and the shepherd tada. Determine
  exactly what posted the merge job and what precondition it checked.
- Trace the "ready to land → merge" path in code: who POSTS a `merge`/conduct job (the triager's
  ready-to-land criterion — does it require `reviewDecision == APPROVED`?), the conductor role's merge
  preconditions (`roles/conductor/AGENT.md` — it gates CI-green + `mergeable`, and appears to defer
  "missing reviews" to GitHub `mergeable=BLOCKED` / branch protection), and the deterministic spine
  `scripts/jobs/gardening/ci-wait-merge.sh` + `scripts/jobs/handlers/pr-mergeable-gh.sh` +
  comment-watcher's APPROVAL→finalization path. State the CONFIRMED root cause: most likely the merge
  path has **no independent approval check** and relies on branch protection that `endo-but-for-bots`
  does not enforce (see the prior "missed minion.town approvals" scar in
  `scripts/jobs/fork-watch-provisioner.sh`). Confirm or correct this against the evidence.

## Part 2 — tighten the gate (deterministic, independent of GitHub branch protection)

Add a **deterministic maintainer-approval precondition** to the merge path so a conduct/merge CANNOT
land a PR without a current maintainer approval — regardless of whether the repo has branch protection:

- Before merging, verify `reviewDecision == APPROVED` AND at least one **APPROVED** review by a
  maintainer (the journal `maintainers/allowlist` — the same trust source the issue-inbox gate uses;
  fall back to a documented owner set if that is empty) that is **not stale** (dismissed/superseded by a
  newer commit → not valid). If absent, the conductor **stalls** with a clear reason
  (`merge blocked: no maintainer approval`) rather than merging — mirroring the existing
  `merge blocked` / `ci red: needs shepherd` stalls. Encode it in the deterministic spine
  (`ci-wait-merge.sh` / a shared precondition helper) so it holds even when a conductor drives states by
  hand, and reflect the rule in `roles/conductor/AGENT.md` operating norms.
- Also gate the UPSTREAM side: whatever POSTS the merge job (the triager's "ready to land") must not
  post it until an approval is present, so we don't spin conduct jobs that will only stall.
- **Surface, don't silently break, any legitimate auto-merge lane.** If some garden automation
  intentionally merges bot chore PRs without human review, enumerate those lanes in your report and
  either exempt them explicitly (documented, narrow) or flag them for the maintainer — default is
  approval-required. Do NOT invent a blanket bypass.

## Constraints / done

- Keep green: shellcheck-clean; add a unit test for the new precondition (mock `gh` review/reviewDecision
  responses: no-review → refuse; stale/dismissed → refuse; maintainer APPROVED → allow;
  non-maintainer APPROVED → refuse). Run existing gardening/merge tests.
- CI-parity discipline (standing policy): run the CI-equivalent checks locally before pushing.
- ACTIVATION: takes effect fleet-wide only after the next deliberate deploy of `main2` to each root
  (leader-supervised) — note this in your report so the leader-side liaison batches the deploy.
- Report: the confirmed #792 root cause with evidence, the exact files/functions changed, the test
  output, and any auto-merge lanes you exempted or flagged.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  worker_kind: cleric
  claimed_at: 2026-07-22T06:13:59Z
