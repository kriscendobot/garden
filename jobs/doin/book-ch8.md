---
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T03:47:20Z cleared=none -->

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book, chapter 8: Cybernetics and budgeting

One chapter of a multi-part "book" (orchestration `garden-book-orch`). Write
to `journal/projects/garden-book/ch8-cybernetics-budgeting.md` as Markdown.

## Ground this in real sources

- `context/operations/cybernetics.md` in full — the current operator map for
  budget and feedback controls (subscription accounting and admission,
  `config/budget-pools` / `config/subscription-mapping`, `usage-meter.sh`,
  the calibration/checkpoint tooling).
- `designs/cybernetics-audit.md` and `designs/cybernetics-economic-resilience.md`
  for the rationale behind the current implementation.
- `context/operations/scaling.md` — operator controls for pool sizing.
- `CLAUDE.md` § Capacity and the foreman brake, § Leader and follower hosts
  (the singleton-service gating), and § The sysop (host-directed ops,
  including `set-workers`, `drain`, `restore`, the destructive-op
  attestation requirement).
- `skills/model-selection/SKILL.md` — role-to-tier resolution, the tier
  floor concept, `mentat`/manual dispatch.
- `skills/job-board/SKILL.md` § Per-job handler budget — the handler-timeout
  resolution table, the budget_max cap, and why it's tied to
  `GARDEN_CLAIM_TTL`.
- The recently-posted `design-accountant-role-budget-apportionment` design
  (if it has landed by the time you write this — check
  `designs/` for an accountant-role or budget-apportionment design; if it
  hasn't landed yet, don't invent its conclusions, just note it's in
  progress and describe today's mechanism as it stands).

## What this chapter should cover

1. **Why "cybernetics"**: the garden treats budget as a control surface, not
   just an accounting ledger — spend state feeds back into admission
   (claim-time gating), pacing (the foreman's active target and backoff
   fraction), and worker-count leveling, closing several feedback loops
   rather than one static cap.
2. **Subscription accounting**: pools, host/kind-to-pool mapping, the meter,
   and why a claim pool must be both metered and calibrated or it fails
   closed.
3. **Worker-count leveling and derotation**: how a host's monk/cleric
   worker counts respond to budget state and to heartbeat/liveness signals
   (cite the actual worker-derotate mechanism this session's own muster
   exercised — a host going quiet gets its caps zeroed, and gets them
   restored automatically once its heartbeat resumes).
4. **The foreman as the pacing actuator**: the active-target brake, why the
   shipped default target is what it is, and the token-backoff fraction as
   the spend brake.
5. **Per-job and per-role token/handler budgets**: how a job's `role:`
   resolves to a default handler-timeout and token-budget, the explicit
   override header, and the hard cap tied to claim TTL.
6. **Per-orchestration budgets**: the `--budget-tokens` mechanism as the
   existing precedent for "a bounded pie a scheduler draws down against,"
   including what happens at exhaustion (a clean stop with the parked
   remainder resumable later, never a killed in-flight job).
7. **What's evolving right now**: the accountant-role design (see above) as
   the next layer being built on top of all of this — describe it as
   in-progress work, accurately reflecting whatever state you find, not as
   already-shipped.

<!-- garden-terminal-handler-failure -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T03:48:50Z
