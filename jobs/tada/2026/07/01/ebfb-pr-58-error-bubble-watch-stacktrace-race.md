Cleanup done; the PR branch tip is my pushed commit `5f6357ba2`. The job is complete.

---

## Completion report

**Job:** PR #58 (endojs/endo-but-for-bots, bot fork) — diagnose the test-vs-local race and make the error bubble watch for the stack trace per the maintainer's design.

**Race diagnosed by direct inspection.** The trace *record* (unredacted stack + producing worker id) doesn't travel with the error — the worker pushes it to the daemon on a **separate, asynchronous `reportTrace` send** while the rejection travels worker→daemon→browser. With no cross-connection ordering guarantee, the browser's **one-shot** `traces().lookup()` frequently runs before the record is filed. Compounding it: `trace-aggregator.alias()` **permanently dropped** the client-facing alias whenever the record wasn't present yet, so the browser errorId was severed from its record forever — matching "I never see the triangle or chip locally." The single-process daemon/component tests hid both because they await enough turns that the record is always already there.

**Fix (two necessary parts):**
1. **daemon** — `alias()` now registers the authoritative `(workerId, errorId)` mapping eagerly; `resolve()` already tolerates a not-yet-present record, so the alias resolves once the record lands.
2. **chat** — `resolveErrorTrace` carries the recovered `errorId`; the error bubble starts `watchErrorTrace(...)` when it has an errorId but no stack/worker, enriches in place when the record arrives, and **cancels the watch when dismissed by the next command** (`setCommandError('')`). Same watch/cancel applied to the `/eval` modal.

**Verified under real local-usage** (not the harness): drove the actual browser client code (`connection.js` CapTP + `error-trace.js`) against a live `endo start` daemon + real worker + ws-gateway running `/js throw new Error("x")`. With `reportTrace` forced 1.5s late (throwaway instrument, not committed): eager-alias **OFF** → watch never recovers (reproduces the permanent-miss bug); **ON** → watch recovers stack+chip in ~1538ms; no delay → 25/25 first-try. Both parts proven necessary. Deterministic regression tests added at three layers (aggregator, watch-unit, chat-bar routing); `lint:eslint`/`lint:types` clean for daemon/spaces-util/chat; 84 affected tests pass.

**Landed:** commit `5f6357ba2` pushed to `feat/error-tracing-implementation`; posted the diagnosis + implementation + real-usage A/B evidence as a PR #58 comment.

**Coordination note (follow-up for the liaison):** a **duplicate dispatch** existed — peer gardener `endojs-endo-but-for-bots-pr58-4932647c` was working the same directive and briefly clobbered my WIP in a shared checkout, then reverted and deferred the landing to me. I adopted its cleaner errorId-keyed client-side implementation (error-trace.js, chat-bar-component.js, mock-powers.js, chat-bar.test.js) and folded in my daemon root-cause fix. The peer had already completed by the time I confirmed back (message dead-lettered, intent preserved). Worth dismissing such duplicate dispatches earlier, and note that concurrently-created project worktrees off the same bare clone can collide on a guessed path.
