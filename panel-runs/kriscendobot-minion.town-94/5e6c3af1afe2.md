---
kind: panel-run
repo: kriscendobot/minion.town
pr: 94
panel_kind: code
base_ref: origin/main-50aa690
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 269fdc5dd4fd4459a10480ca2663af5dc299b298
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 5e6c3af1afe2
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #94 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `269fdc5d`

seat verdicts (34): archivist=pass assessor=comment benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=pass duality-auditor=comment engine-realist=comment fast-checker=comment gateway=pass integrator=must-fix locksmith=must-fix migrator=comment orthographer=pass packager=must-fix procurer=pass prover=comment pruner=pass purist=must-fix reexport-auditor=pass releaser=pass saboteur=comment scribe=comment spec-keeper=must-fix stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=must-fix wire-watcher=comment
must-fix items (20):
- integrator: **must-fix: the PR body no longer matches the diff.** [rule: roles/jurors/integrator/AGENT.md § Merge-commit readabi...
- integrator: The body's last security paragraph says the deploy secrets are "staged in a private `mktemp -d` under `umask 077`".
- integrator: Commit 269fdc5 reversed that. The scripts now stream secrets with `sudo install … /dev/stdin <dest>.new` and `mv`, ...
- integrator: `test/caddy-environment-sync.test.ts` now asserts that `SECRET_DIR` is absent, which contradicts the body.
- integrator: The "(8/8)" test count in the body should be re-checked against the head.
- integrator: The body also describes mid-PR history ("close the /tmp secret window") rather than the end state. A `git log` reader...
- integrator: **must-fix: the `fixup!` commit is left unsquashed.** [rule: roles/jurors/integrator/AGENT.md § Commit grouping]
- integrator: e5b545d (`fixup! fix(security): stage downloaded secrets in a private mktemp dir`) sits above the commit it fixes.
- integrator: a7b9c22 and e5b545d then add a mktemp design that 269fdc5 replaces, so three commits carry the same transient approach.
- integrator: Reset and redistribute into three logical commits: the thunk `/token` auth, the SIWE hardening, and the stream-to-des...
- integrator: Overlaps with the packager.
- integrator: **should-fix: the client-auth logic is duplicated across two thunks.** [rule: roles/jurors/integrator/AGENT.md § For...
- integrator: `secretsEqual` and the Basic-header parse are pasted into `github-oidc-thunk/index.js` and `thunks/siwe/src/openid.js...
- integrator: This is defensible, because the two thunks ship as separate artifacts. The PR should say so, so the next adopter of a...
- integrator: Parsing differs slightly. The GitHub thunk returns `{}` on a bad header and the SIWE thunk returns 401 directly. Both...
- integrator: **should-fix: the GitHub thunk's `/token` gate asserts the Cognito/client-secret assumption only in prose.** [rule: r...
- integrator: It compares against the GitHub OAuth App credentials. That is coherent only if Cognito is configured with the same pair.
- integrator: Nothing in the diff documents or tests that configuration, for example in `deploy/aws` docs or a deploy-script check....
- integrator: Point at the Cognito IdP configuration site, or add a doc line there.
- integrator: **comment-only: the test names the invariant by regex.**
