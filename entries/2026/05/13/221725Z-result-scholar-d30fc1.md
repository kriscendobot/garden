---
ts: 2026-05-13T22:17:25Z
kind: result
role: scholar
refs:
  - entries/2026/05/13/220754Z-message-liaison-98bd2c.md
  - entries/2026/05/13/220755Z-message-liaison-90b5c1.md
  - entries/2026/05/13/220756Z-message-liaison-c2775e.md
  - entries/2026/05/13/220757Z-message-liaison-7307f1.md
  - entries/2026/05/13/220758Z-message-liaison-6b3769.md
  - entries/2026/05/13/220759Z-message-liaison-34c05e.md
---

# First scholar cycle — library ingestion path verification

Cycle dispatch root: `dispatches/scholar--first-library-cycle--20260513-220911--75cfa9`. Run by the in-session liaison adopting the scholar posture (no autonomous bot sandbox), under user direction.

## Inbox drain

Drained 6 `to: scholar` messages with `library_action: ingest-source`, all from liaison at 2026-05-13T22:07.

## Idempotency check

Three messages whose target source was already in `journal/library/sources/`:

| Source | Recorded `source_commit` | Upstream sha | Decision |
|--------|--------------------------|--------------|----------|
| `endo--agents` (AGENTS.md) | `6ea51ece638e` | `6ea51ece638e` | **SKIP (match)** |
| `endo--docs-security` (docs/security.md) | `fe81477bf88b` | `fe81477bf88b` | **SKIP (match)** |
| `endo--docs-errors` (docs/errors.md) | `fe81477bf88b` | `fe81477bf88b` | **SKIP (match)** |

All three matched correctly and were skipped without writing any section file. The idempotency mechanism (compare recorded file-specific sha to upstream's current file-specific sha) works as designed.

## New-source ingest

| Source | Decision | Sections | Notes |
|--------|----------|----------|-------|
| `endo--docs-lockdown` (docs/lockdown.md) | **INGEST** | 15 | Cycle's primary work. |
| `endo--docs-get-started` (docs/get-started.md) | **DEFER** | 0 | Section budget consumed by lockdown; re-queued for next cycle (entries/.../221723Z-message-scholar-6eb9ae.md). |
| `endo--pkg-ses-readme` (packages/ses/README.md) | **DEFER** | 0 | Same reason; re-queued (entries/.../221724Z-message-scholar-434e94.md). |

15 section files written under `journal/library/sections/endo--docs-lockdown--*.md`. One source-index file at `journal/library/sources/endo--docs-lockdown.md`. Topic updates: `hardened-javascript` (+15 rows, now 20 total), `errors` (+6 rows, now 13 total), `compartments` (+1 row, now 3 total), `eventual-send` (+1 row, now 2 total). Master indexes (`sources/README.md`, `topics/README.md`, `sections/README.md`) updated to match.

## Two bugs found and addressed mid-cycle

**Bug 1: `source_commit` semantics ambiguous in `conventions.md`.** The pilot batch recorded `source_commit: <repo HEAD sha>` rather than `<file-specific sha>` (`git log -1 --format=%H <branch> -- <path>`). The idempotency check needs file-specific shas to behave correctly because the repo HEAD moves with every commit (causing every cycle to see a mismatch and re-ingest unnecessarily). Fix: clarified `journal/library/conventions.md` to require the file-specific commit, and retrofitted the 19 pilot files (3 source-indexes + 16 section files) via in-place `sed` substitution to use the correct file-specific commits. Idempotency then worked correctly. The fix is in the same commit as this result.

**Bug 2: `inbox-drain.sh` path computation breaks under a dispatch root.** The script computes `GARDEN_ROOT` from its own location (`<dispatch-root>/garden/`) and then assumes `$GARDEN_ROOT/journal/` is the journal worktree. In a dispatch root, the journal is `<dispatch-root>/journal/`, a sibling of `garden/`, not under it. So the script creates a state file under `<dispatch-root>/garden/journal/inboxes/<host>/<role>.md` and uses `git -C` against the garden's git directory (returning the garden's HEAD as `CUR_HEAD`, not the journal's). This is inconsequential for the orchestrator's standing usage (which the script was originally designed for) but breaks every subagent that calls it from a dispatch root. Workaround for this cycle: drained manually with `grep -l '^to: scholar$' journal/entries/2026/05/13/*.md`. Authored a correct `journal/inboxes/endolin/scholar.md` state file by hand with `last_drained_commit: f45f792` (the primed-messages commit), so the next scholar cycle drains from the right position. The fix belongs to the gardener: see *Self-improvement* below.

## Cycle inputs / outputs

- **Inputs:** 6 `to: scholar` `ingest-source` messages from liaison at 2026-05-13T22:07.
- **Outputs:**
  - 3 skips (no write).
  - 1 source-index file + 15 section files (lockdown).
  - 4 topic-page updates (hardened-javascript, errors, compartments, eventual-send).
  - 3 master-README updates (sources/, topics/, sections/).
  - 2 re-queue messages (get-started, ses-readme).
  - 1 inbox-state file (`inboxes/endolin/scholar.md`).
  - This result entry.
- **Conventions edit:** 1 in-place clarification of `source_commit` semantics in `journal/library/conventions.md`. 19 pilot files retrofitted to the corrected semantics.

## Next cycle

Two re-queued tasks (`docs/get-started.md`, `packages/ses/README.md`) await in the inbox. Active-mode trigger; idle cadence does not apply. Expected: another scholar cycle picks them up.

## Self-improvement

The two bugs above are both worth flagging as `message` entries to liaison rather than just inline fixes:

1. **conventions clarification** is already applied; future scholars will read the corrected schema. No further action needed.
2. **inbox-drain script path bug** is structural. The script lives at `garden/skills/inbox-drain/inbox-drain.sh` and assumes the orchestrator's directory layout, but it is documented (in `skills/inbox-drain/SKILL.md`) for use by both the orchestrator AND subagents at dispatch time. The fix is to teach the script to detect the dispatch-root case (e.g., look for a sibling `journal/` directory at `<dispatch-root>/journal/` before falling back to `<garden-root>/journal/`). Routing to the gardener via a follow-up `message: liaison` entry; the gardener can land it on `main`.

Self-improvement: `roles/scholar/AGENT.md` § Per-cycle procedure step 4 says "do not advance the inbox-drain pointer past unfinished tasks" but the script tracks commit-level granularity, not message-level, so this contradicts the script's actual capabilities when multiple messages land in one commit. The workaround used this cycle was to re-queue deferred tasks as new messages and advance the pointer to the original-batch commit. Worth a clarification in the role file or a per-message granularity in the inbox-state. Routing this also to the gardener.
