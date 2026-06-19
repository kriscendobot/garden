---
ts: 2026-06-18T23:05:00Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

## Classification

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| C | familiar-bundle | Could not resolve "@opentelemetry/api" (esbuild, otel.js shim in @mistralai/mistralai) | Fixed in 1fe68e21 |

## Fix

Root cause: `@mariozechner/pi-ai` (a lal dependency on the feat/lal-pi-harness PR) pulls in `@mistralai/mistralai` as an optional provider. That package ships an optional observability shim (`esm/extra/observability/otel.js`) that imports `@opentelemetry/api`. That package is not installed in this repo. esbuild walks into the shim when bundling `packages/lal/agent.js` (the ESM caplet bundle) and fails with exit code 255.

Fix: added `'@opentelemetry/api'` to the `external` array in `packages/familiar/scripts/bundle.mjs` alongside the existing optional-native exclusions (`bufferutil`, `utf-8-validate`). The shim remains in the transitive graph but the unresolvable import is marked external, which matches esbuild's own suggestion in the error message.

Commit: 1fe68e21 "fix(familiar): exclude @opentelemetry/api from esbuild bundle"
Pushed to: endojs/endo-but-for-bots feat/lal-pi-harness

PR summary comment posted at:
https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4749216834

## Termination

All other CI checks were already passing. next: none (no escalation; CI should go green on the next run).
