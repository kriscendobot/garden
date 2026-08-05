Seeded and live-tested a two-file CAS fixture at `f45ulx...kszzq.weblet.minion.town`.

Verified:

- Exact bytes, Content-Type, ETag, immutable caching, HEAD, and conditional 304.
- Unknown/traversal paths and non-GET/HEAD methods fail closed with 404 and the full isolation-header floor.
- No `Set-Cookie` or CORS allowance on weblet responses; oauth2-proxy cookies remain host-scoped.
- The active service unit matches the repository exactly; namespace/store settings are correct, and retired seed configuration is absent.
- Apex, www, GitHub IdP, and SIWE IdP retain distinct exact-host certificates; unknown weblets fail TLS closed.

No reconciliation changes were needed. Findings posted to https://github.com/kriscendobot/minion.town/pull/25#issuecomment-5193957948. No repository files changed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-0bdfc2c-weblet-edge-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 307s

<!-- garden-usage-end -->
