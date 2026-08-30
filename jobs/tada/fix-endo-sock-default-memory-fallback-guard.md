Empty inbox. Job complete.

## Completion report

**Job:** `fix-endo-sock-default-memory-fallback-guard` — gate the in-memory guest fallback in `kriscendobot/minion.town` so a lost/unset `ENDO_SOCK` in production can no longer silently serve non-durable in-memory guest tools.

**Pushed:** `199a061` directly to `kriscendobot/minion.town` `main` (rebased over `89d9e67`, CI-clean locally).

**What changed:**
- **`src/config.ts`** — the selection is now made in config via a new `selectGuestBackend()` and a new `Config.guestBackend: "socket" | "memory"` field, gated on an explicit local/dev signal instead of bare `ENDO_SOCK` truthiness. Precedence: (1) explicit `ENDO_SOCK=memory` / `ENDO_GUEST_BACKEND=memory` → memory in any env (the only route under production); (2) a concrete `ENDO_SOCK` path → socket at that path; (3) unset → under `NODE_ENV=production`, socket at the default `/run/endo-daemon/endo.sock` (loud, retryable daemon error preserved), otherwise the in-memory host.
- **Reasoning (per task):** chose `NODE_ENV` as the discriminator because the `minion-mcp` systemd unit already sets `NODE_ENV=production`, so the loud posture is restored with zero extra unit config; defaulting the production socket to the same path the unit pins means a deploy that drops its `ENDO_SOCK` line still fails loud. An explicit `=memory` opt-in remains as a deliberate escape hatch.
- **`src/http.ts`** — guest-service selection and the boot log now branch on `config.guestBackend`; the `WEBLET_SITES_LIVE=1` branch no longer passes an empty `ENDO_SOCK` into `installDaemonWebletRegistry` (which logged a bare `ENDO_SOCK=` and failed) — with the in-memory backend it now skips the install and reports the degraded, non-serving scaffold with the empty-socket cause named.
- **`test/config.test.ts`** — 5 new cases: production+unset ⇒ socket (no silent memory host), dev+unset ⇒ memory, concrete path ⇒ socket, and both explicit `=memory` opt-ins under production. Existing dev-posture HTTP test (`endo-guest-memory-http.test.ts`) unchanged and still green.
- **`README.md`** and **`DEPLOYMENT.md`** — corrected the now-false claims ("`ENDO_SOCK` defaults to `/run/...`", "never falls back to the retired in-memory surface") to describe the real socket-vs-memory selection rule.

**Verification:** `npm run typecheck` clean; `npm test` → 287 passed / 5 skipped (daemon-integration), including the new `config.test.ts` (17 tests, +5).

**Follow-ups:** none required. Note the escape-hatch precedence: `ENDO_GUEST_BACKEND=memory` wins even if a real `ENDO_SOCK` path is also set (contradictory config resolves to the explicit backend request) — deliberate and documented in the code comment.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-sock-default-memory-fallback-guard.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2485574 cached reads)
- Output: 18857 tokens
- Cost: $2.47567
- Wall-clock: 286s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
