Fix round 5 for kriscendobot/minion.town#235 is pushed as `c7c81caf`, and CI is green. That covers Actions run 41760147946 only (typecheck, vitest, the guide's daemon recipes, harness images), because this token can't read the check rollup. The PR stays a draft. There was no pre-pass block in the job, so I worked from the latest panel review, and I didn't re-run the panel.

**Must-fix items applied**
- **Edge name running as code (saboteur, wire-watcher):**
  - The guide and primer now teach the `adopt` tool and say never to put `strings` or `names` in `source`.
  - A new recipe shows a hostile edge name stays data.
  - A wider lint rejects any `source` placeholder other than `NUMBERn`, and any `.adopt(`.
- **Locators carry authority (locksmith):** a new daemon test confirms any locator or identifier grants its capability to whoever holds the text. The guide pages and primer now say so, and the generator marks the nine methods that move this text.
- **Artifact test (prover):** the fixture now includes `resources/instructions.md`, and the test asserts it arrives.
- **Surfacer 1–3:**
  - A lint requires "only when" on any always-listed line that links a gated page.
  - The unused `submit` guide mount is gone.
  - `DEPLOYMENT.md` now documents `MCP_RESOURCES_DIRECTORY`.

**Should-fix items also applied**
- **Tests and packaging:** static checks on the Dockerfile and `deploy-app.sh`, a stricter collision test, and four locators that parse but are no invitation.
- **Recipes and verifier:**
  - Mail with no `strings` no longer stops a run.
  - The mail handle's methods are allowlisted.
  - The verifier's catch only accepts method-not-found.
  - The `await` check no longer pins V8's wording.
- **Docs:**
  - `@sites` is named wherever clip powers are warned about.
  - `Symbol('x')` is documented as a failure.
  - The design and primer README are corrected.
- **Build and PR body:**
  - `tools/guide-recipes` is now typechecked, and the daemon suite runs the graft script itself.
  - The PR body is down to about 840 words.
  - The tool-surface audit moved to design § 3.5, and it no longer proposes removing `adopt`.

**Not applied (listed in the PR comment)**
- **Decomplector 1:** striking slice 4 changes the deploy plan, so that's the maintainer's call.
- **Decomplector 2:** `reference/host-facet` stays, because its description already names its reader.
- **Pruner 8:** the focused pass over the design wasn't done.
- **Smaller items:** the remaining comment-only and follow-up items.

**Not verified**
- **Production:** the last production run predates these recipe changes, so the new hostile-edge recipe hasn't run there. The parked successor `minion-town-mcp-guide-remaining-slices-20261104` owns the re-run.
- **Local:** I ran `tsc`, the daemon suite, and `test/resources.test.ts` with adjacent tests, not the full suite; CI's vitest step covered the rest.

The report is on the PR: https://github.com/kriscendobot/minion.town/pull/235#issuecomment-6620879703

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (2631674 cached reads)
- Output: 43355 tokens
- Cost: $2.7440108000000003
- Wall-clock: 1266s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
