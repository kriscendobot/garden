---
gate: orchestrated
orchestrated_by: orchestrate-build-api-key-agents-20261104
priority: normal
posted_by: endojs-endo-but-for-bots-pr1543-review-ed16aaac
posted_at: 2026-11-04T01:48:04Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: provider adapters, accounting, and caps (companion phase 2)

Governing designs (approved by kriskowal, review https://github.com/endojs/endo-but-for-bots/pull/1543#pullrequestreview-5761476590, "Please conduct the design and build the implementation"): `designs/api-key-inference-providers-and-pinned-agents.md` (companion) and `designs/claude-bare-course-correction.md` (parent) on endojs/endo-but-for-bots `llm` once PR #1543 merges (job endojs-endo-but-for-bots-pr1543-conduct); until then read them from branch `design/claude-api-key-agents`. Use the design's § Ownership map to place each piece in endojs/endo-but-for-bots (base `llm`) or kriscendobot/minion.town (base `main`); one DRAFT PR per repo touched, each linking #1543.

Scope: companion § Build and acceptance plan, phase 2 (Anthropic API-key binding via @endo/inference, usage recorder, model catalog with typed-id fallback, default and owner-wide caps, brokered-messages adapter, Fae provider kind, Lal broker-backed streamFn, raw-request refusals, reservation/settlement) with all its listed tests.

Everything ships behind the disabled `apiKeyGuestAgents` feature flag (parent § Independently shippable sequence, steps 2-3); the legacy subscription path stays working as rollback. Implement exactly this phase and its listed tests; do not start later phases. Do not decide the parent design's § Open questions (Agent SDK retention, legacy migration window, bulk delegation attachment, garden inference sourcing, deprecation interval) — if this phase cannot proceed without one, stop and message the maintainer. Run CI-equivalent lint/type/test checks locally before pushing.

