---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear the shepherd role. Drive CI green on https://github.com/endojs/endo-but-for-bots/pull/1394 (head build/sturdyref-captp-wire, base build/sturdyref-marshal-representation-6976bb0). The predecessor restack job rebased it, fixed the TS6307 composite-build failure, and fixed package uniformity (renamed the ocapn declarations to *.types.d.ts). Remaining failures from earlier runs (viable-release smoke publish, test, cover, matrix.check, compare/format-ironhorse, test-async-hooks) may have cascaded from the declaration build; triage whatever is still red on the latest head. Do not rebase or change the base.
