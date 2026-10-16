---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1334
panel_kind: code
provider: anthropic
base_ref: 61cd656cb8d9c3c1c50334eb78bfa0dc8eb1657c
pr_body_hash: 12f1b75bc7f203749e4a4e28043965ea96e3152a0b339902e7dacd860b925187
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 29c4591ff7095b9c5ba1767356662e9c66866607
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: a53d04fbcf4d
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1334 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `29c4591f`

seat verdicts (33): archivist=comment assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=pass duality-auditor=pass engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=pass pruner=must-fix purist=comment reexport-auditor=pass releaser=pass saboteur=comment scribe=pass spec-keeper=comment stylist=comment surfacer=pass thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=comment
must-fix items (20):
- integrator: **Must-fix: the PR body does not follow the template.** [rule: skills/pr-formation § Use the upstream template]
- integrator: Every template heading is missing: Description, Security Considerations, Scaling Considerations, Documentation Consid...
- integrator: The body invents "Problem", "Fix", "Regression test", "Snapshot sweep", and "Update 2026-10-16". The last of these is...
- integrator: Please refill the body section for section. Write one sentence for a section that does not apply, for example "Upgrad...
- integrator: Fold the problem and fix narrative into Description, and the roundtrip test into Testing Considerations.
- integrator: Cover the patched `ava` resolution under Compatibility and Upgrade Considerations.
- integrator: **Should-fix: the PR title and description should name the patched dependency.** [rule: skills/pr-formation]
- integrator: `package.json` swaps the `ava` resolution to a `patch:` protocol pointing at `.yarn/patches/ava-npm-8.0.1-b8bcbeb736....
- integrator: A `git log` reader should see that the repo now carries a local patch to a third-party test runner, and why.
- integrator: The description should say when the patch can be dropped, for example once upstream ava registers encoders against th...
- integrator: **Comment-only: the convention probe is satisfied, and the follow-through is sound.**
- integrator: The `patch:` resolution plus a separate `chore: Update yarn.lock` commit matches AGENTS.md.
- integrator: The last commit removes the earlier `readFileSync` of the `.md` workaround from `ocapn/test/api-surface.test.js` and ...
- integrator: A sweep for other copies of the workaround found none: only `packages/immutable-arraybuffer/src/lib.js` matched the g...
- integrator: **Comment-only: the roundtrip test sits in `@endo/init`.**
- integrator: Placing it there is right, since that package causes the Uint8Array replacement.
- integrator: `packages/init/test/_snapshot-roundtrip/ava.config.js` and `fixture.js` rely on the underscore prefix and the `ava.fi...
- integrator: A short README note, or a comment in `package.json`, would help the next adopter who needs a child ava run.
- integrator: **Comment-only: the final commit message has a loose end.**
- integrator: It says "the `.md` report is unchanged", which matches the diff.
