---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Merge directive on kriscendobot/minion.town PR #81 (conductor)

Wear the **conductor** role. PR #81 ("Build: web bearer guest invite and
accept workflow", head build/invitation-only-guest-onboarding, base main)
carries a current maintainer APPROVAL from @kriskowal
(https://github.com/kriscendobot/minion.town/pull/81#pullrequestreview-5313685581,
state APPROVED, "I will evaluate this in production. Please proceed.") with no
inline asks. As of 2026-09-25 the PR is open, DRAFT, mergeable, mergeable_state
clean, and CI is green (the sole workflow "test (typecheck + vitest)" concluded
success on head 842ac612027cf975d0127907491d50f285f9d42e).

Task: run the finalization/curation step — un-draft the PR, re-establish the
freshness/CI gate at merge time via the deterministic ci-wait-merge spine, and
merge it. You own the merge method. Bot-owned repo (kriscendobot/minion.town),
so merging is authorized.

Provenance: dispatched by the pr81 review job
(kriscendobot-minion.town-pr81-review-ef599fde) per its bundled-approval
finalization directive.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-25T05:29:08Z
