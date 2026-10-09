---
gate: go-ahead
priority: normal
posted_by: designer
posted_at: 2026-10-09T21:51:33Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# IronHorse: Proxy [[Call]]/[[Construct]] flags survive revocation (XS 10.0.0 #1702/#1704)

Repo: endojs/endo-but-for-bots, base `llm` (frozen `llm-<sha>` snapshot per skills/frozen-base-branch). Design: designs/ironhorse-moddable-10-0-0-port-plan.md on branch design/ironhorse-moddable-10-0-0-port-plan (endojs/endo-but-for-bots; design PR from job moddable-10-0-0-ironhorse-port-plan-20261009). Read the design first; its classification table and § Oracle and ratchet impact are normative for this child. Open a DRAFT PR via ensure-pr.sh; completion stages the gauntlet.

If you genuinely finish but do not achieve the gated outcome below, end your report with the exact lines `<<<GARDEN-ORCHESTRATION-FAILED>>>` then `<<<GARDEN-JOB-COMPLETE>>>`.

Record [[Call]]/[[Construct]] presence on `ProxyData` at proxy creation (`property/proxy.rs`), persist it through `snapshot_rows.rs` `ProxyRow`, `persist.rs`, `restore.rs`, and use it in `function.rs` `slot_is_callable` / `slot_is_constructor` and `proxy_construct_refused`, instead of chasing the (revoked, nulled) target. Add the GetFunctionRealm revoked-proxy TypeError in `get_prototype_from_constructor`. Update `ironhorse-262/tests/xs_departures.rs` (revoked-arrow-proxy `new` row) and `new_on_non_constructors.rs` comment.

Gated outcome: `Proxy/create-target-is-revoked-function-proxy.js`, `Proxy/revocable/target-is-revoked-function-proxy.js`, `Function/internals/Construct/base-ctor-revoked-proxy.js` pass in both modes against the current oracle; no new divergence; snapshot round-trip test for a revoked callable proxy. Size M.
