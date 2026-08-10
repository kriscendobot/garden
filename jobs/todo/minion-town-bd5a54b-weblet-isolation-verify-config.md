---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. Same commit bd5a54b90d5e350ec0ba9253f823653eb3fbd90e touched the weblet domain/config plumbing: `src/config.ts`, `src/endo/gateway/{config,gateway,isolation-headers,base32,well-known,powers-plane,publish,seed-weblet,main}.ts`, `src/endo/guest-tools.ts`, plus tests `test/weblet-domain-config.test.ts` (new), `test/gateway/gateway.test.ts`, `test/gateway/cookie-scope.test.ts`.
Task: run the repo's local verification gates (lint, typecheck, full test suite) on `main` at this commit and confirm CI on `main` is green for it. If anything is red, drive it to green with a minimal fix commit on `main` and report what broke; if everything is green, report that and close out without changes.
