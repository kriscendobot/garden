All work is complete. Inbox is empty; nothing outstanding.

## Completion report

**Job:** Implement B2 from the merged design ([kriscendobot/minion.town PR #13](https://github.com/kriscendobot/minion.town/pull/13), `designs/mcp-daemon-guest-tools.md`) on top of B1.

**Delivered:** PR **[kriscendobot/minion.town#15](https://github.com/kriscendobot/minion.town/pull/15)** (branch `feat/endo-guest-mcp-tools-b2`, off `origin/main` at the merged B0+B1 commit `3765d98`). Worked in an isolated project worktree keyed to this job.

### What changed
- **`src/endo/guest-tools.ts`** (new) — the `@endo/mcp`-seed registration seam: mounts `guest_status` / `guest_write_text` / `guest_read_text` from a caller's facet. Lockdown-free (imports nothing from `@endo/*`); § 6 error taxonomy — `PetNameError`/`DaemonUnavailableError` → clean `isError`, absent name → a clean "no such name".
- **`src/endo/guest-service.ts`** (new) — lazy, self-healing socket→grant-site bridge; a between-call daemon restart is transparently reconnected once.
- **`ENDO_SOCK` optionality gate** (`config.ts`, `index.ts`, `http.ts`) — guest tools + the HardenedJS CapTP stack load **only** when `ENDO_SOCK` is set; unset ⇒ byte-for-byte the pre-Endo app (no `lockdown()`). `index.ts` runs `@endo/init` before the app graph when the gate is open.
- **Session identity pinning** (`http.ts`) — a session is bound to the `iss+sub` that initialized it; reusing its session id under another identity is rejected `403`.
- **Per-call `mcp/guest` revalidation** (`server.ts` `authorizeGuest`) — re-resolves effective scopes on every guest call (suspension bites within the TTL) + re-checks the pin. Added `SCOPES.GUEST`; toy tools retained during migration.

### Validation (local evidence — green)
`npm run typecheck` + `npm run build` clean. New tests all pass: **unit** (10, tool round-trip/errors + the admission guard), **HTTP** (3, gate-closed toy-only surface + pinning 403), **lockdown smoke** (2, express+MCP+CapTP coexist under `@endo/init`, dead socket → retryable `isError`). Full suite: **131 passed, 3 skipped**. The live `write→read→restart→read` round-trip against a real daemon is written into `test/endo-daemon-integration.test.ts` and runs under `ENDO_CHECKOUT`; it **skips on this box** (no prebuilt Endo checkout — building it is the CI-provisioned path, identical to how the B1 integration suite skips locally).

### Scope honored
Did **not** deploy and did **not** begin B3. The grant wiring (`ROLE_SCOPES.guest` + Cognito + PRM + client scopes) is deliberately left to B4. B2 evidence is green, so the orchestration's halt policy is not triggered.

### Follow-ups / notes
- 2 pre-existing test-suite failures (`deploy/thunks/siwe/*`) fail on a missing `viem` dep in that sub-package — present on the baseline before my changes, untouched by B2.
- The full daemon round-trip and the deployed-edge PKCE validation land with **B3** (daemon standup on the box), where a real `endo-daemon.service` and `ENDO_CHECKOUT` exist.
