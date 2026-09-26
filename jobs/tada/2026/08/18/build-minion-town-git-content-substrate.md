The build is complete. Here is the completion report.

---

## Completion report — `build-minion-town-git-content-substrate`

**Re-derivation on clean start:** No prior committed work existed — the only journal tada for this base was the *design* job (merged as #39), and no build PR carried the job marker. Treated as a fresh build.

**Target-check:** Confirmed the buildable slice. `designs/git-content-substrate.md` (merged via #39, "deferred experiment") has a coherent serving-side slice (§§4–6) that is independent of the changes-requested #41 wire-protocol design. Built only the serving substrate; did **not** touch the git-HTTP remote / cap-URL surface, and kept everything local (no `@endo/*` extraction, per §1.5).

**Delivered — draft PR [kriscendobot/minion.town#48](https://github.com/kriscendobot/minion.town/pull/48)** (head `feat/git-content-substrate-serving`, base `main`):

- **`src/endo/gateway/projector.ts` (§4/§5)** — pure Git-tree→CAS projection (intern → canonical manifest → `contentRoot`, no hooks/build scripts). Root-qualifies HTML sub-resource refs (script/link/img/srcset/media) to `/.content/<root>/…` while leaving `<a href>` root-free. Breaks the digest-in-document cycle with an all-zero **sentinel root** the serving layer substitutes at stream time. Path validation + byte/count/per-file limits.
- **`src/endo/gateway/vhost-table.ts`** — `advanceVhostContentRoot`, the mutable-record **compare-and-swap** (§1.3/§4): a stable, source-named record advances from an expected old root to a new one; a mismatch returns a `conflict` and writes nothing.
- **`src/endo/gateway/content-source.ts` (§4)** — the atomic publication transaction (intern blobs → manifest → CAS-swap; conflict = fetch-and-retry; no-op republish reports `changed:false`).
- **`src/endo/gateway/content-server.ts` (§5/§6)** — two-tier serving: mutable docs `no-cache` + `ETag:"<contentRoot>"` (with sentinel→root substitution); `/.content/<root>/<path>` `immutable` + strong blob ETag, resolved against the **URL's** root so old roots stay reachable across an advance. No redirect, no cookie. GET/HEAD only, full isolation floor, fail-closed, content never executed server-side.
- **Tests** — `projector.test.ts` (root-qualification rule + determinism), `content-source.test.ts` (CAS advance + conflict), `content-caching.test.ts` (both tiers end-to-end + coherence across a content-root advance). Updated `content-server.test.ts`/`gateway.test.ts` to the new two-tier semantics (HTML at a mutable path is now `no-cache` + contentRoot ETag).
- **DEPLOYMENT.md** — documented the new content-source path and its coexistence with `weblet_publish` and the fixture seeder (§7).

**Verification:** `npm run typecheck` clean; full suite **245 passed, 3 skipped** (repo CI = npm typecheck + test on Node 22). Note: the garden `pre-push-gates.sh` couldn't run — it hard-codes `yarn`, but minion.town is an npm project; substance verified via the repo's actual CI commands. Abbreviations in touched code (`req`/`res`, `opts`) match established repo convention per rename-discipline; new modules carry none.

**Follow-ups / handoff:** The draft PR now auto-runs the gauntlet (clean → panel → fix-loop → un-draft) under the supervising gardener's state machine — no separate action needed. Possible later hardening (not this slice): scope `/.content/<root>/` retention per-weblet via a roots index, and a true atomic swap in a daemon-backed record (the fs read-check-write narrows but doesn't eliminate a concurrent-writer race, as noted in the design's §1.5 local-experiment boundary).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-git-content-substrate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 107 tokens (7019870 cached reads)
- Output: 69421 tokens
- Cost: $6.864668000000003 (1 engagement(s) unpriced)
- Wall-clock: 953s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
