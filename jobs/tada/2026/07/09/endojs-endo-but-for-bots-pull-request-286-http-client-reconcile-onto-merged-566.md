Weave complete. PR #286 rebased onto current `llm` and reconciled against the merged #566; it is now MERGEABLE.

## What I did

**Rebased** `feat/cli-http-client-mk-phase-1` (was ~80 commits behind, CONFLICTING) onto current `llm`. Three conflicts, all resolved reading both sides:
- `host.js` / `types.d.ts` import + method-list conflicts (merged `HttpClientDeferredTaskParams`/`makeHttpClient` into llm's newer `ShellDeferredTaskParams`/`locateWithHints` lines).
- `designs/endoclaw-network-fetch.md` + `designs/README.md`: #286 carried a commit marking endoclaw-network-fetch **Superseded by cli-http-client** — but #566 *landed endoclaw's confinement core*, inverting that premise. Resolved to llm's already-reconciled "**In Progress**" status; the now-empty Superseded commit was dropped.

**Reconciled the core** (`fix(daemon/http-client): consume @endo/exo-http-client, drop duplicate core`): #286 had hand-rolled origin/redirect/allowlist/fetch logic in `packages/daemon/src/http-client.js`, which #566's `@endo/http-confine` + `@endo/exo-http-client` supersede. Rewired the daemon `http-client` formula to build the confined client through the landed `makeHttpClientAndControl` and adapt its `fetch()→HttpResponse-exo` surface to the design's `request({url,method?,headers?})→record` shape. Kept the Phase‑1 GET‑class guard and the mint-time allowlist validation at the integration layer; added `@endo/exo-http-client` as a daemon dependency (mirroring `@endo/exo-git`). Reconciled both daemon test files and the changeset; committed `yarn.lock` separately.

**Not superseded / not escalated:** the daemon+CLI integration (two formulas, `EndoHost.makeHttpClient` mint, `endo http mk` verb) is the M3 "confined outbound HTTP reachable by agents" layer #566 did *not* deliver — so I delivered the reconcile rather than stopping.

## Verification
- `tsc` on `@endo/daemon` and `@endo/cli`: **0 errors**.
- eslint on changed files: clean.
- Daemon `http-client-unit.test.js` reconciled to drive the **real landed capability**: **13/13 pass** (denied origins never reach fetch, allowed-GET success + response adaptation, `redirect:'manual'`, GET-class-only, HEAD admission, exotic-scheme + trailing-dot exactness, construction-without-fetch).
- e2e `http-client.test.js` (full daemon): could **not** run in this worktree — a Unix-socket-path-length limit fails *all* full-daemon tests here (confirmed: unmodified `endo.test.js` fails identically; the deep scratch path is 171 chars). Its assertions match the adapter surface by inspection; one stale message fixed. CI will exercise it in normal-length paths.

## Follow-ups
- Wire the landed `HttpClientControl` mutators (`addAllowedOrigin`, `revoke`, rate/byte/timeout) through the daemon controller facet in Phase 2/3 — currently the controller is a read-only allowlist holder and the paired control facet is unused.
- CI should confirm the full-daemon e2e suite (unrunnable locally here).

No PR comment posted (weave job carried no commenting authorization; the reconcile is documented in the commit message).
