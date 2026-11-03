**Viability: proceed.** PR #234 is open and hasn't been superseded. The need behind it still holds: the prod probe has no invitation check today, and nothing else on the base or in another PR adds one.

Deciding question: Does current `main` already have a local-invitation round-trip check in the prod probe, or the guest routes for forgetting a contact and dismissing mail, from this PR or any other?

Evidence:
- **PR state:** open and still a draft, created 2026-11-03T09:22Z. The head is `e16bdcc4` on `probe/invitation-roundtrip`, and the base is the frozen branch `main-c5c3504`. It has no reviews or comments yet.
- **Base history:** `main` is still at `c5c35044` (2026-11-02), the same commit the PR's base was frozen from. No newer commits could have displaced it.
- **Probe on `main`:** `deploy/probe/prod-objectives.mjs` has no invitation or dismiss logic, so the gap this PR fills still exists. That gap is invitation onboarding (#81, merged), tracked in kriscendobot/garden#58.
- **Router on `main`:** `src/web/guest-web-router.ts` has only `DELETE /api/guest` (account deletion). It has no `DELETE /api/guest/contacts/:petName` and no `POST /api/guest/mail/dismiss-all`. That is the premise the PR's server change rests on, and it still holds.
- **Other PRs:** searching for "invitation probe" across all states turned up no competing implementation. The related PRs complement this one rather than replace it:
  - #193 (OCapN canary) and #195 (bearer scrub) are merged.
  - #199 (default-off coupon admission) is open. It is the "coupon flip" this PR prepares for by using standing guests.

Nothing changed in the garden repo or the project repo; this stage only read the PR, the base, and the PR list.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr234-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (182506 cached reads)
- Output: 1439 tokens
- Cost: $0.4366572
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
