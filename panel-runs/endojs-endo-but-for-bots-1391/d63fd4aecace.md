---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1391
panel_kind: code
base_ref: ef4662f04b575a1edb0e716a4fc03f847dd7f53f
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 1a5ed2ee0fca9a49683aba0b9ff1883f5c8b2fe4
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: d63fd4aecace
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — endojs/endo-but-for-bots #1391 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `1a5ed2ee`

seat verdicts (33): archivist=pass assessor=pass benchmarker=pass breaker=comment changeset-auditor=must-fix corner-prober=comment coverage-auditor=pass curator=pass duality-auditor=pass engine-realist=comment fast-checker=comment gateway=pass integrator=must-fix locksmith=pass migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=pass saboteur=comment scribe=must-fix spec-keeper=must-fix stylist=pass surfacer=pass thesaurus=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (20):
- changeset-auditor: **Bump-level mismatch: the changeset should be `major`, not `minor`.** The diff adds `assertSturdyRefShape` (`package...
- integrator: **should-fix: the commits land as the history of the review rounds, not as logical steps.** [rule: roles/jurors/integ...
- integrator: The range has 11 commits, and several fix up earlier ones:
- integrator: `49112da9e1 style(ses): prettier`
- integrator: `c78271e1f1 test(ses): narrow the SturdyRef descriptor in the XS smoke for lint:types`
- integrator: `a05d0fcd77 test(ses): freeze the stand-in SturdyRef shim as the real shim does`
- integrator: `1a5ed2ee0f … correct the first-wins value-check comment`
- integrator: `b6cbc3ac0f` and `819203dd53`, which rework the `fix(ses)` scoping and shape-check logic added in `240488c841`
- integrator: The project merges by rebase, so every one of these reaches `master` as-is. Someone reading `git log` later would see...
- integrator: Please reset and regroup into about three commits:
- integrator: `feat(ses)`: the permit, the propagation, the first-wins skip and the shape check, with the changeset.
- integrator: `test(ses)`: the Node tests and the XS smoke, including the `package.json` `test:xs` change.
- integrator: `test(sturdyref)`: the tightened child-compartment test in `packages/sturdyref`.
- integrator: This overlaps with the packager's seat.
- integrator: **comment-only: the stand-in shim is a sound way to avoid a dependency cycle, and its drift is covered.** [rule: role...
- integrator: `@endo/sturdyref` already has `ses` as a devDependency (`packages/sturdyref/package.json:54`).
- integrator: So `packages/ses/test/_sturdyref-shim-first.js` copies the real shim's shape instead of importing it, which adds no n...
- integrator: Drift between the copy and the real shim (`packages/sturdyref/src/sturdyref-shim.js`) is caught by `packages/sturdyre...
- integrator: The changeset's last sentence and § Upgrade Considerations both state that the permit and the shim are coupled. No a...
- integrator: **comment-only: concept names and the related design are handled.** [rule: roles/jurors/integrator/AGENT.md § Concep...
