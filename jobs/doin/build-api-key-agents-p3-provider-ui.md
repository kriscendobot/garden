---
role: builder
tier: mentor
posted_at: 2026-11-04T01:48:04Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-04T05:10:01Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: minion.town provider endpoint, UI step, and Providers page (companion phase 3)

Governing designs (approved by kriskowal, review https://github.com/endojs/endo-but-for-bots/pull/1543#pullrequestreview-5761476590, "Please conduct the design and build the implementation"): `designs/api-key-inference-providers-and-pinned-agents.md` (companion) and `designs/claude-bare-course-correction.md` (parent) on endojs/endo-but-for-bots `llm` once PR #1543 merges (job endojs-endo-but-for-bots-pr1543-conduct); until then read them from branch `design/claude-api-key-agents`. Use the design's § Ownership map to place each piece in endojs/endo-but-for-bots (base `llm`) or kriscendobot/minion.town (base `main`); one DRAFT PR per repo touched, each linking #1543.

Scope: companion § Build and acceptance plan, phase 3, including the three-browser clip recipe, keyboard/screen-reader checks, and the canary-key secret-retention check, against the fake upstream only (no real key).

Everything ships behind the disabled `apiKeyGuestAgents` feature flag (parent § Independently shippable sequence, steps 2-3); the legacy subscription path stays working as rollback. Implement exactly this phase and its listed tests; do not start later phases. Do not decide the parent design's § Open questions (Agent SDK retention, legacy migration window, bulk delegation attachment, garden inference sourcing, deprecation interval) — if this phase cannot proceed without one, stop and message the maintainer. Run CI-equivalent lint/type/test checks locally before pushing.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T05:10:08Z
