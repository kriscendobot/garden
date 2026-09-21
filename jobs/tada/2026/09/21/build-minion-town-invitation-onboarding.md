---
handed-off: minion-town-invitation-onboarding-build-20260921
deliverable-complete: false
---
Message delivered. Now completing this job with the handoff signal.

## Completion report

**Gate check:** Confirmed open. `endojs/endo-but-for-bots#1310` ("guest-native invitation acceptance `EndoGuest.accept`") merged 2026-09-21T21:36:21Z — 13 minutes before this job was claimed. Verified directly against `llm`: `GuestInterface` (lines 244–349 in `packages/daemon/src/interfaces.js`) now contains both `invite:` (line 345) and `accept:` (line 347).

**What I found:** `kriscendobot/minion.town#81` ("Build: web bearer guest invite and accept workflow", open draft, branch `build/invitation-only-guest-onboarding`) already implements most of `designs/invitation-only-guest-onboarding.md` — fragment-URL envelope, browser shell, DB schema, deployment policy. But its same-daemon guest-pairing path (`connectLocal` in `src/web/guest-web-socket-service.ts`) calls `storeIdentifier` directly on both guests — the exact app-mediated/host-authority fallback the design forbids in §3.1/§3.2, and exactly what this job's spec explicitly warns against reintroducing. It's a deliberate stopgap dated to before `guest.accept` existed. Separately, minion.town's own deployed/tested Endo commit pin (three synchronized copies: `deploy-endo-daemon.sh`, `captp-client.ts`, `.github/workflows/test.yml`) is pinned ~2 months stale, predating #1310, so nothing can even be verified against a real daemon with `accept` until it's refreshed.

**What I did:** This is genuinely two sequential, separately-reviewable pieces of work — a production Endo-pin bump, then the fallback fix — so per the garden's standing multi-part-job orchestration pattern I decomposed rather than attempting a monolithic fix:

- Posted orchestration `minion-town-invitation-onboarding-build-20260921` (serial, halt-on-failure) over:
  1. `minion-town-endo-daemon-pin-refresh-20260921` — refresh minion.town's pinned Endo commit past #1310, verified against a real daemon.
  2. `minion-town-guest-web-invite-accept-fallback-fix-20260921` (blocked on 1) — replace PR #81's `storeIdentifier` fallback with real `guest.invite`/`guest.accept`, rebase, and reconcile against the contract deltas noted in this job's spec (invitation `cancel()`, no TTL, `@pins` namespace, `invitingAgent`/`invitingHandle` field renames).
- Confirmed both children pushed and readable on `journal2` (`jobs/orch/minion-town-invitation-onboarding-build-20260921.md`, `jobs/plan/minion-town-endo-daemon-pin-refresh-20260921.md`, `jobs/plan/minion-town-guest-web-invite-accept-fallback-fix-20260921.md`).
- Messaged the maintainer with this summary via `message-user.sh` (delivered to inbox/maintainer).
- Verified no duplicate PR exists for this job's own marker.

**Follow-ups:** the orchestration will drive itself; no manual promotion needed. Once child 2 lands, `run the gauntlet` on PR #81 is a separate maintainer-triggered step per the manual-gauntlet regime.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-invitation-onboarding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (3 unmetered)
- Input: 172 tokens (7266436 cached reads)
- Output: 66305 tokens
- Cost: $4.365813600000001 (3 engagement(s) unpriced)
- Wall-clock: 1803s

<!-- garden-usage-end -->
