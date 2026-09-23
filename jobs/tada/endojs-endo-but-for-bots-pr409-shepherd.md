All CI legs are still queued (`0` duration, runner-availability delay — unrelated to my change), so I can't observe green within a reasonable window. Rather than block indefinitely (the "watch-only is the wrong shape" norm), I'll conclude: the substantive fix is pushed and locally verified, and the leader's CI-watcher will re-dispatch a shepherd if the new run somehow stays red.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #409 — *feat(gateway): HTTPS proxy compat parser + startup warning (#343 phase 10)*.

**Root cause (single, not gateway-related).** All ten red checks — `lint`, `cover (20.x/24.x)`, every `test` matrix leg (20/22/24 × ubuntu/macos), and `test-xs` — traced to one stale test file: `packages/ocapn/test/netlayer-tcp-syrup.test.js`. An earlier commit in this branch's stack (`9403bfa84`, "feat(ocapn): codec injection + network/transport split (#59)") renamed the client API `makeClient` → `makeOcapn` and replaced `client.registerNetlayer(...)` with a `{ codec, network }` constructor, but never updated this test. The dead `import { makeClient }` produced the lint `import/named` **error** (the sole error among 2227 warnings) and, at runtime, crashed the whole ocapn test file (`SyntaxError: ... does not provide an export named 'makeClient'`), which failed `test`/`cover`/`test-xs` wholesale. Not present on `master` (where the old API and test still match); it is a stale-test-after-rename gap carried by the phase stack.

**Fix (one commit, `162e52e24`, test-only).** Migrated the two client-constructing tests to `makeOcapn({ codec: syrupCodec, network: <factory>, locator })`, capturing the netlayer through a small `NetlayerRef` helper exactly as the already-passing `netlayer-websocket.test.js` does (`swissnumTable` → `locator`). The third test (`rejects unknown framing option`) needed no change. No production code touched.

**Verification (real execution, in an isolated installed worktree).**
- `ava netlayer-tcp-syrup.test.js` → **3 tests passed** (both wire-sniff and round-trip echo).
- `prettier --check` → clean.
- `eslint` on the file → **0 errors** (only 2 pre-existing `jsdoc/reject-any-type` warnings, unchanged).

**Pushed** to `design/gateway-package-phase-10` (`4d5cfc5b1..162e52e24`); a fresh CI run (28557670558) is queued on the new SHA. No PR comment posted — the auto-dispatched job carried no commenting authorization.

**next: none** — root-cause fix applied and locally verified; the reddening was a single stale-test crash. Follow-up (informational, not blocking this PR): the same rename left a `registerNetlayer` reference in `packages/ocapn/src/client/types.js` JSDoc (warning-level only), worth a tidy on a future ocapn touch.
