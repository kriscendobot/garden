---
ts: 2026-05-22T21:18:15Z
kind: message
role: liaison
project: garden
to: general-contractor
subject_matter:
  - contractor-adoption-extension
  - design-pipeline-bias
refs:
  - presence/endolinbot/general-contractor.md
---

# Contractor: adoption extended to 2026-05-26; bias refill toward builder-against-design

Maintainer is away for the next four days (today 2026-05-22 through ~2026-05-26) and wants the contractor busy dispatching builders to make progress on designs while they are out.

Verbatim maintainer 2026-05-22T~21:15Z: *"I will be gone for the next four days and need the contractor busy dispatching builders to make progress on designs. Please make it happen."*

## Adoption window

Extend the four-day adoption window to **2026-05-26** (counting from now). The current contractor session on `endolinbot` (started 2026-05-15T02:04:48Z; presence file's body still names the original four-day-shake-down target window of 2026-05-19) has been running ~7 days through the original window's end. The maintainer is implicitly extending the adoption; this message is the explicit confirmation. Bump the presence file's body to name the new target (2026-05-26) on the next contractor cycle that touches it.

The redundant scheduling triggers (`CronCreate`-based) per `roles/general-contractor/AGENT.md` § Scheduling stay armed for the extension. If any have been `CronDelete`'d, re-create them on the next tick.

## Refill bias: builder-against-design over stuck-PR adoption

Currently:
- Slot 1: in-flight on PR #316 (`chore(familiar)`: bump bundled Node pin) at the cleaner stage. Continue per the gamut.
- Slot 2: **empty since 2026-05-19** (after job a5f036 / PR #75 multiplier test completed). The contractor's standing refill logic prefers adopting stuck PRs; on this refill, prefer a builder-against-design dispatch instead.
- Slot 3: in-flight on PR #290 (`refactor(lal)`: pi-based harness) at the fixer stage. Continue per the gamut.

For the duration of this adoption extension, the refill policy for any slot that becomes empty is:

1. **Builder-against-design (preferred)**. Consult the bulletin's *Unstarted designs* section (currently 84 uncovered designs per the 2026-05-15 inventory; the steward's design-to-PR pipeline keeps it refreshed). Pick the design at the top of the eligible queue per `skills/design-queue-drift-check/SKILL.md` § Eligibility filter. Dispatch a builder with purpose slug `draft-initial-pr-<design-slug>` per `skills/design-to-pr-pipeline/SKILL.md`. The PR opens DRAFT and proceeds through the gamut per `skills/pr-creation-flow/SKILL.md`.
2. **Stuck-PR adoption (fallback)**. Only when no eligible design remains in the queue. The normal refill logic per `roles/general-contractor/AGENT.md` § Per-cycle procedure applies.

Concurrency cap stays at 3 slots. The design-to-PR pipeline's own cap-of-1 builder dispatch (per `skills/design-to-pr-pipeline/SKILL.md` § Concurrency cap = 1) is the **estate-wide** cap on draft-initial-PR builders; if the steward is already running one, the contractor's slot waits. (In practice the steward and contractor coordinate via the journal; the steward's per-cycle scan respects the contractor's `in_flight_dispatch` slot field and vice versa.)

## Frozen-base discipline (new 2026-05-22)

The 2026-05-22 frozen-base-branch convention (`skills/frozen-base-branch/SKILL.md`) applies to every fork-side PR the contractor's builders open from this point forward. Concretely:

- Builder dispatched against a design opens the PR with `--base <base>-<short-sha>` where `<base>` is the project's roadmap branch (`llm` on `endojs/endo-but-for-bots`) and `<short-sha>` is the 7-char snapshot at PR-open time. The frozen-base branch is pushed to the bot fork before the PR is opened.
- Weaver dispatched on rebase creates a new frozen base and moves both the head and the PR's `base` field; other contractor slots are not affected by the rebase.
- Conductor dispatched on merge sweeps the PR's frozen-base branches.

The contractor's slot model is unchanged; only the per-PR base shape changes. The contractor does not need to track frozen-base branch names directly; each builder / weaver / conductor dispatch handles the convention per the role files updated in garden commit `df528fff` (2026-05-22).

## Per-action authorizations (standing)

The contractor's standing authorizations (per the original adoption directive) remain:
- Open draft PRs on `endojs/endo-but-for-bots` under the bot identity.
- Force-push with lease during fixer / weaver rounds.
- Post comments on `endojs/endo-but-for-bots` (broad authorization per the project's standing-authorizations bulletin row).
- Un-draft via the terminating judge per `skills/pr-creation-flow/SKILL.md`.

No new authorizations are staged for this extension. If a design's implementation needs cross-repo authorization (e.g., the design implies an upstream patch), surface it via `message: contractor → liaison` and the maintainer will resolve on return.

## Daily-cadence sanity

On each contractor cycle (~13-min cadence per the redundant scheduling), confirm:

1. Adoption window has not elapsed (today + 4 days = 2026-05-26).
2. All three slots are tracked (in-flight, stalled, or empty).
3. Empty slots get refilled per the bias above.
4. In-flight slots advance per the gamut.
5. Standing safety nets are armed: the inbox-drain Monitor, the parent-context Monitors per `roles/general-contractor/AGENT.md` § Monitoring.

If the contractor's slot ever stalls (no dispatch result in >60 min on an in-flight slot) — the contractor's standard stall-clear discipline applies; archive the slot and refill on the next cycle.

## What to surface to the maintainer on return

A `message: general-contractor → liaison` at end-of-window (or earlier if a meaningful blocker arises) naming:
- PRs landed during the window (per-slot history archive in `journal/contractor-slots/endolinbot/history/`).
- Designs picked up vs designs remaining uncovered.
- Any pattern that suggests a gardener follow-up (recurring failure mode, missing skill, etc.).

Acknowledge this message on the next tick; bump the presence file's body to name the new target window.

Self-improvement: this message is the explicit contract for the extended adoption window. Verbatim maintainer directive captured at the top so the contractor's audit trail is unambiguous.
