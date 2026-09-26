Everything is complete. Inbox empty, build artifacts cleaned. Final summary:

## Completion report

Implemented **B0 + B1** of `designs/mcp-daemon-guest-tools.md` in `kriscendobot/minion.town`, on branch `mcp-daemon-guest-b0-b1` → **PR #14**. B2 left untouched. No deploy performed.

**B0 — pin + port the CapTP client**
- Pinned `endojs/endo-but-for-bots` @ `llm` **`f66505034aaa54ac46294347b2bf0e14655b088a`** (the commit the design method-verified against) in both `deploy/aws/scripts/deploy-endo-daemon.sh` (`ENDO_COMMIT`) and `src/endo/captp-client.ts` (provenance header + `PINNED_ENDO_COMMIT`) — so app-client-commit == daemon-artifact-commit is one auditable fact.
- Ported the thin netstring-CapTP client (`client.js` + `connection.js`) as `src/endo/captp-client.ts` over five published `@endo` deps pinned to the daemon's lockfile versions (`@endo/captp@4.5.1`, `netstring@1.1.1`, `stream-node@1.2.1`, `eventual-send@1.5.0`, `stream@1.3.1`) plus `@endo/init@1.1.13` (the CapTP stack is HardenedJS — the consumer inits; the library doesn't lockdown). Added `src/endo/vendor-endo.d.ts` (captp ships no types).
- Added `deploy/aws/systemd/endo-daemon.service` (§ 4.1 unit) + the § 4.2 deploy pipeline; not wired into CD (that's B3).

**B1 — socket adapters + Gate-2 wiring**
- `src/endo/guest-control.ts`: the one grant site (`composeFacet`) + `GuestControl` over an abstract `GuestHostPowers`; pure (no `@endo` import) so it unit-tests without lockdown.
- `src/endo/root-host-socket.ts`: one CapTP host connection, two views — `RootHost` (closes `root-ctl.ts`'s Gate-2 stub) and `GuestHostPowers`.
- `src/endo/root-ctl.ts`: `connectRootControl` now connects the real adapter (dynamic import keeps logic tests lockdown-free); `endo-root-host.sh` precondition note updated.
- `src/endo/guest-memory.ts`: in-memory fake mirroring `root-host-memory.ts`.

**Test / typecheck evidence (exact)**
- `npm run typecheck` (`tsc --noEmit`): **clean**.
- Endo suites with `ENDO_CHECKOUT` set: **29 passed** — `endo-captp-client` (3: netstring framing + real-CapTP round-trip over UDS), `endo-guest-control` (11), `endo-root` (13, unchanged), `endo-daemon-integration` (2: **provide → write → read → RESTART → read against a real `endo run-daemon`**).
- `npm test` (no `ENDO_CHECKOUT`): **116 passed, 2 skipped** (integration suite skips). The 2 failing `deploy/thunks/siwe/*` suites are pre-existing (missing `viem`), unrelated to this change.

**Two daemon-reality findings recorded in code + the PR (for B2/B3):**
1. A guest's directory lives on its **AGENT** facet, not the mail HANDLE `provideGuest` returns (whose return is only the agent on first creation). The adapter names both (`provideGuest(handle, { agentName })`) and resolves the durable agent via `lookup(agentName)` — the § 4.3/4.4 `E(guest).writeText` sequence needs this correction.
2. The daemon needs **native `better-sqlite3`**, so the § 4.2 "pure JS" deploy claim needs a prebuild step.

Follow-ups: B2 (mount `guest_*` tools + session identity pinning) and B3 (run `deploy-endo-daemon.sh`) proceed per the design's serial/halt orchestration.
