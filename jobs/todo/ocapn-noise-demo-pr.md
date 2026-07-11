---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-11T03:52:05Z -->

role: builder

# Open the two-peer OCapN-over-Noise demo as a draft PR (milestones 1 & 2)

**Repo:** `endojs/endo-but-for-bots`. **Branch (already pushed):**
`demo/ocapn-noise-two-peer` (base `llm`, 2 commits). Do **not** ferry upstream.

The branch adds `packages/ocapn-noise/demo/{peer,server,client,scenarios}.mjs`,
`run-local-pair.sh`, `run-all.sh`, `README.md`, and fixes a vacuous session-id
assertion in `test/crossed-hellos.test.js`. It has been run green locally: the demo
round-trips an OCapN capability between two processes over real WS and real
TCP+CBOR, and validates Crossed Hellos + reverse peer auth on both transports.

## Task

1. Open a **draft PR** from `demo/ocapn-noise-two-peer` → `llm` (title e.g.
   `feat(ocapn-noise): two-peer demo + crossed-hellos session-id fix`). Summarize
   what it demonstrates (M1 capability round-trip on both transports; M2 Crossed
   Hellos + reverse peer auth) and the test fix (immutable-ArrayBuffer `slice(0)`
   read).
2. Verify green in a fresh worktree: `cd packages/ocapn-noise && yarn test
   test/crossed-hellos.test.js test/integration.test.js test/network-tcp.test.js
   test/ws-transport.test.js`, and `bash demo/run-all.sh` (4 transcripts PASS).
   Run `yarn lint` in `packages/ocapn-noise` and fix any harden-exports /
   no-underscore-dangle nits in the new files.
3. If lint wants `harden(...)` on the demo helpers or `// @ts-check` headers, add
   them — keep the demos runnable.

**Tentative-decision latitude:** if a demo file trips an ESLint rule that fights a
runnable standalone script (e.g. `demo/` isn't linted like `src/`), prefer the
smallest change that keeps `demo/run-all.sh` green over deleting coverage; note the
choice in the completion report. Deliver: PR URL + the four transcript results.
