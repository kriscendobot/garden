---
ts: 2026-05-13T05:45:23Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/13/053822Z-dispatch-liaison-44e029.md
---

# Result: gardener restricted standing monitors to endo-but-for-bots only (safety)

Landed the maintainer's safety constraint as documented standing state. The active monitor set is now two daemons: `endo-but-for-bots` (30s) and `review-queue` (120s); the other four (endo, agoric-sdk, cosgov, garden) are dormant.

## Garden (main) commits, single push

- `a1a2cb5` — steward + monitor: restrict standing monitors to endo-but-for-bots only. Shrinks `roles/steward/AGENT.md` § Standing monitors from six rows to two, drops the asymmetric `garden`-row footnote and the `liaison`-subagent dispatch carve-out from the per-cycle and event-consumption prose, and rewrites `roles/monitor/AGENT.md` § Per-project skills into active + dormant lists.
- `6456361` — safety: only repos gated against untrusted contributors may be monitored. Adds a § Monitoring safety constraint section to `CLAUDE.md` (immediately before § Current inventory) and a parallel section to `roles/COMMON.md` (immediately before § External-repo etiquette). Both frame the rule as a standing constraint, not a one-time decision: re-enabling another monitor requires explicit maintainer authorization recorded in a journal `message` entry.
- `acae41d` — monitor-{endo,agoric-sdk,cosgov,garden}: DORMANT banner per safety constraint. Each of the four dormant skill files now opens with a blockquote DORMANT banner citing the constraint, the precipitating dispatch (`entries/2026/05/13/053822Z-dispatch-liaison-44e029.md`), and the re-arm procedure. The reaction-rule bodies (allowlists, posture statements, per-class reactions, dispatch role asymmetry for `monitor-garden`) are preserved verbatim for the record.

Pushed as one batch: `e8f4dd1..acae41d` on `main`.

## Journal commits, separate pushes

- `2a558b8` — worktrees: collect endo, agoric-sdk, cosgov, garden standing-monitor index entries (safety). Flips each of the four `journal/worktrees/endolinbot/watch-{endo,agoric-sdk,cosgov,garden}--monitor--*.md` files from `status: active` to `status: collected`, adds `collected_at: 2026-05-13T05:38:22Z` to the frontmatter, appends a body note citing the safety constraint and the re-arm procedure. Updates `journal/worktrees/README.md` § Current entries to match. The filesystem worktrees on disk at `/home/kris/worktrees/{endojs-endo, agoric-agoric-sdk, dcfoundation-cosmos-proposal-builder, kriskowal-garden}/...` were intentionally **not** removed; polling state under `.garden-monitor/` is preserved in case the constraint reverses.
- `bb96a75` — bulletin: shrink active worktrees / open monitors to the single-monitor active set. Updates `journal/README.md` § *Active worktrees* and § *Open monitors* to reflect the now-shorter active set and adds a one-sentence pointer to the safety constraint.

## Safety note shape

The note lives in two places, cross-linked. `CLAUDE.md` § Monitoring safety constraint (between § Host environment and § Current inventory) carries the orchestrator-framed version; `roles/COMMON.md` § Monitoring safety constraint (immediately before § External-repo etiquette) carries the subagent-facing version. Both say: standing-monitor daemons feed event bodies, comment text, and PR descriptions into the LLM's context on every wake; only repositories whose comments and pull requests are gated against untrusted contributors are safe to monitor; as of 2026-05-13 only `endojs/endo-but-for-bots` meets that bar (and the review-queue daemon is safe by construction because it polls trusted GitHub state); re-enabling another monitor requires explicit maintainer authorization recorded in a journal `message` entry. Phrased as a standing constraint, not a one-time decision.

## Dormant skills

Each of `skills/monitor-{endo,agoric-sdk,cosgov,garden}/SKILL.md` keeps its full reaction-rule body intact and gains a single DORMANT banner at the top. The bodies that survived:

- `monitor-endo`: the four-mode active-participation rules (silent / terse-tick / surface-bulletin / escalate-message), the boatman head-SHA heuristic, and the fixer-push-timing window are all preserved.
- `monitor-agoric-sdk`: the passive-standing-watch single-rule posture (tick and stop, no per-class table) is preserved alongside the explicit upgrade trigger (first active engagement).
- `monitor-cosgov`: the allowlist of expected actors (`kriskowal`, `netlify[bot]`, `Copilot`, `kriscendobot`), the observation-only posture, and the `ReleaseEvent` bulletin exception are preserved.
- `monitor-garden`: the issue-loud / non-issue-silent routing and the `liaison`-not-`monitor` dispatch asymmetry rationale are preserved.

## Bulletin shape

`journal/README.md` § *Active worktrees* now reads "1 active standing monitor (`watch-endo-but-for-bots`)" with a one-clause note that the other four were collected on 2026-05-13 per the safety constraint, their index entries kept for the record, and their filesystem worktrees left on disk. § *Open monitors* now reads "2 long-lived poll daemons (`endo-but-for-bots` 30s, `review-queue` 120s)" with the same safety-constraint pointer.

Self-improvement: nothing this time. The dispatch was a documentation-only sweep with a clear scope; no recurring pattern emerged that would warrant a new rule.
