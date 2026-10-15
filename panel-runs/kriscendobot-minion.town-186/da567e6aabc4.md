---
kind: panel-run
repo: kriscendobot/minion.town
pr: 186
panel_kind: code
provider: anthropic
base_ref: origin/main-e3ffcbb
pr_body_hash: 6e093abf690a9bb69fde07acccdae1d7197d2581e69e19de72efb9608e6e773d
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 1c7abcdb40b2db8e733f5625169af9274fefdf20
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: da567e6aabc4
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — kriscendobot/minion.town #186 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `1c7abcdb`

seat verdicts (34): archivist=comment assessor=comment benchmarker=comment breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=pass fast-checker=comment gateway=pass integrator=must-fix locksmith=comment migrator=comment orthographer=pass packager=comment procurer=comment prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=pass stylist=comment surfacer=comment thesaurus=pass transplanter=comment typist=pass warden=pass wire-watcher=pass
must-fix items (20):
- decomplector: **must-fix: the helper now checks every refreshed token itself, which repeats the server's check and opens the design...
- decomplector: **The check already exists.** Admission is decided in `src/auth/verifier.ts` (`createVerifier`: `jwtVerify`, `issuer`...
- decomplector: **The design already says what a wrong-subject token means.** Design § 2.6, *Operator levers look like failures*: a ...
- decomplector: **This is the mechanism the last three rounds kept patching.** `f51219b` added signature checks and `d6f4e64` moved t...
- decomplector: **Fix:** remove verification from the per-refresh path and keep the design's three reasons. If a one-time `sub` check...
- decomplector: [rule: roles/jurors/decomplector/AGENT.md § Code-panel mode, question 1]
- decomplector: **comment-only: the PR rewrites the design's own build gate.** Base `Status` said "Build scope stops at the verificat...
- decomplector: The risk is the Hammock one: if A2 fails, § 2.0's fallback is "Stall", and roughly 3,000 lines that have been throug...
- decomplector: Recommend the aggregate point this out to the maintainer instead of treating the status rewrite as settled.
- decomplector: [proposed-rule: an implementing PR that edits a design's own scope gate ("stops at X until Y") must cite a maintainer...
- integrator: **must-fix: the PR body's evidence ledger still names the `.sh` scripts that no longer exist.** Commit `1c7abcd` port...
- integrator: Phase 1 cites `root-canary-deploy-client.sh`.
- integrator: Phase 2 cites `root-canary-mint.sh`.
- integrator: Phase 3 cites `root-canary-deploy-client.sh`.
- integrator: Phase 4 cites `root-canary-exec.sh`.
- integrator: **should-fix: the commit history does not match what the body promises a reader of the merge history.** The body says...
- integrator: **comment-only: the open phases are owned by a named successor.** The ledger is `orchestrated-slice`, the PR is draft...
- integrator: **comment-only: no related-design direction is outstanding.** #167, the governing design, is merged. #171 is open and...
- integrator: **comment-only: the scripts follow existing conventions.**
- integrator: `deploy-cd-iam.mjs` is precedent for `.mjs` files in `deploy/aws/scripts/`.
