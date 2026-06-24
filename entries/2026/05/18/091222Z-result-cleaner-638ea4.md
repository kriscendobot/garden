---
ts: 2026-05-18T09:12:22Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/cleaner--638ea4
---

Cleaner pass complete on PR #286 (cli-http-client Phase 1, base `llm`).

## Cleaner commits

- `c440be5d5` fix(daemon/http-client): enforce GET-class verbs in request() per design Phase 1
- `0359d1acc` test(daemon/http-client): regression evidence for Phase 1 adversarial surface

Pushed to `feat/cli-http-client-mk-phase-1`.

## Lint / format / tests

Before the cleaner's commits:

- `yarn lint:eslint` on `@endo/daemon`: 318 warnings, 0 errors related to this PR's files (one pre-existing error in `test/disconnect-error-display.test.js` unrelated to this branch).
- `yarn lint:eslint` on `@endo/cli`: 12 warnings, 0 errors.
- `yarn prettier --check` on all 17 PR-touched files: clean.
- `@endo/daemon` full suite: 556 passed, 1 failed (`channel-relay > channel join fails gracefully without adoptFromLocator (no peer info)`), 4 skipped. The failure reproduces only under the full serial suite; running `test/channel-relay.test.js` in isolation passes. Git blame confirms the test was last touched in `27c27335d` and the file is untouched by this PR; flake is pre-existing on the `llm` head.
- `@endo/cli` full suite: 18 passed.
- 22 new tests from the builder all pass (9 daemon unit, 9 daemon-level real-HTTP, 4 CLI smoke).

After the cleaner's commits:

- Lint counts unchanged (no new errors; +2 warnings absorbed by adding the `await null;` jessie separator to silence `safe-await-separator` in two regression-evidence loops).
- Prettier still clean on the two cleaner-touched files.
- `@endo/daemon` full suite: 560 passed (+4), 1 failed (same pre-existing channel-relay flake), 4 skipped.
- `@endo/cli` full suite: 18 passed.

## Pair invariant check (controller bears policy, client uses it)

Verified by code grep. The two formula types instantiate **distinct** exos at incarnation time (`packages/daemon/src/daemon.js` § `'http-controller'` / `'http-client'` handlers):

- `'http-controller'`: passes `{ allowedOrigins }` into `makeHttpControllerExo(...)` from `src/http-client.js` `makeHttpController`.
  The resulting exo exposes only `inspect()` and `help()`; **no** `fetch` and **no** policy-mutation surface.
- `'http-client'`: resolves its `controller` field to the controller exo, then constructs `makeHttpClientExo(controller, { fetch: ... })` from `src/http-client.js` `makeHttpClient`.
  The resulting exo exposes only `request()`, `allowedOrigins()`, and `help()`; it holds the controller as a remotable ref and reads the live allowlist through `E(controllerRef).inspect()` on every call.

The daemon-level test `controller bears the policy; client uses it (invariant)` already pins this with `__getMethodNames__()`; the cleaner-added Phase-1-method test reinforces it by proving the client's `request` is gated.

## Drift items between design and implementation

**Drift found and fixed** in the cleaner's first commit:

- The design's *Status* section (lines 51-53 of `designs/cli-http-client.md`) lists "Methods beyond GET-class verbs (HEAD, POST, PUT, etc.) — Phase 4." and the committed `help-text-data.js` advertises *"Phase 1: GET-class verbs only"*.
  The builder's `request()` implementation in `packages/daemon/src/http-client.js` accepted *any* method string and forwarded it to `fetch` unmodified.
  A guest holding the client could issue POST / PUT / DELETE / PATCH against an allowlisted origin, exceeding the read-only authority Phase 1 promises.
  Fixed by adding a `method !== 'GET' && method !== 'HEAD'` guard at `request()` entry with a structured error.

No other Phase 2 / 3 / 4 deferral is accidentally claimed delivered:

- Phase 2 (allow/deny/revoke/inspect verbs): the CLI exposes only `endo http mk` (`packages/cli/src/endo.js`); no other `endo http <verb>` is wired.
- Phase 3 (rate / size / timing guards, cancellation): not present.
  `HttpClientInterface` is `M.call(HttpRequestShape).returns(...)` with no `cancellation` second argument; the controller has no `setMaxRequestsPerMinute` / `setMaxResponseBytes` / `setTimeoutMs` methods.
- Phase 4 (methods beyond GET, response streaming): now strictly enforced (cleaner's fix above); the response body is buffered `text()` only.
- Trust-on-first-bind addendum: not referenced in the implementation; the design's *Trust model* section still describes the strict-by-default mode as Phase 1's stance.

## Adversarial sweep on the origin allowlist

Walked every vector in the cleaner brief.

| Vector | Behavior | Verdict |
|---|---|---|
| SSRF stepping-stone (`http://127.0.0.1`, `http://169.254.169.254`, etc.) | Name-based allowlist; only matches if the host explicitly allowlists the loopback / metadata origin. The design (lines 461-467) is explicit that DNS-rebinding and "hostname whose A record resolves to a private address" are out of scope for Phase 1 and are addressed in the forthcoming trust-on-first-bind addendum. | As designed; no hole. |
| `javascript:` / `file:` / `data:` URLs as request URL | URL parser yields `.origin === 'null'` for all three. The allowlist is built from http(s) origins (parse rejects non-http(s) at config time), so `'null'` is never present and the check rejects with `"not in the allowlist"`. Pinned in the new `Phase 1 rejects javascript:/file:/data: at request time` regression test. | Safe; pinned. |
| `javascript:` / `file:` / `data:` URLs in the **allowlist** | Rejected at `parseAllowedOrigin` with `"must use http: or https:"`. Already covered by the existing `parseAllowedOrigin rejects non-http(s) schemes at config time` unit test. | Safe. |
| Hostname normalization: uppercase (`HTTPS://EXAMPLE.COM`) | Lowercased by URL parser; allowlist of `https://example.com` matches uppercase request. | Safe. |
| Hostname normalization: trailing dot (`https://example.com.`) | Preserved by URL parser; allowlist of `https://example.com` does **not** match `https://example.com.`. This is defense-in-depth (the host can opt to allowlist both forms if needed). Pinned in the new `Allowlist match is exact: trailing dot ... does not match` regression test to catch future "normalize trailing dots" refactors. | Safe; pinned. |
| Hostname normalization: IDN / punycode (`https://日本.jp`) | Both sides canonicalize to `https://xn--wgv71a.jp` via the URL parser; matching works in either direction. | Safe. |
| IPv6 literal (`http://[::1]`) | Bracketed form is canonical; matching is exact. | Safe. |
| URL path edge cases (`..`, empty path, query-only differences) | Origin extraction strips path / query / fragment, so they do not affect membership. A request to `https://api.example.com/../etc/passwd` matches `https://api.example.com`; the server interprets the `..` per its own rules. | Safe; nothing to add. |
| Port normalization (`:443` for https, `:80` for http) | URL parser strips the default port; explicit non-default ports are preserved. Allowlist of `https://api.example.com` matches `https://api.example.com:443` (default) but not `https://api.example.com:80`. | Safe. |
| Method allowlisting (Phase 1 GET-only) | **Previously broken**: arbitrary methods passed through. **Fixed**: GET and HEAD only; everything else throws `"Phase 1 http-client admits GET-class verbs only"`. Pinned with the new `Phase 1 rejects methods beyond GET-class` regression test (using a fetch-call-counter spy as regression evidence per `skills/regression-evidence`) and a positive `Phase 1 admits HEAD as a GET-class verb alongside GET` companion test. | Fixed in this cleaner pass. |
| Redirect-following SSRF (allowed origin → metadata) | `fetch(...)` is called with `redirect: 'manual'`, so a 302 from an allowlisted origin to a disallowed one is surfaced as a 3xx response rather than followed. Already covered by the existing `makeHttpClient.request invokes fetch for allowed origins` test (which asserts `lastInit.redirect === 'manual'`). | Safe. |

## Adversarial test additions and the bugs they catch

Four tests added to `packages/daemon/test/http-client-unit.test.js` (separate test commit, `0359d1acc`):

1. `Phase 1 rejects methods beyond GET-class (POST/PUT/DELETE/PATCH)` — fails if the method allowlist regresses; a guest could otherwise gain write authority against allowed origins via POST/PUT/DELETE/PATCH/OPTIONS. Uses a fetch-call counter spy as regression evidence; reaches the spy at all means the gate failed.
2. `Phase 1 admits HEAD as a GET-class verb alongside GET` — positive test; fails if a future tightening accidentally rejects HEAD (which is GET-class by HTTP semantics and shares no-body shape with GET).
3. `Phase 1 rejects javascript:/file:/data: at request time` — pins the `.origin === 'null'` rejection path. Catches a refactor that treats `'null'` as a wildcard or short-circuits origin checks for non-http(s) schemes. Strings are assembled via template concatenation to keep the test source out of the `no-script-url` lint rule.
4. `Allowlist match is exact: trailing dot ... does not match no-dot allowlist` — pins the URL parser's trailing-dot preservation. Catches a refactor that "normalizes" trailing dots and silently widens the allowlist.

## Help-text generator (cleaner item #7)

Verified the committed `packages/daemon/src/help-text-data.js` is Prettier-clean (`yarn prettier --check` passes).

I did **not** fix the generator script in this dispatch.
The builder already routed the issue as a `message: builder → liaison` in entry `081740Z-message-builder-dacaa9.md`, recommending either (1) a row in `skills/pre-pr-checklist/SKILL.md` § Common churn or (2) piping the generator's output through Prettier as its last step.
I prototyped (2) here; it works (regenerated `help-text-data.js` matches the committed file byte-for-byte) but introduces an `import/no-extraneous-dependencies` lint error because `prettier` is not in the daemon package's `devDependencies`.
Adding `prettier` to `@endo/daemon`'s `devDependencies` would also need a `chore: Update yarn.lock` commit per `skills/yarn-lock-separate-commit`, which crosses the cleaner's "out of scope: implementing any of the deferred phases, widening the test surface beyond regression-evidence-discovered gaps" line for a non-cleanup change.
Reverted the prototype; left the routing to the liaison's `message`-entry queue.

## Cleanup nits

Walked the diff for: dead imports, leftover `console.log` in library code, unattributed TODOs.
None found.
The two `console.log` calls in `packages/cli/src/commands/http-mk.js` print the pet names the verb registered (the CLI's user-facing output) and are appropriate; library code in `packages/daemon/src/http-client.js` is silent.

## CI

PR #286 is in DRAFT state and shows 0 status checks at cleaner-result time.
The builder's previous push to the same branch also did not enqueue checks (verified via `gh api repos/.../actions/runs?per_page=200` filtered to the builder's SHA `93b3814c8` and the cleaner's SHA `0359d1ac`: no runs).
Other recent draft PRs on `llm` base do have checks (#149, #134 each have 28-29 checks), so the missing CI here is not a draft-PR policy.
Possibilities:

- GitHub Actions queueing delay on this bot's pushes (the builder noted the same observation at PR-open time).
- A workflow change that requires maintainer approval for this branch.

Either way, the cleaner cannot watch CI converge that has not enqueued.
The judge dispatch (next stage) will hit the same surface; if CI still has not run by then, the judge will need a maintainer ping or a shepherd dispatch to re-trigger.
Surfacing this here so the contractor sees it before the judge dispatch.

## Definition-of-done check

- Coverage measurably improved: 4 new adversarial tests covering surface the builder did not exercise, plus one source-fix commit closing a real Phase-1-promise drift. Daemon test count went from 22 PR-relevant tests to 26 (13 unit + 9 daemon-level + 4 CLI smoke).
- Every new test is load-bearing per `skills/regression-evidence/SKILL.md`: each names the specific regression it would catch.
- No lockfile churn (no test dependencies added).
- No dead-code-deletion commit (none warranted).
- PR is still in DRAFT state (the cleaner does not un-draft; that is the judge's role).
- This `result` entry references the dispatch's commits and the originating PR.

Self-improvement: `skills/pre-pr-checklist/SKILL.md` § Common churn (or wherever the maintainer prefers it land) gains a row reminding builders that the *cleaner* should re-read the design's *Status* / *Phase* section against the implementation, because phase-deferral drift (the GET-class method gate caught here) is exactly the kind of "the docs promise X, the code does Y" issue the jury panel would also flag and that a regression-evidence test from the cleaner avoids a fixer round on. The drift was visible in the diff itself (the comment said "GET-class" and the code did not enforce it), so the heuristic is concrete: when the design enumerates a Phase-N exclusion, grep the implementation for evidence the exclusion is enforced rather than merely commented.
