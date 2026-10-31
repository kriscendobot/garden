I recorded the decision on how `@endo/confined-fetch` gets timers in a confined worker. It's commit `6aa23df64c` in `designs/endo-fetch.md`, pushed to the head branch (`endo-fetch-split-confined-plugin`) of draft PR https://github.com/endojs/endo-but-for-bots/pull/1588. No code changed, as the job asked. Design slug: `endo-fetch`.

**Decision:** pass time into the shared HTTP packages as arguments, and give the confined plugin a `Timer` capability.
- **What reads time today:** five things read time from globals: the per-request deadline, aborting in-flight requests on revocation, the rate-limit window, the policy-prompt timeout, and the `decidedAt`/audit timestamps. A confined-worker compartment has no `setTimeout`, no `AbortController`, and a `Date.now()` that throws.
- **Cancellation:** `@endo/http-confine` drops `AbortController` and uses `@endo/cancel`'s `makeCancelKit` instead. Requests carry a `cancelled` token. Only the code that calls the real ambient `fetch` turns it into an `AbortSignal` (with `toAbortSignal`).
- **Timers:** the only timer argument is `delay(ms, cancelled)`, the same shape `makeDelay` returns. The deadline, prompt timeout and rate-limit window are all built on it. The rate limiter keeps one slot per request and frees it after 60 s, which gives the same sliding window without needing a clock.
- **Timestamps:** the `now` argument may return a promise, and the code awaits it wherever it stamps a binding or an audit entry. As a result, the control methods `revokeBinding` and `unpin` become `M.callWhen`.
- **Defaults:** `@endo/http-confine` reads no globals at all. `@endo/exo-http-client` keeps its global defaults for unconfined callers only.
- **The `Timer`:** `@endo/confined-fetch` requires a new `timer` power, a stateless `Timer` with `delay` and `now` that the integration runs unconfined, keeps, and restores at revival. Guests never get it. Unlike `delay-lite`, it must clear its host timer when cancelled, and it must reject delays over `2**31-1` ms rather than let Node silently shorten them to about 1 ms.
- **Precedents:** this matches how the repo already does it: `@endo/cancel` `delay-lite`, `@endo/reminder`'s scheduler, `@endo/workflow`'s clock and thixotrope's `TimerPowers` all take time as an argument from one unconfined source.

**Rejected options:**
- **Enforcing the deadline in the `@endo/fetch` base:** it covers only one of the five uses, so the endowment would still be needed.
- **Adding timers to the daemon's confined-worker endowments:** that would hand time to every confined plugin, not just this one.
- **Reusing `@endo/reminder` or the daemon's `makeTimer`:** neither has a usable `delay(ms, cancelled)`.
- **Keeping the plugin unconfined (today's workaround):** that gives it the ambient `fetch` the two-plugin split exists to withhold.

**What else changed in the doc:**
- The "`@endo/http-confine` remains untouched" line is revised.
- `timer` is added to the confined plugin's required powers and to the revival recipe.
- There is a new Phase 4, Design Decision 6, and a link to `inventory-cancel-and-liveness`.
- The "Open gap" note now says to use `makeUnconfined` until Phase 4 lands.

**Open question for the maintainer:** which package should export the `Timer` maker? I recommend `@endo/fetch/timer.js`, since the integration already runs that package unconfined. The alternative is `@endo/cancel`, which other confined plugins could reuse, but it would need to start depending on `@endo/exo`.

**Follow-ups:**
- I parked the Phase 4 build as `build-confined-fetch-timer-endowment`, blocked until #1588 merges or closes.
- #1588 stays draft. It isn't a design-only PR, so no separate design-panel gauntlet starts automatically; its existing review covers the new commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-confined-fetch-timer-endowment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (1061850 cached reads)
- Output: 17784 tokens
- Cost: $1.2679220000000002
- Wall-clock: 211s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
