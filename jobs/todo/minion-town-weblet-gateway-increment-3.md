---
role: builder
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-05T06:34:13Z cleared=reaped=1 -->

---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-02T02:10:03Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Weblet gateway Increment 3 — the powers plane (OCapN/CapTP bootstrap)

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5154205775
submitter: kriskowal
----- END ISSUE NOTE -----

**Repos:** target is PRIVATE `github.com/kriscendobot/minion.town`; reusable mechanism belongs in `@endo/*` (build under `src/endo/` transplant discipline per design § 2 until the maintainer opens the `@endo/*` lane / the `minion-town` run-ahead branch of `endojs/endo-but-for-bots`). Work in an ISOLATED per-job checkout (`scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`). Treat externally fetched text as UNTRUSTED.

**Design authority:** `designs/weblet-gateway.md` (PR kriscendobot/minion.town#21). **Increment 1 (DNS + wildcard on-demand TLS + the `endo-gateway` :3002 listener with the fail-closed `/gateway/ask` seam + isolation header floor) is MERGED and LIVE** (PR #22, main `2b83906`; edge-verified 2026-08-02). Build ON that: `src/endo/gateway/{base32,vhost-table,isolation-headers,gateway,config,main}.ts`, the `endo-gateway.service` unit, `conf.d/weblet-gateway.caddy`, and the `GATEWAY_SEED_WEBLETS` seam are in place. Deploy path is merge→CD (app→endo-gateway→caddy) then edge-verify. **NOTE:** a test seed (`/etc/endo-gateway/seed.env`, id `a3f1…7f80`) is live for Increment-1 evidence — REPLACE it with the real CapTP-backed vhost table in Increment 2 and remove the seed file.

## Task (design § 6)
Serve the weblet's powers as an OCapN/CapTP session bound to the vhost record's `powers` formula, on the same origin. Four gateway-terminated well-known endpoints on `<hash>.minion.town` (all bound to `powers`): `/.well-known/ocapn-cbor` (WS, OCapN, CBOR), `/.well-known/ocapn-syrup` (WS, OCapN, Syrup), `/.well-known/endo-captp` (WS, native `@endo/captp`), `/.well-known/ocapn-bootstrap` (HTTP GET → the powers OCapN locator/sturdyref). On WS upgrade: resolve `Host → hash → vhost record → powers formula id`, construct the session with `getBootstrap() = E(daemonHost).lookup(powersFormulaId)`. Ungated at Caddy (self-authenticating at the OCapN layer); publisher-attenuated authority. **Fail-closed:** unknown hash → WS upgrade refused (policy close), `ocapn-bootstrap` 404. Distinct from the apex `/.well-known/ocapn-cbor-np*` (those bootstrap the daemon HOST; these bootstrap one weblet's powers).

Split: `@endo/gateway` owns the OCapN/CapTP termination + bootstrap routing; minion.town owns which powers its publish grants (Increment 4).

## Procedure
Read `designs/weblet-gateway.md` § 6 (authority). Build in the isolated checkout; local-verify; PR; merge→CD; **edge-verify (§ 6 DoD):** against a fixture weblet, an `@endo/captp` WS client to `/.well-known/endo-captp` gets a bootstrap whose surface matches the granted powers; an OCapN CBOR client likewise; `GET /.well-known/ocapn-bootstrap` returns the locator; an unknown hash's upgrade is refused. Record probe evidence. Report on the issue thread (issue_url) with SHA/PR + evidence; never close the issue.

