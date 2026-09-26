The PR is a DRAFT against `llm`, no inbox messages. The build is complete and verified.

## Completion report

**Job:** Build the `@endo/fetch` unconfined plugin on `endojs/endo-but-for-bots` (base `llm`) from the endo-fetch design (draft PR #722), Phases 1–3.

**Delivered — draft PR [#723](https://github.com/endojs/endo-but-for-bots/pull/723)** (base `llm`, DRAFT), two commits on `build/endo-fetch-plugin`:

- **Phase 1 — package + durable policy.** New `packages/fetch` (`@endo/fetch`), an unconfined caplet: `make(powers, context, { env })` resolves a `fetch-store` VFS directory (and optional `fetch-policy-authority`) by name, composes the merged `makeHttpClientAndControl` (#566), and returns a `FetchService` exo handing out `client()` (guest-facing `HttpClient`) / `control()` (integration `HttpClientControl`). Durable `config.json` on `@endo/platform/fs/extended`, write-then-`move`, serialized; store-not-env authoritative across restarts; revoked revives revoked. Mirrors the `@endo/reminder` plugin (#721).
- **Phase 2 — TOFU durability.** Added a backward-compatible persistence seam to `@endo/exo-http-client`: `initialBindings` (reconstitutes the trust-on-first-bind table) and `onPolicyChange(snapshot)` (fires after any durable mutation, including request-time pins — the one seam that can observe them), keeping the package platform-pure. `bindings.json` persistence.
- **Phase 3 — integration + revival.** README `@pins` pinning/granting recipe; restart-survival demonstrated end-to-end in tests.

**Verification:** `@endo/fetch` — 8/8 tests pass (fetch/deny, restart reconstitution with identical policy, revive-as-revoked, TOFU pin surviving restart and staying revocable). `@endo/exo-http-client` — 32/32 existing tests pass unchanged; lint+`tsc` clean. Added a changeset (`@endo/fetch` + `@endo/exo-http-client` minor).

**Open questions surfaced in the PR body** for maintainer review: (1) package name (`@endo/fetch` vs `@endo/confined-fetch` vs a module inside `@endo/exo-http-client`); (2) policy-authority re-resolution per referral vs once at `make()`.

**Follow-up / deferred:** Phase 3's `makeHttpTool` binding belongs to daemon-agent-tools Phase 3.6 (not yet landed — `@endo/agent-tools` has `git-tool`/`shell-tool` but no `http-tool`). The design frames it as surviving unchanged from that phase and binding this plugin's client, so I deferred it rather than fork another design's deliverable; flagged explicitly in the PR. PR kept DRAFT per design-stage convention.
