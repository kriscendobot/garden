---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1390
panel_kind: code
base_ref: 8e53cc0f89a4efc4d21c673f0721ed50a7becf6e
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 18d8207af15eca2bca435f837e0cb9b1cdc8805a
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: cfe71aeb279f
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — endojs/endo-but-for-bots #1390 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `18d8207a`

seat verdicts (33): archivist=must-fix assessor=must-fix benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment duality-auditor=pass engine-realist=pass fast-checker=comment gateway=pass integrator=must-fix locksmith=pass migrator=must-fix orthographer=comment packager=pass procurer=must-fix prover=pass pruner=comment purist=comment reexport-auditor=pass releaser=pass saboteur=pass scribe=pass spec-keeper=must-fix stylist=comment surfacer=pass thesaurus=pass transplanter=pass typist=pass warden=must-fix wire-watcher=comment
must-fix items (20):
- archivist: An additional improvement included in this PR, or
- archivist: Defer it to a separate PR if it's out of scope.
- assessor: **Must-fix.** `evaluate`'s endowment/worker-name arguments are forwarded as bare strings at two call sites, but the d...
- assessor: `packages/lal/tool-dispatch.js:473-499` (`case 'evaluate'`): `edgeNames` (typed `M.arrayOf(M.string())` in `packages/...
- assessor: `packages/fae/src/tool-makers.js` `makeEvaluateTool` (~line 162-193): `workerName` and `petNames` (`Object.values(end...
- assessor: Fix: wrap `workerName`/`resultName`/each endowment pet name as one-segment arrays (`[name]`) before the `evaluate` ca...
- assessor: **Comment-only.** `packages/lal/tools/code.js`'s `evaluate` tool summary/guard never mentions a `petNamePaths` argume...
- breaker: **must-fix**: the slash-joined channel mention is still refused, because only the path half was split. `packages/chat...
- breaker: **Attack:** mention someone in a channel named `['feature', 'foo']`. `assembleMentionSend` returns `edgeNames: ['feat...
- breaker: **Why the test misses it:** `packages/chat/test/unit/mention-send.test.js:18` pins `edgeNames` to `['feature/foo', 'a...
- breaker: **Fix:** derive the edge from the leaf segment (`channelPetName.split('/').at(-1)`) or from `namePathLabel`, then mak...
- breaker: [proposed-rule: when a change splits a delimited string into a path at a UI boundary, every sibling field derived fro...
- breaker: **should-fix**: `stageTree` checks that the scratch leaf is a pet name only after it has snapshotted the tree. `stage...
- breaker: **Attack:** `stageTree(['tree'], ['@agent'])` takes a live snapshot and then refuses.
- breaker: Commit b696236a40 promised that refusal comes before any staging. That holds for `makeUnconfinedFromTree` but not for...
- breaker: **Fix:** call `petNamePathFrom(scratchPetNamePath)` at the top of `stageTreeInternal`.
- breaker: [rule: roles/jurors/breaker/AGENT.md § sibling-family enumeration]
- breaker: **comment-only**: one system-prompt example still passes a bare string. Commit 019bc0e63e converted the other example...
- breaker: [rule: AGENTS.md § Pre-PR checklist, keep examples consistent with the surface]
- breaker: **comment-only (mitigated)**: these invariants held under attack.
