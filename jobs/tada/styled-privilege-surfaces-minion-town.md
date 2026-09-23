Job complete. Final report:

---

**Phase C — styled privilege surfaces for minion.town — done and pushed to `main` (`0ff042b`).**

**Context reconciled on resume:** after the reaper requeue I found Phase A (`build-account-store-minion-town`) had landed on `main` in parallel, already providing a `GET /account` endpoint (`src/auth/account-endpoint.ts` + `resolveAccountView`) and `accountGateSharedSecret` config. My interrupted session had branched off the pre-Phase-A base and built a duplicate. I reset onto Phase A and **rebuilt Phase C on top of it** rather than duplicating.

**What I built (all 4 job items):**
1. **Landing role panel** (`deploy/aws/www/index.html`) — one `fetch("/account")` renders role, plain-words capability (scopes → "see the town's status" / "read the roster" / "summon minions"), and the elevation line. Fully progressive.
2. **`error.html`** oauth2-proxy template — styled replacement for the built-in 403/404/500 fallback with a back-to-sign-in action; `oauth2-proxy.cfg` comment updated.
3. **Insufficient-privilege 403 page + `requireRole` gate** (`src/auth/privilege-page.ts`) — app-served styled page (identity/role/required/elevation), scope-superset check so an admin's static overlay passes a role gate; MCP tool-level `insufficient_scope` errors left untouched.
4. **`ELEVATION_CONTACT`** config rendered into surfaces 1 & 3 (linked for mailto/URL, text otherwise).

**Supporting wiring:** extended Phase A's `/account` with `elevation_contact`; Caddy `/account` route; provider-header injection (`X-Auth-Request-Provider` in alpha-config + pre-token-gen Lambda now stamps `idp` on the ID token); dedicated `minion/account-endpoint-token` secret via new `deploy-account-endpoint-secret.sh`; systemd unit + `.env.example` vars; DEPLOYMENT.md Phase C section + Phase 11 row + deploy order.

**Verification:** typecheck clean; 43 relevant app tests + lambda self-test green (the 2 failing test *files* are the SIWE thunk's own pre-existing `viem` gap, untouched by this change). Regression evidence demonstrated for the shared-secret gate. **Actual headless-Chromium runs** confirmed rendered DOM of: the role panel (role `guest`, capability text, mailto elevation link), the 403 page, `error.html`, and the **progressive fallback** (all fetches fail → panel hidden, static greeting stands).

**Per maintainer directives (2026-07-11):** `ELEVATION_CONTACT` ships as an obvious placeholder (`TODO: set ELEVATION_CONTACT`) — **swap for the real value before relying on the surfaces.** Live end-to-end verification against a real `/account` backend and role-based 403 on minion.town is **deferred pending Phases A+B live** — a follow-up verification job should run once they are up, plus the deploy of Phase C's artifacts (which I could not run; no AWS deploy from here).

**Follow-ups:** (1) maintainer sets the real `ELEVATION_CONTACT`; (2) deploy Phase C artifacts and run the deferred browser check on live minion.town; (3) sent the liaison a self-improvement note about re-fetching a shared push-branch before/after resume on parallel phased builds.
