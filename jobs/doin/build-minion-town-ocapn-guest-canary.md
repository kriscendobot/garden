---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the minion.town OCapN guest canary (design #191 Section 6)

Repo: kriscendobot/minion.town (base `main`). Arc: https://github.com/kriscendobot/garden/issues/89.

The maintainer directed (review comment on https://github.com/kriscendobot/minion.town/pull/191,
2026-10-15T20:05Z, kriskowal) that the canary *start* with OCapN validation: capture a guest
formula identifier and use the Endo CLI to interact with minion.town guests, including passing
messages and capabilities between several guests, one operated by a Claude session. The design
was revised accordingly at `90db939c`; build its Section 6 ("The OCapN canary, first"), reusing
the runbook in `designs/remote-guest-endo-cli.md` Section 7.

Deliver, as a DRAFT PR:
1. A deterministic JavaScript canary (no shell-script logic; the #186 panel converted its scripts to
   JS for the same reason) that, on the canary host, starts a local Endo daemon, ensures its OCapN
   transport, connects to minion.town over OCapN-CBOR-Noise as each held guest (formula identifiers
   read from the host-local file of design Section 4, never committed), sends a message guest A -> B
   and B -> A and confirms inbox arrival, passes a capability each way and confirms the recipient can
   adopt and exercise it, and writes a token-free audit result per the accepted failure contract.
2. A scheduled runner (unit/timer or CI job, whichever the design's Section 4 host model prescribes) so
   the validation runs automatically, and a fixture/offline test of the result classification.
3. The Claude-operated guest leg may be a follow-up step if it needs a live Claude credential; say so
   in the PR body rather than faking it.

The one interactive step (a sign-in to reveal an existing guest's formula id via
`GET /account/guest-formula-id`, or an invitation acceptance) is out of scope for the build; document it
and make the canary report `not-provisioned` cleanly until the ids exist. Root-only checks are out of
scope (Section 6 "What it does not cover yet").

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T01:37:22Z
