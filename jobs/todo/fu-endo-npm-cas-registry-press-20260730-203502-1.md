---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
endojs/endo-but-for-bots PR #882 (`restore-xs-bootstrap-generators`, draft): restore the real `ses_boot.js`/`worker_bootstrap.js` generators so a fresh checkout compiles without manual stub generation; `daemon_bootstrap.js` still needs the inject-backend treatment since `bundle-bus-daemon-rust-xs.mjs` fails on Node-only static imports (`@endo/git`, `@endo/host-spawner`).
