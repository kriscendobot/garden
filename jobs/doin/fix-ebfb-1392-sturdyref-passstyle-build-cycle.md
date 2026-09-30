---
role: fixer
pr: https://github.com/endojs/endo-but-for-bots/pull/1392
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR #1392 (head build/sturdyref-pass-style-recognition) introduced the turbo cycle @endo/pass-style#build <-> @endo/sturdyref#build (pass-style depends on sturdyref; sturdyref devDepends on pass-style), so its test (24.x) leg is red. The same fix already landed on #1393's head as b9b3777f1b + yarn.lock 36c4f40bcd: drop @endo/pass-style from packages/sturdyref/package.json devDependencies and remove the passStyleOf import and the single 'passStyleOf rejects a SturdyRef' assertion from packages/sturdyref/test/sturdyref-shim.test.js (pass-style's test/sturdyref-absent.test.js already covers it). Apply it to #1392 with a separate yarn.lock commit.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T09:45:58Z
