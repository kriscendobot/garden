Inbox empty. This was a READ-ONLY assessment — no garden code changed, so there is nothing to commit or push to `main2`. The deliverable is this report plus the memory update.

---

## dckc POWERS-weblet audit — minion.town endo-gateway (READ-ONLY)

**Job:** `minion-town-dckc-powers-weblet-audit-20260916` · host `i-0380cd68b90020fad` · all evidence gathered fresh via SSM Run Command (read-only), 2026-09-16.

### What I did
Re-scanned `/var/lib/endo-gateway/store/vhosts/`, fully identified both dckc-owned POWERS weblets, read the *deployed* serve-path code (`dist/endo/gateway/*.js`), live-probed both weblet hostnames at loopback `:3002` **and** the public Caddy edge, and resolved the powers pet names in the daemon top-host for defense-in-depth.

### Fresh scan (unchanged from priors)
54 active records · 20 dckc-owned (sub `8929a9ae-…`) · **exactly 2 dckc-with-powers** · 4 store-wide powers records. The three de-registered records (`f1d754fc…`, `fe0a8e60…`, `09201a3162…`) stay **ABSENT** from the active store and present in `vhosts-revoked-20260812/`. Containment intact — I did **not** re-arm anything.

### The two weblets — full identification

| id | powers | label | schema | created |
|---|---|---|---|---|
| `806fc2ea…5a9f` | `"counter"` | `qbx4f2xd…ocap.site` (matches the surfaced hint) | `{contentRoot, owner, powers}`, **no directoryId** | 2026-08-13 13:03Z |
| `c016601e…6b2e` | `"@none"` | `yalgahxp…ocap.site` | `{contentRoot, owner, powers}`, **no directoryId** | 2026-08-12 22:58Z |

Both share the **same** `contentRoot 31a85b3c…` (that manifest blob does exist under `blobs/31/`). Both use the **old pre-`kriscendobot/minion.town#51` schema** (a `powers` **string** field; the current schema is `{directoryId}`/`{contentRoot}`).

### Authority each actually confers: **ZERO**
The load-bearing fact — the deployed vhost validator (`vhost-table.js` `validateVhostRecord`) opens with:
```js
if (raw === null || typeof raw !== "object" || "powers" in raw) return undefined;
```
The mere **presence of a `powers` key is a poison pill**: the whole record resolves to `undefined` → 404. No serve path reads `record.powers` anywhere; the old top-host caller-string resolver (`powers-source.js`) is **gone** from dist — the powers plane (`powers-plane.js`) keys **only** off `record.directoryId` and reads the directory's `back` cap, refusing the WS upgrade when `directoryId` is absent (it is, for both).

**Live-verified** (observed, not inferred): both hosts return `/` → **404 "no such clip"**, `/.well-known/ocapn-bootstrap` → **404**, at loopback `:3002` **and** the public edge; captp is generic 426. Defense-in-depth: daemon top-host resolves `counter` → `Object[Alleged:Counter]{}` (a plain increment exo), `@none` → null power — **neither is `@agent`/EndoHost** (`@agent` exists in the pet list but neither weblet names it).

### Posture verdict: **WITHIN the authorized 08-27 posture**
The powers plane is ENABLED (`GATEWAY_ENDO_SOCK` armed) — the authorized open-plane state of `kriscendobot/garden#58`; the containment drop-in was renamed `zz-containment-20260812.conf.disabled-issue58` on **Aug 27 23:36**, precisely the 08-27 authorization event. Both weblets are dckc's own experiments and confer nothing beyond what the open plane already permits — in fact nothing at all, because the current schema hard-rejects them.

### Security-item intersection
These two records **corroborate** (do not newly breach) the 2026-09-04 security review's open operator item on the untracked containment drop-in — they are exactly the "back-only-attenuated, lower risk" legacy `powers`-string class, and demonstrate the validator actively neutralizes them. No other open item intersects.

### Recommendation (recommend only — nothing de-registered)
**Catalogue BOTH as EXPECTED / known-inert legacy dckc experiments.** No de-registration is needed for containment: the validator already renders them unservable. I surfaced the assessment and one optional, cosmetic-only deciding question to the maintainer inbox: whether to run a hygiene sweep moving stale legacy `powers`-string records into a `vhosts-legacy-*` dir (store tidiness, not security). Awaiting that call — I did not post such a job.

### Follow-ups
- None required. If the maintainer wants the hygiene sweep, that becomes a separate (write) job.
- Memory `minion-town-deployed-topology` updated with the `validateVhostRecord` poison-pill finding for future drift checks.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-dckc-powers-weblet-audit-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1147116 cached reads)
- Output: 24694 tokens
- Cost: $2.02886
- Wall-clock: 395s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
