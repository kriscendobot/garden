---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (branch `main`, commits 194aa98 + 65799f2 + 49a48f7).

`src/config.ts` flipped `endoSock` from the default `/run/endo-daemon/endo.sock` to `""`, and `src/http.ts` now selects `makeMemoryGuestService` whenever it is empty. The old comment ("The default preserves the production socket contract for local or partially deployed environments") named exactly the case this breaks: an environment that loses or never sets `ENDO_SOCK` no longer surfaces a loud, retryable daemon-unavailable error — it silently serves guest tools from a **non-durable in-memory** host, so `guest_write_text` etc. appear to succeed and vanish on restart. Production is currently protected only by the one `Environment=ENDO_SOCK=` line in `deploy/aws/systemd/minion-mcp.service`; nothing in the app enforces it.

Task (fixer):
- Gate the in-memory fallback on an explicit local/dev signal rather than "unset". Suggested shape: fall back only when `NODE_ENV !== "production"`, or require an explicit opt-in (e.g. `ENDO_GUEST_BACKEND=memory` / `ENDO_SOCK=memory`); with `NODE_ENV=production` and no socket, keep the previous loud posture. Pick one and state the reasoning in the commit message.
- Add a vitest case for the guarded posture (production + unset socket ⇒ no silent memory host), alongside the new `test/endo-guest-memory-http.test.ts` which covers the dev posture.
- While in `src/http.ts`: the `WEBLET_SITES_LIVE=1` + `GATEWAY_STORE_DIR` branch still passes `sockPath: config.endoSock` unguarded, so an empty socket now produces a degraded-mode log reading `ENDO_SOCK=` with an empty value. Make that path either skip the install or report the empty-socket cause clearly.
- Fix the doc drift the same change creates: `README.md` § "The guest tools and admission" still asserts "`ENDO_SOCK` defaults to `/run/endo-daemon/endo.sock`" and "The server never falls back to the retired in-memory minion surface" — both now wrong. Check `DEPLOYMENT.md` (~line 254, 303) for the same claim and correct it to describe the real socket-vs-memory selection rule you land.
- Run `npm run typecheck` and `npm test` before pushing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-30T05:51:00Z
