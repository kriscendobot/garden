**Panel round 3: kriscendobot/minion.town PR #146 — must-fix**

I ran one single-round panel against PR head `build/claude-infer-endo-cancel` on base `origin/main-af7af61`. `panel.sh` exited 0 with disposition **must-fix**, and the run is recorded at `panel-runs/kriscendobot-minion.town-146/16564eee24fd.md`.

Of the 33 seats, only **integrator** requested changes; the rest approved or left comment-only notes. Its findings:
1. **must-fix:** `.npmrc` sends the whole `@endo` package scope to `npm.minion.town`. The production `Dockerfile` build and runtime stages now install from it, but the docs (`deploy/aws/npm-registry/README.md`, `DEPLOYMENT.md`) call that registry staging-only. The fix is to depend on a real `@endo/cancel` release or keep the vendored copy until one exists.
2. **must-fix:** that same `.npmrc` line is a scope-only override, which the registry README (line 73) rules out ("one global override, no scope-only override").
3. **should-fix:** the PR title still describes the round-1 change. It should name the switch to the upstream package and registry.

Non-blocking notes from other seats:
- **pruner** and the PR-body concision check say the "Changes" bullets in the description carry too much detail.
- **breaker** points out that the swap deleted the local corner-case tests for the cancel kit, so that coverage now lives only upstream.
- **warden** suggests adding an `Object.isFrozen` check on the hardened options passed to `infer`.

**Posted:** review https://github.com/kriscendobot/minion.town/pull/146#pullrequestreview-5395029702 (state COMMENTED). GitHub refused a request-changes review because the bot owns the PR, so the review went in as a comment. It opens with an explicit "must-fix" header. The full aggregate was over GitHub's size limit, so the review left out the sections from seven seats that only approved or commented (fast-checker, releaser, coverage-auditor, orthographer, thesaurus, procurer, reexport-auditor); they are all in the journal record.

**Follow-up:** the next fix-loop stage should handle the two registry must-fixes. They are deployment-policy calls, so the maintainer may need to decide between waiting for an `@endo/cancel` release and keeping the vendored copy.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr140-endo-cancel-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (672045 cached reads)
- Output: 3672 tokens
- Cost: $0.6916249999999999
- Wall-clock: 913s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
