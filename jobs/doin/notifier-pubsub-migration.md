# notifier-pubsub-migration: add @endo/exo-pubsub (all bridges) + migrate daemon→chat topics as empirical validation

Map: **design + build** on **endojs/endo-but-for-bots** (bot fork; standing comment
authorization). Substantial — run a researcher/design pass, then build through the gamut
(builder → judge panel). Open a PR on endo-but-for-bots; COMMUNICATE ON THE PR (inline +
a top-level summary comment per the comms directive), not the maintainer inbox.

Overarching theme (per the job name): evolve the **notifier** pattern (async-iterator state
followers) toward a **pub/sub** model. `@endo/pubsub` (v0.1.0) already exists; this job adds
the exo bridges and proves the model on a real daemon→chat path.

## 1. Add `@endo/exo-pubsub` — all the bridges
Create `packages/exo-pubsub` (`@endo/exo-pubsub`) as the **exo-object bridge layer over
`@endo/pubsub`**, following the ESTABLISHED sibling pattern of **`@endo/exo-stream`** (and
`@endo/exo-git`, `@endo/exo-playwright`) — mirror exo-stream's package layout, exports shape,
bridge structure, hardening/`@endo/exo` discipline, and test conventions. "All the bridges":
the full set of `@endo/pubsub` primitives (publisher, subscriber/subscription, topic — confirm
the exact surface from pubsub's exports) wrapped as **remotable exo objects passable over
CapTP**, so a publisher/subscriber can cross a vat/daemon boundary the way exo-stream lets a
stream cross it. Unit tests per bridge.

## 2. Empirical validation — migrate the daemon pubsub topics chat subscribes to
The validation must be **empirically verifiable**, not asserted. RESEARCH FIRST: identify the
existing `@endo/pubsub` topics in `packages/daemon` that `packages/chat` currently subscribes
to. Then REPLACE those topics with `@endo/exo-pubsub` equivalents end to end (daemon publishes
via exo-pubsub; chat subscribes via the exo bridge across CapTP). The concept is validated
when **chat keeps working** — its subscriptions still deliver updates after the migration —
proven by the chat test suite (and/or a focused integration test) passing against the
exo-pubsub path. Keep the diff scoped to the daemon topics chat actually consumes; don't
migrate unrelated topics in this PR.

## 3. Report the next steps for collection change followers
A primary deliverable: the migration is expected to REVEAL the obvious next steps for the
evolution of **collection change followers** (followers that track collection mutations — the
notifier→pubsub evolution applied to collections). Capture what the exo-pubsub bridge + the
daemon/chat migration surface about how collection-change following should evolve next, as an
explicit **"Next steps: collection change followers"** section in the design doc and the PR
summary comment. This is wanted output, not an afterthought.

## Constraints
- Follow `@endo/exo-stream` as the canonical template for an exo bridge package; match repo
  conventions (changeset discipline, spelled-out identifiers, hardened exports, test-title
  spelling, yarn.lock as a separate commit if it moves).
- endo-but-for-bots only (bot fork); no upstream endojs/endo or agoric-sdk action.
- Empirical bar: the validation is the chat subscriptions still working over exo-pubsub, shown
  by passing tests — make that the PR's headline evidence.

## Deliverable
`@endo/exo-pubsub` (all bridges, exo-stream-patterned, tested) + the daemon→chat topic
migration with passing chat/integration tests as empirical proof + a design doc and PR summary
comment that include the "Next steps: collection change followers" section. PR on
endo-but-for-bots, reviewed through the panel.

---
claim:
  host: endolinbot
  gardener: 10
  claimed_at: 2026-06-28T07:04:02Z
