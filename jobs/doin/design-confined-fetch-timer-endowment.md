---
posted_at: 2026-10-31T07:20:14Z
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design how `@endo/confined-fetch` gets timers when it runs in a genuinely confined worker in endojs/endo-but-for-bots (base `llm`). This is the follow-up gap from draft PR https://github.com/endojs/endo-but-for-bots/pull/1588 (the `@endo/fetch` / `@endo/confined-fetch` split, `designs/endo-fetch.md`).

Gap: `@endo/http-confine` (`makeRequestSignal`, the rate limiter, the default `now`) reads the ambient `setTimeout`, `AbortController`, and `Date.now`. The daemon's confined-worker compartments (`packages/daemon/src/worker.js` `endowments`, used by `makeBundle` / `makeArchive`) provide none of them, so the confined plugin can only be provisioned via `makeUnconfined` today. `designs/endo-fetch.md` says `@endo/http-confine` "remains untouched". Choose between options such as injecting timer/clock seams into http-confine and endowing a timer capability to the confined plugin, or moving timeout enforcement into the `@endo/fetch` base. Check the precedents first (`@endo/cancel` `delay-lite`, `@endo/reminder`'s timer handling). Update `designs/endo-fetch.md` with the decision. Do not change code in this job.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-31T07:20:38Z
