---
ts: 2026-06-23T00:24:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 372a37
prs:
  - { repo: endojs/endo-but-for-bots, pr: 507, role: new }
refs:
  - entries/2026/06/23/000626Z-dispatch-designer-372a37.md
  - entries/2026/06/23/000406Z-result-researcher-a4a14d.md
  - entries/2026/06/23/001327Z-result-designer-372a37.md
---

# result: designer — PR #507 notifier-pubsub-migration (new @endo/exo-pubsub; makeUpdateTopic retired)

PR #507 DRAFT, base llm,
head design/notifier-pubsub-migration. Single file
`designs/notifier-pubsub-migration.md` (480 lines, ~3
screens). Researcher precedence honored (refinement
inlined).

## Headline

- **Package home**: new sibling `@endo/exo-pubsub` (NOT
  absorption into `@endo/exo-stream`). Discoverability +
  scope-signal + composition-not-duplication.
- **`makeUpdateTopic` disposition: RETIRED**. The forward-
  lossless mode is recovered by composition
  (`makeChangeTopic` + one-shot `latestSnapshot()`
  accessor). Deprecated-on-arrival shim ships for one
  minor cycle, removed at next major.

## Final method signatures

```
makeLatestTopic({ valuePattern, returnPattern })
  → { publisher: Writer<T>, subscribe(): Reader<T>,
      finish(), fail(Error) }

makeChangeTopic({ valuePattern, returnPattern,
                  subscriberQueueLimit, overflowPolicy })
  → { publisher: Writer<T>, subscribe(): Reader<T>,
      finish(), fail(Error) }
```

Internal state for `makeChangeTopic` is per-subscriber
`makeQueue` from `@endo/stream` (the
async-singly-linked-list-queue endo#1444 names). Publisher
uses `Stream`-shape `next` / `return` / `throw`;
subscriber conforms to `PassableReader` (`stream`,
`readPattern`, `readReturnPattern`).

InterfaceGuard sketches included for
`LatestTopicPublisherI`, `LatestTopicSubscriberI`,
`LatestTopicHubI`.

## Open questions mostly resolved in-design

- Durable cross-restart storage of unread deltas: **out
  of scope for v1**; producer-side replay is the
  composition.
- Slow-subscriber backpressure: `subscriberQueueLimit` +
  overflow policy (default drop-oldest);
  `retention-accumulator` coalescing as upgrade path.
- **Remote subscriber severance: handled via
  `E.whenSevered(subscriberPresence)` per PR #450** (the
  presence-severance-observation design — cross-design
  composition working). Treated as implicit `return()`.
- Subscribe-time snapshot semantics: per-topic (latest
  sees latest cell; change sees future only; forward-
  lossless is composition).

## Still open for maintainer

Per-call-site notifier-caller survey across
`agoric-sdk` + `endo-but-for-bots` + `endo` is Phase 2
work; anchor is a to-be-filed tracking issue in the endo
tracker once Phase 1 ships.

Dispatch root torn down.
