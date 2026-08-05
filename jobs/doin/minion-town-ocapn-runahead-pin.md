---
role: builder
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repositories: https://github.com/endojs/endo-but-for-bots (branch work) and
https://github.com/kriscendobot/minion.town (the consumer).

# Create and GIT-PIN the `minion-town` run-ahead branch for OCapN CBOR/Syrup termination

**MAINTAINER DECISION (kriskowal, 2026-08-05): OPTION (a) — open the run-ahead
branch and consume it via a GIT PIN.** This is the one-comment ack that
`minion-town-weblet-gateway-increment-3` said it was waiting for; it did not open
the branch itself because that was maintainer-gated. Read its `jobs/tada/` report
first.

## Why a run-ahead branch is needed

Design §6 wants each weblet subdomain to terminate a real OCapN session at
`/.well-known/ocapn-cbor` and `/.well-known/ocapn-syrup`, whose bootstrap is the
weblet's granted powers, served CBOR/Syrup.

Faithful termination needs the fork's `llm`-branch `@endo/ocapn` — `makeOcapn` +
locator + `@endo/ocapn-noise` WS transport, the exact API the box's
`demo/minion-town/ocapn-ws-server.mjs` already uses. **That API is unpublished.**
npm's `@endo/ocapn@1.1.1` is a different, client-shaped `makeClient`/`netlayer`/`ws`
surface and cannot satisfy it.

Today those two endpoints in PR kriscendobot/minion.town#24 are **wired seams that
policy-close with 404** — deliberately not faked, which was the right call: a fake
would look like working capability plumbing that is not.

## What to do

1. **Open the `minion-town` branch** on `endojs/endo-but-for-bots`, branched from
   current `llm`. Per milestone kriscendobot/garden#58 this branch exists precisely
   to carry "experimental features, not yet landed on `llm`, for the purposes of
   running ahead of reviews" — so this is its sanctioned use, not a workaround.
2. **Pin it by git ref, provenance-matched to the daemon commit**, following the
   existing `captp-client.ts` pattern in minion.town. Pin a **specific commit sha,
   not a moving branch name** — a floating pin makes the deployed gateway
   irreproducible and would let an unreviewed upstream change reach a live
   5-tenant host silently.
3. **Wire the two endpoints** so `/.well-known/ocapn-cbor` and
   `/.well-known/ocapn-syrup` terminate real OCapN sessions whose bootstrap is the
   weblet powers, and `/.well-known/ocapn-bootstrap` routes the powers identifier
   (design §6). Keep every fail-closed property Increment 3 established: WS upgrade
   refusal, the 426 guard, reserved `/.well-known`, and no weblet content served
   from `/gateway/*`.
4. **Record the pin's provenance and its retirement condition** in the design doc:
   which sha, why, and what retires the pin (the API landing on `llm`, or being
   published). A pin with no stated exit becomes permanent by accident.

## Sequencing — do NOT deploy into the live incident

PRs kriscendobot/minion.town#23 and #24 are blocked behind
`minion-town-namespace-a-restore-auth`, which ends a >3-day production auth outage
(`github-idp`/`siwe-idp`/`www` failing TLS). CD on minion.town is **deploy-on-merge**.

Build and open your PR freely, but **do not merge until that job reports prod auth
restored and #23/#24 have landed**. If you reach a mergeable state first, say so and
hold.

## Verify

Local: a real OCapN CBOR round-trip and a Syrup round-trip against a seeded weblet,
proving the bootstrap surface equals the granted powers — the same bar Increment 3
met for native CapTP (its 169 tests, including a WS round-trip). Confirm the
fail-closed cases still fail closed. `tsc` clean.

## Report

Name the branch, the exact pinned sha, the PR, what retires the pin, and any part of
§6 that remains unimplemented. If the unpublished API turns out not to support
faithful termination after all, STOP and report that rather than faking it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-05T14:57:48Z
