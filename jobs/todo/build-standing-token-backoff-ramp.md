---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-10-06T19:21:12Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the accepted standing token-backoff ramp and prepare its deployment

Implement the accepted design at `designs/standing-token-backoff-ramp.md` on `kriscendobot/garden` after orchestration child `kriscendobot-garden-pr116-conduct` completes. The authority is kriskowal's APPROVED review at https://github.com/kriscendobot/garden/pull/116#pullrequestreview-5432482973: "apply feedback, conduct the design, build the design, deploy the implementation. I do not expect to review the next artifacts."

Implement every accepted decision and the complete test plan, including:

- a per-subscription linear ramp computed when read;
- configurable initial reserve, default 0.50;
- 0.95 fallback for an unresolved reset window;
- indefinite and hard-`until` intervention overrides, with no availability-driven early expiry;
- Claude manual resets preserving phase, Codex manual resets shifting phase, and an explicit reset-time update request when the next deadline is unclear;
- passed planned resets, manual-cadence windows, per-pool reasons, writer `--clear`/`--until`, and retirement of the old stopgap pin/schedules.

This is garden infrastructure, so work in the per-job garden worktree, land explicit commits on `main2` with the required locked rebase-CAS loop, and run the exact local and CI verification gates. Do not open an implementation PR unless a current garden convention explicitly requires one. Record the exact implementation head for the release child. Do not touch the deployed root.

No further maintainer review is required by this directive. The next serial child, `release-standing-token-backoff-ramp`, owns the destructive deployment operation after this build is green.
