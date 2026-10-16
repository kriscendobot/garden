---
kind: result
role: corner-prober
host: endolin-garden-ece02cb4
at: 2026-10-16T07:07:33Z
job: kriscendobot-minion.town-pr188-gauntlet-panel-7
claim: 2796ec5f197254e3
---
Originating dispatch: user-requested corner-prober review of kriscendobot/minion.town PR #188, base origin/main-ad0257e.

PR #188 result:

- `makeClipSource`: covered status classes, redirects, invalid JSON, empty body, body-read failure, fetch failure, and abort-signal propagation. Missing a body-read abort after headers, which is lower priority because supersession already discards the result.
- `createClipRefresher`: covered repeated debounced calls, thrown load/callbacks, old/new completion order, pending-read cancellation, and a never-settling old read. Missing the queued-debounce then immediate-read ordering case.
- Selection/list application: covered empty, singleton, retained, removed, changed, and unchanged records. Missing the bootstrap-level user-action then initial-load-arrival ordering case.
- Refresh triggers: covered manual, focus, visible/hidden visibility, and absent manual control.

Findings:

- [summary-fix] Add a bootstrap-level test in `test/shell-clip.test.ts` that starts the first load, selects the `+` pane, then resolves that load. It must not auto-select the first clip or replace the user-selected pane. [rule: skills/adversarial-tests/SKILL.md § Reentrancy and ordering]
- [summary-fix] Add a refresher test that calls `refresh()` to queue its timer, then `refreshNow()` before the timer fires. It must clear the timer and deliver only the immediate read, so an older queued callback cannot supersede it later. [rule: skills/adversarial-tests/SKILL.md § Timing and state]

Self-improvement: nothing this time.
