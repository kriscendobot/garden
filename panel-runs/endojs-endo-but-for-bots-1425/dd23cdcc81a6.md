---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1425
panel_kind: code
base_ref: 6ee3fda77bf28a4fe4a81c6269fe33655f162b9e
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 68129dd7269123dcaeb7ae9eabeba7eda522ce8c
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: dd23cdcc81a6
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — endojs/endo-but-for-bots #1425 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `68129dd7`

seat verdicts (33): archivist=pass assessor=pass benchmarker=pass breaker=pass changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment duality-auditor=comment engine-realist=pass fast-checker=comment gateway=comment integrator=must-fix locksmith=pass migrator=pass orthographer=pass packager=must-fix procurer=pass prover=pass pruner=pass purist=pass reexport-auditor=pass releaser=pass saboteur=pass scribe=comment spec-keeper=pass stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=pass wire-watcher=must-fix
must-fix items (20):
- integrator: **must-fix: the PR title describes the approach the PR rejected.** The title is `fix(ses): sample XS compartment intr...
- integrator: **should-fix: the commits show the history of the work rather than the change.** `2d7e3bbcc9` adds a `makeShimStartCo...
- integrator: (a) the `ci:` repin, which can stand alone;
- integrator: (b) one `fix(ses):` commit holding the `repairIntrinsics` callback, the XS lockdown shim, the test and the changeset.
- integrator: **comment-only: the change adds a second way to build the start Compartment.** On other engines, `repairIntrinsics` b...
- integrator: **comment-only: the CI repin is unrelated to the fix.** `.github/workflows/ci.yml:270` (`3158064e5a`) is unrelated to...
- integrator: **comment-only: no names conflict and nothing is left over from the dropped approach.**
- integrator: `ShimStartCompartment` keeps its meaning, now with one constructor made at import time and one made at lockdown. The ...
- integrator: A search finds no remaining `makeShimStartCompartment`.
- integrator: The test uses only the public `Compartment`/`lockdown` surface.
- packager: **must-fix: unrelated CI change in the PR.**
- packager: Commit `3158064e5a` ("ci: repin paths-filter to v3.0.4") edits `.github/workflows/ci.yml:270`. It has nothing to do w...
- packager: The commit is correctly separate from the substance commits. But the PR claims only the SES fix, so the diff carries ...
- packager: Either move the repin to its own PR, or justify it in the PR description (for example, a CI failure that blocks this ...
- packager: [rule: packager § Primary surface — "does the diff carry only what the PR claims"]
- packager: **should-fix: commit split is stacked, not clean.**
- packager: `2d7e3bbcc9` ("sample XS compartment intrinsics at lockdown") is already in the base history. Its decorations show it...
- packager: Still, `git log` for the range lists `2d7e3bbcc9` first, so it is part of the range.
- packager: Its subject ("sample … at lockdown") describes the opposite of what `99e15702f8` then does (build from lockdown int...
- packager: `68129dd726` ("format the XS secure-mode check") is a lint or format fixup on `packages/ses/test/_xs.js`. Fold it int...
