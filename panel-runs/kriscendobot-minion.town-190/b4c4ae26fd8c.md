---
kind: panel-run
repo: kriscendobot/minion.town
pr: 190
panel_kind: code
provider: anthropic
base_ref: origin/main-ad0257e
pr_body_hash: e74f122b8f593f3cdb5c55649021b4a91899d647e1bbcbc359550667ccdaa120
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 45bc4b8a1839cfe593545de8300bdad5761306bb
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: b4c4ae26fd8c
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — kriscendobot/minion.town #190 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `45bc4b8a`

seat verdicts (34): archivist=must-fix assessor=must-fix benchmarker=comment breaker=must-fix changeset-auditor=pass corner-prober=must-fix coverage-auditor=comment curator=comment decomplector=comment duality-auditor=comment engine-realist=must-fix fast-checker=comment gateway=comment integrator=must-fix locksmith=pass migrator=comment orthographer=pass packager=comment procurer=pass prover=must-fix pruner=must-fix purist=must-fix reexport-auditor=pass releaser=pass saboteur=must-fix scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (20):
- archivist: **must-fix**: `src/endo/gateway/clip-order.ts:15` cites "designs/clip-gateway.md § 2" for the transplant-discipline ...
- archivist: **must-fix**: The docs promise that a stale tab can never overwrite a newer order. The code can break that. Affected ...
- archivist: Failure path: tab A has a save in flight at rev 0. Tab B saves, so the server is at rev 1. Tab A drags again, which s...
- archivist: Fix: drop `pending` on conflict, or narrow the prose. The correctness seats should decide the code side.
- archivist: **comment-only**: The `InvalidClipOrderError` JSDoc in `clip-order.ts` is a sentence fragment with no subject. It als...
- archivist: **comment-only**: `makeClipOrderer` is a new export with no JSDoc, unlike its siblings. The module header covers it, ...
- archivist: DEPLOYMENT.md route contract matches `src/auth/guest-self-endpoint.ts`: 200 body, 400 cases, 409 body, 503 paths, and...
- archivist: The `$GATEWAY_STORE_DIR/clip-orders/` path is correct: `config.ts:282` maps the env var to `clipStoreDir`, and `http....
- archivist: The keepalive, Alt+Arrow, and coalescing claims match `shell.js`.
- archivist: The Caddy matcher addition matches the documented routes.
- archivist: The removed "§ 6 reorder follow-on" text leaves no stale reorder references in `designs/clip-shell-framework.md`.
- archivist: The `clip-shell-framework.md` § and Open-question references resolve.
- archivist: The claim that GC reads only `vhosts/` and `blobs/` holds for the store root. Its partitions directory comes from `GI...
- archivist: No banner comments in the added lines.
- assessor: **must-fix. A malformed or unreadable order file takes down all clip listing.**
- assessor: `src/endo/gateway/publish.ts:365-367` changes `ClipPublisher.list` to `(await orderer.listing(owner)).clips`. `listin...
- assessor: `makeFsClipOrderStore.read` throws `SyntaxError` from `JSON.parse`, `owner` mismatch, `malformed saved clip order`, o...
- assessor: The MCP `listSites` tool (`src/endo/guest-tools.ts:806`, via `facet.list()`) now rejects, as does `/account/clips`. T...
- assessor: Fix: in `listing`, catch a `store.read` failure, log it, and fall back to listing order with revision 0. Keep `reorde...
- assessor: [proposed-rule: a display-preference read must degrade to the default, never fail the primary data path it decorates]
