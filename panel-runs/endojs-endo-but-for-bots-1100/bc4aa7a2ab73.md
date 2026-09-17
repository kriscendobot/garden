---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1100
panel_kind: code
base_ref: llm-387ea66
rounds: 1
disposition: must-fix
exit_code: 0
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: bc4aa7a2ab73
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — endojs/endo-but-for-bots #1100 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `e47a1af3`

seat verdicts (30): archivist=must-fix assessor=pass benchmarker=must-fix breaker=pass changeset-auditor=must-fix corner-prober=must-fix coverage-auditor=pass curator=pass duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=pass migrator=must-fix orthographer=pass packager=must-fix prover=must-fix pruner=must-fix purist=must-fix releaser=must-fix saboteur=comment scribe=pass spec-keeper=comment stylist=must-fix surfacer=must-fix transplanter=pass typist=must-fix warden=comment wire-watcher=must-fix
must-fix items (20):
- archivist: **should-fix: `packages/exo-stream/BENCH.md:59-62` says something the PR body contradicts.** It says the 4–5x figur...
- archivist: **should-fix: `packages/platform/src/fs/interfaces.js:41-80` documents a public export in a `//` comment.** This new ...
- archivist: **should-fix: the accepted-source contract is documented incompletely.** `packages/platform/src/fs/types.ts:111` and ...
- archivist: **should-fix: some comments no longer match the code after the switch to `looksLikeReadableBlob`.**
- archivist: `packages/space-file-explorer/src/file-explorer-fs.js:277` still says "`text`/`stream` means a file".
- archivist: `packages/endo-fs-asset-server/src/serve-tree.js:222` still says a file is "confirmed by the presence of `stream`".
- archivist: The body now requires `stream` plus a marker. [rule: roles/jurors/archivist/AGENT.md § Primary surface]
- archivist: **should-fix: the 9p-server prose contradicts itself.** `packages/9p-server/src/server.js:61` says `want` is "a tight...
- archivist: **should-fix: `packages/exo-stream/README.md:298` doesn't give the reader's default.** It omits the 100,000-byte defa...
- archivist: **comment-only: an unrelated sweep replaced Unicode symbols with ASCII in design docs.** In `packages/platform/src/fs...
- archivist: **comment-only: smaller wording problems.**
- archivist: `DESIGN.md:289` says "figures below", but no figures follow.
- archivist: `DESIGN.md:290` says "per the PR notes" without a link.
- archivist: `mount.js:1303` calls `text` a "byte-read marker", while `interfaces.js` calls it the whole-value read surface.
- archivist: `from-mount-backend.js:64` gives a circular reason now that byte arrays are passable.
- archivist: The header of that file dropped the wire-cost factor, which is now about 2x (hex) rather than removing it.
- benchmarker: **Wire size about 1.5x larger:** closed. The PR body measured the CapData body (131,105 vs 87,386 bytes). The harness...
- benchmarker: **About 4.5x slower across the boundary:** closed only in the PR body, which has both paths, the same workload, Node ...
- benchmarker: **Transfer can't be used for every stream:** closed by a "not pursuing" reason (producers don't own their buffers).
- benchmarker: **Compact byteArray marshalling and ownership-aware transfer as follow-up work:** deferred, but with an unmeasured si...
