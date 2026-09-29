Verified the checklist item: clip bytes bypass CapTP on cache misses.

- The gateway reads the vhost record and streams the manifest/blob directly from its filesystem CAS ([routing](https://github.com/kriscendobot/minion.town/blob/e922c49489967cb389dbd907a3d947a801410d91/src/endo/gateway/gateway.ts#L194-L232), [serving](https://github.com/kriscendobot/minion.town/blob/e922c49489967cb389dbd907a3d947a801410d91/src/endo/gateway/content-server.ts#L79-L125), [filesystem adapter](https://github.com/kriscendobot/minion.town/blob/e922c49489967cb389dbd907a3d947a801410d91/src/endo/gateway/content-store.ts#L170-L198)). It does not call readable-tree `text()` or `streamBase64()`.
- This is a dedicated gateway CAS at `GATEWAY_STORE_DIR`, populated by `minion-mcp`, not the daemon’s separate `<statePath>/store-sha256/<sha256>` CAS ([Endo path wiring](https://github.com/endojs/endo-but-for-bots/blob/1706e63247fb2c23b767f24fa1bd4b35d575089e/packages/daemon/src/manager-persistence-powers.js#L136-L153), [Endo CAS implementation](https://github.com/endojs/endo-but-for-bots/blob/1706e63247fb2c23b767f24fa1bd4b35d575089e/packages/daemon-cas/src/content-store.js#L53-L107)).
- Only legacy records lacking `contentRoot` make a CapTP call to obtain the `front` digest; even then, response bytes come from the filesystem CAS. Current publishing always persists `contentRoot`.
- Live read-only evidence: a fresh-query request returned HTTP 200 through Caddy, 135 bytes, with the body SHA-256 exactly matching its ETag; matching `If-None-Match` returned 304.
- Verification: 31 targeted gateway/content-store tests passed, including serving a live `@sites` record without a powers plane.
- If convergence on the daemon CAS is desired, the minimal follow-up is a read adapter for its flat SHA-256 layout plus Endo readable-tree manifest traversal and persisting the tree root during registration. Granting the gateway direct daemon-CAS access would broaden its ambient authority to every daemon blob, so a partitioned/export CAS is safer. Current integrity relies on hash-at-intern, validated manifests, read-only gateway access, and trusted writers; blobs are not re-hashed while streaming.

Posted the definitive evidence to [kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58#issuecomment-5887521237). No code or production changes were made.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-clip-cas-data-plane-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 276s

<!-- garden-usage-end -->
