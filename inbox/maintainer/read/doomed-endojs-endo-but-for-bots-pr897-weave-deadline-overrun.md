from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-16T21:23:17Z
doom_base: endojs-endo-but-for-bots-pr897-weave
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-16T21:23:17Z
last_seen: 2026-08-16T21:23:17Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden2-5bcdff64.
The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr897-weave; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr897-weave) or removes it.
Original job base: endojs-endo-but-for-bots-pr897-weave

--- original job body ---
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
