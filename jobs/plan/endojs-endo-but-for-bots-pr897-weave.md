---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 2
deadline_overruns: 1
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-16T21:23:05Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-16T21:23:05Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# weave directive on endojs/endo-but-for-bots PR #897

Map: **weave/rebase** → rebase the PR branch onto a fresh base, resolving
conflicts by honoring both sides (never `--ours`/`--theirs`).

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/897
Head branch: fix/mount-glorp-713-followup
Base branch: llm

Task: PR #897 was APPROVED by kriskowal
(https://github.com/endojs/endo-but-for-bots/pull/897#pullrequestreview-4947210677)
but its head (03d75fd1) is **CONFLICTING** with base `llm`
(`mergeable: false`, `mergeable_state: dirty`): 4 ahead / 274 behind,
diverged. GitHub therefore builds no merge ref and dispatches no CI on new
pushes, so the branch cannot be driven to green until the conflict is resolved.

Rebase `fix/mount-glorp-713-followup` onto current `llm`, resolving all
conflicts, force-push with `--force-with-lease`, and confirm `mergeable`
returns to true so CI re-dispatches. If the rebase reveals the branch's premise
no longer holds (the #713 panel must-fix bundle already landed upstream, or a
conflict needs interpretation beyond mechanical resolution), escalate per the
weaver→fixer/liaison chain rather than force a resolution.

After the rebase lands mergeable and CI green, the PR is ready for a merge job
(it is already approved).

Context: handed off from the shepherd job
endojs-endo-but-for-bots-pr897-shepherd, which found the PR conflicting (a
weaver task per roles/shepherd/AGENT.md "Conflicting PRs block CI dispatch").
The prior CI run also showed a `test (22.x, macos-15)` timeout flake
("Timed out while running tests" in the @endo/agentry eval suite) — after the
rebase re-dispatches CI, treat a recurrence as an operational flake and re-run.
