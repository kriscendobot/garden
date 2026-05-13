---
ts: 2026-05-13T05:38:22Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener restricts monitoring to endo-but-for-bots only (safety)

Dispatch root: `dispatches/gardener--restrict-monitoring-safety--20260513-053822--44e029/`.

The maintainer declared a safety constraint: only `endojs/endo-but-for-bots` may be monitored from this host. Other repositories are not configured to deny public comments and pull requests, which could pose a hazard to our context (malicious actors injecting text the LLM-side monitor or steward might read). The four unauthorized daemons (endo, agoric-sdk, cosgov, kriskowal/garden) have already been killed in-session (PIDs 18396, 18398, 18399, 52973); only `endojs/endo-but-for-bots` (PID 18397) and the `review-queue` daemon survive.

Task — turn the in-memory restriction into documented standing state:

1. **`roles/steward/AGENT.md`** § Standing monitors: remove the four rows for endo, agoric-sdk, cosgov, garden. Keep endo-but-for-bots and review-queue. Update the prose paragraph after the table and the liveness-check / event-consumption sections to match the now-shorter active set.

2. **Safety note in CLAUDE.md and `roles/COMMON.md`**: explain why only `endo-but-for-bots` is monitored. Phrase as a standing constraint that the gardener (and any future role-author) must respect: monitoring a repository whose comments and PRs are open to the public exposes the LLM context to untrusted text; only repos with maintainer-only commenting (or equivalent gating) are safe to monitor. `endojs/endo-but-for-bots` is currently the only such repo. Re-enabling another monitor requires explicit maintainer authorization in a journal entry.

3. **Per-project skills**: add a prominent "DORMANT" banner to `skills/monitor-endo/SKILL.md`, `skills/monitor-agoric-sdk/SKILL.md`, `skills/monitor-cosgov/SKILL.md`, and `skills/monitor-garden/SKILL.md`. The banner cites the safety constraint and notes that the skill is preserved for record (in case the constraint changes), not currently active. Do not delete the files.

4. **`roles/monitor/AGENT.md`**: update the *Per-project skills* mapping to mark which slugs are dormant. The active set is now just `endo-but-for-bots`.

5. **Journal worktree index**: update the four standing-monitor entries at `journal/worktrees/endolinbot/watch-{endo,agoric-sdk,cosgov,garden}--monitor--*.md` to `status: collected` with a body note explaining the safety-driven collection date. Do NOT `git worktree remove` the actual filesystem worktrees in this dispatch — keep the polling state on disk in case the constraint reverses; just mark the index entries collected so the steward stops checking liveness for them. Update `journal/worktrees/README.md` § Current entries to reflect the collected status.

6. **`journal/README.md`** § *Active worktrees* and § *Open monitors*: shrink to reflect the single active standing monitor plus review-queue.

Out of scope:

- Do NOT kill the running endo-but-for-bots or review-queue daemons.
- Do NOT delete any per-project skill file or any worktree on disk.
- Do NOT touch the timekeeper / scheduling work (concurrent gardener dispatch handles that).
- Do NOT write the ocapn project entry (separate in-session liaison work).

Report on return: commit SHAs on `main` and `journal`, one-paragraph summary of the safety doc shape (where the prominent note lives, what it says), and confirmation that the dormant skills retain their reaction rules intact for the record.
