CI passed (`test` ✓ in 31s). The job is complete.

## Completion report

**Job:** `minion-town-clip-upgrade-in-place` — close the confirmed gap that a published clip's content could not be updated in place (every change required a fresh `publish` under a new hash and a manual `unpublish`).

**Re-derived state:** Fresh start confirmed — no prior PR carried the `<!-- garden-job: minion-town-clip-upgrade-in-place -->` marker, no `tada/` report existed, and the job sat in `doin/`. No prior committed work to build on.

**What I did** (kriscendobot/minion.town PR **#85**, draft, CI green, mergeable):

1. **Live-path in-place upgrade (req 1).** `makeDaemonGuestSiteAuthority.writeDirectory` (`daemon-site-registry.ts`) now re-points the served fs vhost record's `contentRoot` at the freshly interned manifest digest, keeping `id`/`directoryId`/`owner` — hence the hash/URL — stable. This is the deployed serving truth: the gateway serves from `record.contentRoot` on the CAS data plane with its powers plane off, so advancing that record *is* the upgrade. The clip URL's hash is the stable directory formula id (design §3.4), not a content digest, so same-URL upgrade is architecturally sound.

2. **Authorization story (req 2), documented explicitly.** Upgrade is **owner-gated exactly like `unpublish`** (`record.owner === owner`, enforced in `publish.ts`) and deliberately does **not** require holding the clip's `back` power — being the registered owner confers the right to rewrite `front`; setting a *new* `back` still requires naming a power you currently hold. `assertUpgradable` now takes the `UpgradeInput` so a `back`/powers rewrite (unsupported — powers plane off, would change nothing observable) is rejected *before* any charge/intern, non-silently.

3. **MCP tool surface (req 3).** The `upgrade` tool's description updated from "not yet available when served live" to state the now-live content semantics, the owner/back authorization, and the cache caveat.

4. **Tests (req 4).** Extended both discipline tiers: `npm test` unit coverage for the fs-record rewrite with stable id, the owner gate (non-owner rejected without re-interning), and the powers-rejection-before-charge through `publish.ts`; the skip-gated `ENDO_CHECKOUT` integration suite extended to publish then upgrade a live clip and assert the served record advanced with a stable hash. Full suite: **306 passed | 5 skipped**, typecheck clean, CI `test` ✓.

**Immutability caveat, addressed not silently:** A clip URL is a stable *pointer* (directory id) whose target (`contentRoot`) upgrade rewrites; content is served `immutable`, so already-cached clients/CDNs keep prior bytes until `max-age` — the same accepted contract `unpublish` already documents ("hard-cached copies survive until their max-age"). Making an upgrade *promptly* visible to every cached client would require relaxing `immutable` to ETag-driven revalidation across **all** clips (a CDN-offload-vs-prompt-invalidation trade-off hitting the never-upgraded common case), so I documented it as an explicit follow-up rather than regressing everyone silently.

**Follow-ups (documented in code, not blocking):** (a) rewrite the pinned daemon directory's own `front` snapshot + support `back`/powers upgrade when the powers-plane/watch serving path (design §3.2) turns on; (b) the cache-policy relaxation above if prompt cross-CDN upgrade visibility is wanted.

PR #85 is a draft presenting the complete, tested work for review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-upgrade-in-place.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 118 tokens (6659399 cached reads)
- Output: 60517 tokens
- Cost: $6.3759105
- Wall-clock: 881s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
