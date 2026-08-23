---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Rebase PR #33 (`feat/weblet-user-powers-reference`, base `main`) on the latest `main` (5e88fe6). `main` just took PR #51 "feat: publish weblets through guest site directories" (affa345, merged as 5e88fe6), a major refactor of the exact same gateway subsystem PR #33 touches: `src/endo/gateway/gateway.ts`, `powers-plane.ts`, `powers-source.ts` (gutted from 174 to a stub in the new merge), `publish.ts` (rewritten), `vhost-table.ts`, plus `src/endo/guest-control.ts`, `guest-memory.ts`, `guest-tools.ts`, `root-host-socket.ts`, `src/http.ts`, and `package.json`/`package-lock.json`. Expect real conflicts, not just a clean fast-forward — `powers-source.ts` in particular lost most of its old body in favor of the new `site-registry.ts`, so PR #33's changes there will need to be re-targeted at the new structure, not merely conflict-marker-resolved. Confirm tests (`test/gateway/powers-plane.test.ts`, `test/endo-weblet-tools.test.ts`, etc.) still pass post-rebase.
