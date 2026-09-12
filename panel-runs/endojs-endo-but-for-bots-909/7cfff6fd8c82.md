---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 909
panel_kind: code
base_ref: 1bcf0f0de8808eb74bed05404eafa4cb05bd0f4b
rounds: 1
disposition: must-fix
must_fix_total: 10
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 7cfff6fd8c82
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #909 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `c391653b`

seat verdicts (30): archivist=comment assessor=comment benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment duality-auditor=pass engine-realist=comment fast-checker=comment gateway=comment integrator=pass locksmith=pass migrator=comment orthographer=pass packager=pass prover=pass pruner=pass purist=comment releaser=pass saboteur=pass scribe=must-fix spec-keeper=comment stylist=pass surfacer=pass transplanter=pass typist=must-fix warden=pass wire-watcher=pass
must-fix items (10):
- scribe: **Completion-summary closure — Open, for the round-1 must-fix push.** The panel's `must-fix` review (`r`/review `49...
- scribe: **Completion-summary closure — Open, for the second responding push.** Commit `c391653b4` "fix(cli): repair TypeScr...
- scribe: **Note-this / standing-orders asks — none found, no finding.** Walked all PR comments (`issues/909/comments`, 2 tot...
- typist: **`packages/cli/test/typescript-archive.test.js:20,22` — inline `import()` type references in JSDoc tags (must-fix).**
- typist: @param {import('@endo/compartment-mapper').ParserImplementation} sourceParser
- typist: @returns {import('@endo/compartment-mapper').AsyncParserImplementation}
- typist: `makeTypeScriptParser`'s returned object (`cli-archive.js:125-162`) matches the declared `@returns {AsyncParserImplem...
- typist: `makeCliArchive`'s `@param {ArchiveOptions} [options]` is correctly bracketed (default `= {}` makes it genuinely opti...
- typist: `commands/archive.js`'s updated `@param {ArchiveOptions} [args.archiveOptions]` likewise correctly optional and no lo...
- typist: No typist-hostile code points introduced in the diff's comments/prose.
