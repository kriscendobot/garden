All five phases are complete and verified. The job's three-part definition of done is met: an increment deployed and edge-verified on `minion.town`, remaining increments queued as note-carrying follow-ons, and the issue thread updated with evidence.

## Completion report — `minion-town-weblet-gateway-build`

**Context on resume.** My first pass correctly deferred (the design wasn't ready). On this reaper-requeue the design had landed: it lives in the **minion.town project repo** as `designs/weblet-gateway.md` (draft PR kriscendobot/minion.town#21) — a 4-increment decomposition. I built and shipped its **first independently-deployable increment** end to end.

**Increment 1 — the reachability layer (DNS + wildcard on-demand TLS + `endo-gateway` listener), deployed and edge-verified LIVE.**

- **Built** (`src/endo/gateway/`, under `src/endo` transplant discipline per design §2): a DNS-label base32 codec, the `hash→record` vhost-table seam (Increment-1 seed source), the exact origin-isolation header floor (§5.2), the request path (`/gateway/ask` fail-closed on-demand-TLS seam + placeholder serving + clean 404), env config, and the entrypoint. **17 tests** (base32 RFC vectors/round-trip/fail-closed; ask 200/404; placeholder floor + no cookie; apex/garbage fail closed). `typecheck` + `build` clean; 148 app tests pass (only the pre-existing, unrelated `deploy/thunks/siwe` viem failures remain — confirmed failing on the base).
- **Deploy artifacts**: `endo-gateway.service` (loopback :3002, dedicated user, ships inside the app artifact), `deploy-endo-gateway.sh`, `deploy-weblet-dns.sh`, `conf.d/weblet-gateway.caddy` (`tls { on_demand }` → :3002), root Caddyfile global `on_demand_tls { ask }`, CD wiring in `deploy.yml`, and DEPLOYMENT.md § Weblet gateway.
- **Merged + deployed**: PR kriscendobot/minion.town#22 → `main` `2b83906`; CD run `30727267159` green (app → endo-gateway → caddy). Added Route53 `*.minion.town A 13.56.17.18` (one-time, outside CD).
- **Edge-verified** (2026-08-02): unknown hash `deadbeef.minion.town` → TLS handshake **refused** (ask 404 → no cert, no ACME); seeded hash → **HTTP/2 200** placeholder carrying the full CSP/CORP/COOP/XFO/nosniff/referrer/permissions floor, `no-store`, **no** `set-cookie`, **no** CORS; per-host Let's Encrypt cert issued for the exact SNI; apex `https://minion.town/` unaffected (302, own cert). Fail-closed stays intact even with a live weblet present.

**Remaining increments queued** — a serial, halt-on-failure orchestration `minion-town-weblet-gateway-increments` (record at `jobs/orch/`, three children parked in `jobs/plan/`), each carrying the #58 ISSUE NOTE verbatim: Increment 2 (CAS content plane, §5), 3 (powers plane, §6), 4 (publish + stubbed charge, §7). The `garden-orchestrate` watcher drives them.

**Reported**: issue kriscendobot/garden#58 comment `5154476328` (SHA/PR + probe evidence); maintainer messaged with full status.

**Follow-ups / flags (none blocking):**
1. I **self-merged PR #22 to prod `main`** under the job's explicit "deployed… without a further maintainer gate" authorization — **no panel/gauntlet ran** on it. If the formal review is wanted: *run the gauntlet on kriscendobot/minion.town#22*.
2. Design PR kriscendobot/minion.town#21 is still a **draft** with 5 open questions (§9) — none blocked Increment 1; a review/merge there is welcome.
3. A **test seed** (`/etc/endo-gateway/seed.env`, id `a3f1…7f80`) keeps one placeholder weblet live as evidence; **Increment 2 removes it** when the real CapTP-backed vhost table lands (steady-state default is no seed → all hashes fail closed).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-weblet-gateway-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 210 tokens (17254089 cached reads)
- Output: 135267 tokens
- Cost: $14.3528135
- Wall-clock: 2213s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
