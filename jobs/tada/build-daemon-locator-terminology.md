The finding is delivered. The job is complete: the named deliverable already exists on `origin/llm`, verified comprehensively, and there is nothing to build.

---

## Completion report — `build-daemon-locator-terminology`

**Outcome: no PR opened — the design's named deliverable is already fully implemented and tested on `origin/llm`.**

### What I did
Set up an isolated project worktree off `origin/llm` and audited the endo-but-for-bots daemon against the M3 `daemon-locator-terminology` design (both the stale garden-journal import and the authoritative repo copy, `designs/daemon-locator-terminology.md`, updated 2026-05-10). Confirmed via git history and grep that the terminology + format work landed via **endojs/endo-but-for-bots#34** (commits `5bd2f09` "locator scheme with @-delimited connection hints", `24b8dcb` "align locator hint terminology"). Verified no open PR or parked job re-covers it and my inbox was empty.

### What's already present (verified in source)
- **New types** (`types.d.ts`): `PeerKey`, `FormulaAddress`, `FormulaKey`, `ConnectionHint`, `PeerLocator`, `FormulaLocator`, plus `locateWithHints` in the interface.
- **New `@`-delimited locator format** `endo://{peerKey}/{formulaAddress}@{hint}?type=` in `locator.js`, with URL-encoded path components.
- **Methods**: `parseLocator` returns `hints`; `formatLocatorWithHints`; `hintsFromLocator`/`addressesFromLocator`; `locateWithHints` (on Host); `externalizeId`/`internalizeLocator`; invitation format + `accept` parsing in `host.js`; dehydration/hydration.
- **`isLocalKey` predicate** (`localNodeNumber || hasAgentKey`) threaded through daemon/host/mail/directory/guest.
- **Tests**: 25-case `test/locator.test.js` covering the design's parse/format/round-trip/hints/externalize-internalize test plan.

(Could not execute the ava suite — the fresh worktree has no `node_modules` and no `yarn` on PATH; a full monorepo install was out of proportion for a verification-only pass. Verification was by source + git-history audit against the design and the existing committed tests.)

### Flagged to the maintainer (message bus → maintainer inbox)
1. **Stale status**: garden-journal frontmatter "Not Started" / body "In Progress" and repo README rows "Not Started" — actual state is done; worth marking Complete.
2. **One deliberate divergence**: the design's **LOCAL_NODE Normalization** sub-scheme (rewriting *stored* formula ids to the all-zeros sentinel via `internalizeLocator(isLocalKey)` / `externalizeId(agentKey)`, plus `repairIds`/`normalizeId` DB repair) was **not** built as written — `locator.js` explicitly does no sentinel normalization ("no sentinel normalization needed"); stored ids use `localNodeNumber` as the canonical local node and `isLocalKey` handles local/remote at the boundaries, leaving `LOCAL_NODE` defined but vestigial. I did **not** implement the full sentinel scheme unilaterally: it's a separate, larger, storage-identity change outside "terminology and format" scope and carries real regression risk.

### Follow-ups
- Maintainer to decide whether the LOCAL_NODE-sentinel + DB-repair scheme should be pursued as its own job.
- Design status fields (journal + repo README) should be updated to Complete.
