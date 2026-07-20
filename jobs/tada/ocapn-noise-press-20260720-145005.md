**Press dispatch 12 complete — steady state re-proven live; no new work unblocked.**

**Assessment:** All six PRs (#340 → #684 → #688 → #693 stack, #683, and fix #806) are unchanged since dispatch 11 this morning — same heads (#693 @ `73ad1b6d`, #806 @ `1e4f9104`, `llm` base @ `00a04f5b`), all OPEN/DRAFT/MERGEABLE with every CI check green (#806: 22/22 including both viable-release jobs). No new comments, reviews, or maintainer directives on any of the six PRs since 09:15Z; job inbox empty; no peer workers on these branches.

**What I did:** Since the last live proof was ~12h old (dispatch 10), I re-proved both cross-host demos at the current heads with fresh captured output:

- **M4 toy greeter over `wss://minion.town/ocapn`**: fetched the daemon's live location via SSM, dialed with Noise IK, invoked the `greeter` capability — `RESULT {"ok":true,...,"reply":"Hello, the local peer! …"}`, with `getNodeId()` matching the advertised designator (reverse peer authentication holds).
- **M5 pure-CLI cross-host Pet-Daemon invite/accept** (`run-cross-host-cli.sh`): `endo invite` on minion.town → local daemon boot → `endo accept` over `wss://minion.town/ocapn-daemon` → two-way message round-trip — `CROSS-HOST CLI DEMO PASSED`.

Both Caddy routes answer 426 (alive). Posted the dispatch-12 evidence comment on #693: https://github.com/endojs/endo-but-for-bots/pull/693#issuecomment-5023696577

**One repro gotcha found and recorded:** `corepack yarn install --mode=skip-build` cannot boot a local Pet Daemon — `better-sqlite3`'s native binding is missing and `endo start` fails with "Could not locate the bindings file". Fixed by copying `better_sqlite3.node` from a previously built scratch worktree; documented in the #693 comment and in the `endo-local-test-bin-shims` memory. Also updated the `ocapn-over-noise-goal` memory and index (re-proof date, #806 status).

**Follow-ups (unchanged, all blocked on external input):** #806 (crossed-hello settlement-race fix, fully green) awaits maintainer merge to `llm`, then a stack rebase inherits it; cross-host TCP+CBOR awaits the maintainer's non-443-port answer (asked 2026-07-17, still unanswered); bidirectional pairing awaits a publicly dialable garden address; the session-reconnect design and relay implementation remain deliberately deferred. No garden-repo (main2) changes were needed this dispatch.
