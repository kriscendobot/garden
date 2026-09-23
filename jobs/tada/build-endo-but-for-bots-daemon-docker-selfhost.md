Inbox empty — no reply yet, and the maintainer's decision is a genuine external dependency (its reply will spawn a fresh job via dead-letter-promote). My responsible work for this claim is complete. Final report:

---

## Completion report: `build-endo-but-for-bots-daemon-docker-selfhost`

**Outcome: I did NOT open a 4th PR — three overlapping open PRs already implement this feature, and the maintainer previously deferred the exact approach the design record describes. I implemented and verified the core work, preserved it on a branch, and surfaced the situation to the maintainer for adjudication.**

### What I found (the reason I stopped short of a PR)
Per the builder norm "verify no open PR already implements the issue; skip and surface if a duplicate would result," I checked before opening. Three overlapping open PRs on `endojs/endo-but-for-bots` already implement Docker self-hosting:
- **#134** (kriscendobot, DRAFT, base `llm`, **CHANGES_REQUESTED**, stale since 2026-06-28) — comprehensive: docker/ + `ws-gateway.js` CIDR gate + tests + static serving + CI workflow.
- **#608** (kriscendobot, non-draft, base `master`, MERGEABLE, created 2026-07-05) — docker/ files only; **missing clause 4 (remote auth)**.
- **#568** (0xpatrickbot, DRAFT, base `llm`, CONFLICTING) — third-party attempt.

Decisively: kriskowal's review on **#134** (2026-05-13) explicitly paused this work — *"We need to make progress on the Endo Gateway concept before we can sensibly run under Docker. The Gateway subsumes the ws-gateway.js here."* The `@endo/gateway` package skeleton has since landed and issue #173 is closed, but the daemon still runs on `ws-gateway.js`. So the design record (`daemon-docker-selfhost.md`, still "Not Started") describes the very `ws-gateway.js` approach the maintainer said was being subsumed. Opening a 4th PR on that foundation would be doubly wrong.

### What I implemented and **verified** (real-execution evidence)
Even though I withheld the PR, I completed and tested the missing core (clause 4), on base `llm`:
- **Wired `cidr.js makeAddressChecker` into `ws-gateway.js`** (it was built + unit-tested but never wired — the gateway admitted all connections). Now: localhost-only by default; `ENDO_GATEWAY=remote` / `ENDO_GATEWAY_ALLOWED_CIDRS` opt-in; disallowed clients closed with the README's documented `"Only local connections allowed"` (code 1008); TLS warning in remote mode. `daemon-node.js` reads the two env vars.
- **New `packages/daemon/test/ws-gateway.test.js`** — 5 in-process tests (localhost admit, IPv4-mapped-IPv6 admit, non-local reject with the documented reason, remote-mode admit, CIDR allowlist admit/reject).
- **Verification evidence** (ran in the project worktree with a real `yarn install`):
  - `ava test/ws-gateway.test.js test/cidr.test.js` → **23 tests passed**.
  - **Regression-proven**: neutralizing the gate (`if (false)`) made exactly the two reject tests fail; restoring it made them pass again.
  - `tsc` (lint:types) → **exit 0, 0 errors**; `eslint` on the three changed files → **clean**; `prettier --check` → clean.
  - Ran the real Familiar bundle (`yarn workspace @endo/familiar step:bundle`) → produced `endo-daemon.mjs`/`worker-node.mjs`/`endo-cli.mjs`, and inspected how the daemon bundle loads better-sqlite3's native addon (via `bindings`), which informed the Dockerfile's addon staging.
- **Docker deliverables authored** (`docker/Dockerfile` two-stage build, `docker-entrypoint.sh` foreground PID-1 with XDG-derived state paths + `ENDO_WORKER_SUBPROCESS_PATH` at the worker bundle, `docker-compose.yml` + `Caddyfile` TLS example, `endo-cli-wrapper.sh`, `docker/README.md`, root `.dockerignore`) and a changeset. **Not verified** end-to-end: no Docker daemon is available in this environment and better-sqlite3's native build fails here (sandbox), so the image build/run is unverified by construction — I flagged this honestly in the PR-candidate and to the maintainer.

### Where the work lives
Committed and pushed (no PR) to branch **`wip/daemon-docker-selfhost-gateway-remote-auth`** on `endojs/endo-but-for-bots`, off `origin/llm` tip (1132289). Ready to cherry-pick/rebase onto whichever PR becomes canonical.

### Surfaced to the maintainer
Two messages via `message-user.sh` (→ liaison → maintainer inbox): the duplicate landscape, the ws-gateway-vs-`@endo/gateway` architecture question, my verified findings, and a recommendation (consolidate to one PR; if ws-gateway is acceptable now, refresh #134 since it already has everything; otherwise rebuild on `@endo/gateway`). I offered to execute either direction.

### Follow-ups (for the maintainer's decision)
1. **Pick the base architecture**: wire Docker remote-auth into `ws-gateway.js` (current design) vs. `@endo/gateway` (2026-05 steer, now has a skeleton).
2. **Consolidate the 3 PRs** (close the losers).
3. Real fact worth noting regardless of choice: the **gateway-bearer-token-auth design is marked "Complete" but its ws-gateway.js wiring was never landed** — my branch closes that gap.
4. If ws-gateway is chosen: add the CI test kriskowal asked for on #134, and update the stale design record.

The maintainer's reply will re-enter as a fresh actionable job (dead-letter-promote), so no intent is lost.
