All tasks complete, worktree and shim cleaned up, inbox empty. Here is my completion report.

---

## Completion report: `notifier-pubsub-migration`

**Outcome:** Built `@endo/exo-pubsub`, migrated the daemon→chat follow paths onto it as empirical proof, and opened **DRAFT PR endojs/endo-but-for-bots#553** (base `llm`), ready for the judge panel to un-draft.

### What I did

**1. `@endo/exo-pubsub` (all bridges, exo-stream-patterned).** New `packages/exo-pubsub` mirroring `@endo/exo-stream`'s layout, exports shape, and `@endo/exo` discipline (flat layout, one bridge per subpath export, no barrel). Six bridges — responder and initiator side for each of `@endo/pubsub`'s three facets: subscription (`subscription-from-reader.js` / `iterate-subscription.js`), publisher (`publisher-from-writer.js` / `iterate-publisher.js`), and **topic** (`topic-from-subscribe.js` / `subscribe-topic.js`). The topic bridge is the pub/sub-specific primitive exo-stream lacks: a fan-out whose remote `subscribe()` mints an independent cursor on demand. It composes exo-stream's pumps (a subscription *is* a Reader, a publisher *is* a Writer) rather than forking the bidirectional promise-chain protocol. README, changeset, tsconfigs (composite generated), LICENSE/SECURITY, and 10 unit+CapTP tests included.

**2. Migration as empirical validation.** Research corrected the job's premise: `packages/chat` (not `goblin-chat`) is the consumer, and it follows the pet-store `nameChangesTopic` (`followNameChanges`) and mailbox `messagesTopic` (`followMessages`) — both already bridged with exo-stream. I swapped those two chat-consumed paths from `readerFromIterator` → `subscriptionFromReader` daemon-side (`host/guest/directory/daemon.js`) and `iterateReader` → `iterateSubscription` chat-side (5 files + the test mock). Wire-equivalent, scoped to the two topics chat consumes; channel/heat/retention/id-change topics left on exo-stream.

**3. Empirical proof (tests, not assertion):** `@endo/exo-pubsub` 10/10; **`@endo/chat` 762/762** (incl. the `followNameChanges` rendering tests over the exo-pubsub mock); **real forked-daemon over CapTP** — the five `followNameChanges publishes …` tests and `guest facet receives a message for host`. `tsc` clean; eslint 0 errors (the `any` warnings match exo-stream's own `makeExo` pattern).

**4. "Next steps: collection change followers"** added as an explicit section in both `designs/notifier-pubsub-migration.md` (plus a `## Status` section and a honest deviation note) and the PR summary, grounded in four findings the migration surfaced: the hand-rolled snapshot-then-subscribe composite → a collection-change-follower bridge; per-consumer hand folding → land `patcherFromTopic`; opaque deltas → typed splice records + incremental transforms; the passable topic → automatic re-subscription for FRB bindings.

### What changed
- New package `packages/exo-pubsub/` (18 files); `.gitignore` allowlist entry for its `types.d.ts`.
- `packages/daemon/src/{host,guest,directory,daemon}.js`, `packages/daemon/package.json` (+dep).
- `packages/chat/{channel-list,spaces-gutter,outliner-component,setup-lal,setup-llm-provider}.js`, `test/helpers/mock-powers.js`, `package.json` (+dep).
- `designs/notifier-pubsub-migration.md` (+Status, +Next steps), `designs/README.md` (summary row), composite tsconfigs, changeset, yarn.lock (own commit).
- Two commits on `feat/exo-pubsub-bridges` (source + separate `chore: Update yarn.lock`), committed as `endolinbot`.

### Follow-ups
- **PR #553 is DRAFT, ready for the judge/barrister panel** (build stage done; panel un-drafts on termination).
- A notable finding flagged in the PR/design: the design's proposed adapter catalog assumed a `{ sink, makeSpring }` local-pubsub shape, but the `@endo/pubsub` that landed on `llm` exposes `{ publisher, subscribe }`; this slice bridges the landed surface. The sampler/patcher/`reduceReader`/hot-cold catalog remains future work.

Self-improvement: nothing this time. (The one snag — the manual `makeCapTP`-over-pipe test harness silently miscarries the writer path with a misleading "Remotables must be explicitly declared"; `makeLoopback` is the reliable harness — is library-specific, not a garden-process lesson.)
