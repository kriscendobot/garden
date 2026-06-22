---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 486
created_at: 2026-06-22T03:45:00Z
last_appended_at: 2026-06-22T03:45:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#486

## Items

- [ ] Concurrent `next()` test for `makeBufferedReader`: add a test asserting two
  concurrent callers both wake correctly on `drainWake()`.
  **Source juror(s)**: corner-prober
  **Round**: 1
  **Recommended action**: open follow-up PR adding the concurrency test

- [ ] `conversationStarted` set before turn completion: confirm whether a
  failed-spawn-with-no-output still creates a conversation file, add a comment
  clarifying the invariant.
  **Source juror(s)**: corner-prober
  **Round**: 1
  **Recommended action**: comment or test in claude-client.js

- [ ] `readStderrBrief` overshoot: document the bounded "up to chunk-size over" in
  the adjacent comment.
  **Source juror(s)**: prover
  **Round**: 1
  **Recommended action**: one-line comment in claude-client.js

- [ ] Compound-failure test for `provision()` partial cleanup when revoke also throws
  during cleanup.
  **Source juror(s)**: prover
  **Round**: 1
  **Recommended action**: additional test case in claude-client-module.test.js

- [ ] `createSession` host-resolution trust boundary: add a note in SECURITY.md or
  DESIGN.md that a peer can name any filesystem pet name in the host's namespace.
  **Source juror(s)**: locksmith
  **Round**: 1
  **Recommended action**: paragraph in DESIGN.md § Known issues or SECURITY.md

- [ ] `TextDecoder` global: add `/* global TextDecoder */` for consistency with
  existing `/* global process */` annotations.
  **Source juror(s)**: spec-keeper
  **Round**: 1
  **Recommended action**: one-line comment in claude-client.js

- [ ] Explicit `harden(options)` before `makeUnconfined` call in `formulateSession`
  to make authority intent visible.
  **Source juror(s)**: purist
  **Round**: 1
  **Recommended action**: one line in claude-sandbox-factory.js:1962

- [ ] Audit `packages/claude-sandbox/tsconfig.composite.json` for `"composite": true`
  and correct `references` entries.
  **Source juror(s)**: gateway
  **Round**: 1
  **Recommended action**: verify tsconfig is well-formed for composite build

- [ ] Sibling packages section in DESIGN.md cross-referencing PR #328
  (`@endo/claude-container`) and the shared credential contract.
  **Source juror(s)**: scribe
  **Round**: 1
  **Recommended action**: paragraph in DESIGN.md

- [ ] CI job hard-codes `ubuntu-latest`; note if sandbox matrix ever expands.
  **Source juror(s)**: integrator
  **Round**: 1
  **Recommended action**: inline comment in ci.yml

- [ ] `fast-check` property-based test for `parseStreamJsonLines` chunk-boundary
  invariant (any chunking of a fixed JSON-line set should parse identically).
  **Source juror(s)**: fast-checker
  **Round**: 1
  **Recommended action**: property test in claude-client.test.js

- [ ] `setup.js` idempotent provisioner: document what triggers a re-provision
  (manual remove + re-run) for operators who upgrade caplet behavior.
  **Source juror(s)**: migrator
  **Round**: 1
  **Recommended action**: paragraph in DEMO.md or DESIGN.md
