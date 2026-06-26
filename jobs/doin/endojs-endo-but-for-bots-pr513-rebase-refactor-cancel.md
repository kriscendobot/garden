# #513: rebase onto current llm (now has @endo/cancel) and refactor pubsub to use it

Maintainer directive (kriskowal, #513 comment 4805431289):
*"@kriscendobot cancel package merged. Please rebase and refactor."*
**#513** = `feat(pubsub): create @endo/pubsub with Sink/Spring async promise linked list`. The
**`@endo/cancel`** package merged onto `llm` (via #528 earlier today). Wear the **weaver** then
**fixer** role. Bot repo `endojs/endo-but-for-bots`, PR **#513**, bot identity.

## Task

1. **Rebase #513 onto current `llm`** (which now contains `@endo/cancel`). If #513's base is a
   frozen `llm-<sha>` snapshot, refresh it to a current snapshot of live `llm` first (frozen-base
   discipline), then rebase; resolve conflicts.
2. **Refactor `@endo/pubsub` to use the merged `@endo/cancel`**: replace any bespoke
   cancellation / abort / cancelled-promise logic in pubsub (Sink/Spring) with the now-available
   `@endo/cancel` primitives; add the dependency; keep the public behavior. Keep `tsc`/eslint/tests
   green (use the local-verify discipline; capture failures via the git-hash pattern).
3. If a weave/rebase impasse arises, **escalate to a fixer and resume** per the standing rule.

## Close-out

Post a **top-level summary comment** on #513 (the rebase + what was refactored onto `@endo/cancel`
+ verification status), per the standing PR-summary-comment norm.

## Definition of done

#513 rebased onto current `llm` and `@endo/pubsub` refactored to consume `@endo/cancel`, green,
with a summary comment. Report the new base/head and what pubsub now delegates to `@endo/cancel`.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 36
  claimed_at: 2026-06-26T05:08:25Z
