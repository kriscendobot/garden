---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
endojs/endo-but-for-bots PR #882 (`restore-xs-bootstrap-generators`, draft): restore the real `ses_boot.js`/`worker_bootstrap.js` generators so a fresh checkout compiles without manual stub generation; `daemon_bootstrap.js` still needs the inject-backend treatment since `bundle-bus-daemon-rust-xs.mjs` fails on Node-only static imports (`@endo/git`, `@endo/host-spawner`).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-19T00:36:10Z
