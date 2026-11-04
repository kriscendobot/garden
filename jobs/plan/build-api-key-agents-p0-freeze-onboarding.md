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

# Build: freeze new Claude-subscription onboarding (course-correction step 1)

Governing designs (approved by kriskowal, review https://github.com/endojs/endo-but-for-bots/pull/1543#pullrequestreview-5761476590, "Please conduct the design and build the implementation"): `designs/api-key-inference-providers-and-pinned-agents.md` (companion) and `designs/claude-bare-course-correction.md` (parent) on endojs/endo-but-for-bots `llm` once PR #1543 merges (job endojs-endo-but-for-bots-pr1543-conduct); until then read them from branch `design/claude-api-key-agents`. Use the design's § Ownership map to place each piece in endojs/endo-but-for-bots (base `llm`) or kriscendobot/minion.town (base `main`); one DRAFT PR per repo touched, each linking #1543.

Scope: parent § Independently shippable sequence step 1: `legacyClaudeSubscription` flag (default-on only for existing production), deprecation marking of `/account/claude` and Claude-agent creation, and the probe that fails if the pinned binary's `--bare` help changes its credential list. Do not remove a running responder.

Everything ships behind the disabled `apiKeyGuestAgents` feature flag (parent § Independently shippable sequence, steps 2-3); the legacy subscription path stays working as rollback. Implement exactly this phase and its listed tests; do not start later phases. Do not decide the parent design's § Open questions (Agent SDK retention, legacy migration window, bulk delegation attachment, garden inference sourcing, deprecation interval) — if this phase cannot proceed without one, stop and message the maintainer. Run CI-equivalent lint/type/test checks locally before pushing.

