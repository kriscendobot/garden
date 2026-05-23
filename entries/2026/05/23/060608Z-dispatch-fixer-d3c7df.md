---
event: dispatch
role: fixer
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/fixer--d3c7df
repo: endojs/endo-but-for-bots
issue: 349
base: llm
trigger: kriskowal @-mention 2026-05-23T06:04:05Z on assigned issue #349 — "port netlayer-tcp-syrup.test.js from makeClient to makeOcapn"
---

# Fixer dispatch: address issue #349 (makeClient → makeOcapn rename)

The test `packages/ocapn/test/netlayer-tcp-syrup.test.js` imports `makeClient` from `../src/client/index.js`. On `llm` that module now exports `makeOcapn` (arrived via upstream merge `bdb9ddc50`). The test fails the eslint `import/named` rule.

Procedure:
1. Branch off llm: `fix/issue-349-makeclient-to-makeocapn` or similar.
2. Update the import + any usage sites in the test file (and any other test files affected by the same rename).
3. Verify with `yarn lint` + `yarn test packages/ocapn/test/netlayer-tcp-syrup.test.js`.
4. Open a DRAFT PR against `llm` (auto-pickup chain by steward).
5. Link the PR to issue #349 with `Closes #349` in the body so it auto-closes on merge.
6. Post issue comment with the PR link.
