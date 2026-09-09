---
tier: mentat
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-09T19:51:07Z cleared=none -->

---
tier: mentat
dispatch: manual
---
Review the just-landed design from `design-proportional-worker-leveling`
(read its `jobs/tada/design-proportional-worker-leveling.md` completion report
and the `designs/*.md` doc it produced) before it goes to build.

This is a deliberate, careful capability-tier review — you are Fable 5,
dispatched specifically because this design changes real, already-audited
fleet-leveling infrastructure (`scripts/jobs/budget-level.sh`), which has had
one real provenance bug fixed in it already this week (2026-09-04).

Check specifically:

1. **Does the proportional formula actually compose with the existing
   confirm-before-move dwell logic**, or does it silently replace/bypass a
   safeguard that exists for a real reason (a memoryless controller that jumps
   the full range in one tick, against a sensor that can be stale, thrashes at
   band boundaries — see `cybernetics-audit.md` § 5.1 recommendation 3, cited
   in `budget-level.sh`'s own header)?
2. **Is the cleric (shared codex account) split rule genuinely different from
   the monk rule**, or did the design quietly force-fit a proportional-to-cap
   idea onto a pool that has no per-host cap to be proportional to?
3. **Does it correctly interact with (not silently ignore) `designs/
   session-budget-pace.md`** — the still-unimplemented min(weekly, session)
   design touching the same controller?
4. **Does it preserve every existing safety property**: the provenance gate
   (never actuate on an uncalibrated cap), the fleet-drain skip, and fail-safe
   behavior on a missing/corrupt calibration.
5. **Is the formula concrete and testable**, or does it hand-wave the actual
   numbers a builder would need to implement it correctly?

If the design holds up: say so plainly, note any small corrections inline
(typos, ambiguous wording, a missing edge case worth flagging for the builder),
and let it proceed — don't manufacture objections for their own sake.

If you find a REAL blocking problem — the proportional rule would remove a
safety property, the cleric rule doesn't actually fit the shared-account
reality, or the interaction with `session-budget-pace.md` is genuinely
unresolved — do NOT let it proceed to build silently. Instead:
- Amend the design doc directly with the correction if it's a contained fix
  you're confident in, OR
- If it needs the maintainer's judgment (a real tradeoff, not just a
  correction), send a message to the maintainer inbox explaining the specific
  blocking concern (`scripts/jobs/inbox-send.sh maintainer <body-file>`) and
  say so plainly in your own completion report — the downstream build job
  will still be promoted per the standing chain, so make sure your report (or
  the design doc itself) makes the blocking concern impossible to miss.

Write your verdict plainly in your completion report: approved as-is, approved
with the corrections you made, or blocked pending the maintainer's call (and
what on).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-09T19:51:23Z
