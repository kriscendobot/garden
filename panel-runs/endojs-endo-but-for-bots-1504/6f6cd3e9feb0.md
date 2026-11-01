---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1504
panel_kind: code
provider: anthropic
base_ref: 9a14ddf660912ed624e2d9047671d43e3a2f0cec
pr_body_hash: 8e58216efaaec731dd69e88495470613941210851f5904a81bba6d83ea207438
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 4fd495067966e5f7a45bf1aa3e9e49dac9b2bad0
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 6f6cd3e9feb0
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1504 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `4fd49506`

seat verdicts (34): archivist=must-fix assessor=pass benchmarker=pass breaker=comment changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=must-fix decomplector=comment duality-auditor=pass engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=must-fix orthographer=comment packager=comment procurer=comment prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=comment typist=must-fix warden=comment wire-watcher=comment
must-fix items (20):
- archivist: **should-fix: a source comment claims a sandbox slice backs the output cap, which it does not.** `packages/exo-shell/...
- archivist: **should-fix: "the slice's construction-time `outputByteLimit`" misattributes the setting.** It appears at `packages/...
- archivist: **should-fix: `designs/daemon-agent-tools.md` status is stale after this PR.** Line 302 says the engine "is invisible...
- archivist: `packages/exo-shell/README.md`: the `inspect()` field list, the `makeSandboxSpawner` import path, and the `engine-cas...
- archivist: `packages/host-spawner/README.md`: `pid` is `0`, `shell: true` is refused, `timeoutMs` is forwarded, and kill settlem...
- archivist: `.changeset/shell-sandbox-engine.md`: the `'environment'` engine matches `packages/daemon/src/environment.js:190`.
- archivist: `engine-cases.js`: the `rejects` regex matches the message at `shell.js:267`.
- archivist: `shell-engine.js`: "read-only host system directories" matches the bwrap `--ro-bind-try` binds.
- curator: **must-fix: published `@endo/exo-shell` now depends on a private package.**
- curator: `packages/exo-shell/package.json` moves `@endo/host-spawner` from `devDependencies` to `dependencies`.
- curator: `packages/host-spawner/package.json:4` is `"private": true`, version `0.0.0`. `exo-shell` is not private.
- curator: Nothing at runtime imports it (`exo-shell/src/types.ts` only does `export type … from '@endo/host-spawner'`), but a...
- curator: `types.ts` also points consumers' `.d.ts` at the private package, so `Spawner`, `ProcessLike` and `SpawnerOptions` be...
- curator: The old code deliberately declared `Spawner` structurally "so this shipped public surface does not depend on `@endo/h...
- curator: Fix: keep the structural types in `exo-shell`, or un-privatize `host-spawner` and give it its own changeset and relea...
- curator: [proposed-rule: a non-private package must not list a `private: true` workspace package in `dependencies`, or re-expo...
- curator: **should-fix: renames and removals on the public type surface are not named, and `@endo/sandbox` is not private-safe.**
- curator: `exo-shell/src/types.ts` drops the `Spawner` declaration and replaces it with a re-export.
- curator: `host-spawner/src/types.ts` renames `SpawnerOpts` to `SpawnerOptions`. The rename flows through `export type *` in `h...
- curator: The changeset mentions neither.
