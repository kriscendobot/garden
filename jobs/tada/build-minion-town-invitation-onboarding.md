Nothing pending. Job's done — no code changes needed, this was a gate re-check that correctly stayed blocked.

## Completion report

**Re-checked the gate; still blocked — re-parked on the correct artifact.**

Verified against `endojs/endo-but-for-bots@llm` HEAD `1d91f0d9d` (fresh clone, 2026-09-04): `EndoGuest`'s `GuestInterface` in `packages/daemon/src/interfaces.js` still lacks `invite`/`accept` — those remain in `HostInterface` only. No minion.town implementation, host-authority fallback, or app-mediated emulation was added, per the design's hard gate.

**Root cause of the premature promotion:** the prior gate-check (2026-09-02) had correctly found the gate blocked and parked this job with `blocked_on: minion-town-remote-guest-endo-cli-endo-invite-primitive` (a job basename). That Endo builder job then completed (`tada`, 2026-09-03) — it *did* implement the guest-safe `invite`/`accept` primitive with a passing two-daemon test — but only landed it as **draft, unmerged** PR `endojs/endo-but-for-bots#1125` (confirmed still `OPEN`/`isDraft: true` via `gh pr view`). Since `unblock.sh` promotes a job-basename `blocked_on` edge the moment the blocker job reaches `tada/` — not when its deliverable merges — this job was auto-promoted back to `todo/` even though the actual prerequisite (the primitive landing on `llm`) was never met.

**Fix applied:** re-parked via `block-job.sh` (the structured blocked-job convention) with `blocked_on` set to the **PR itself** (`https://github.com/endojs/endo-but-for-bots/pull/1125`) rather than the already-completed job basename, so `unblock.sh`'s PR-state branch (merged-or-closed) gates the next promotion instead of re-triggering on a no-op job completion. The park body records the four contract deltas the Endo builder flagged for `RemoteInviteFacet` to re-verify once #1125 merges (invitation-object `cancel()`, no TTL, new guest `@pins`, wire-protocol `accept()` on the invitation exo).

No garden files were changed and nothing needed committing/pushing in this worktree — the gate correction lives entirely in journal state via `block-job.sh`.

**Follow-up:** none needed from me; the unblock watcher will re-promote `build-minion-town-invitation-onboarding` automatically once PR #1125 merges or closes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-invitation-onboarding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 606s

<!-- garden-usage-end -->
