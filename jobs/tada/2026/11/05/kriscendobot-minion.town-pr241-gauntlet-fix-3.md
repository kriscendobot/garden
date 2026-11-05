I applied the must-fix items from panel-3's verdict (review 5777639132) and pushed them to PR #241. CI is green on the new head, `52c7b820`, including both Claude harness image builds.

**Fixes pushed (three follow-up commits)**
- **`--bare` credential gate (`9556559c`):**
  - `assertBareCredentialContract`, which did a substring check, is now `assertBareEntryContract`. It compares the whole normalized `--bare` entry for an exact match.
  - The pinned text comes from the real 2.1.310 binary, hash-checked against the manifest, and that binary's help passes the new check.
  - New tests reject a credential added before or after the expected text, and a 200-run property test covers line wrapping.
  - This covers the prover, saboteur, breaker, spec-keeper, wire-watcher, engine-realist and fast-checker findings.
- **Freeze bypass and parsing order (`47e791c5`):**
  - While frozen, `create` with `watchInbox` now needs a completed responder. An existing name alone no longer mints a new bearer (locksmith).
  - The account router now mounts ahead of `express.json()`, and the POST body is parsed only after the gate, admission, cross-site and freeze checks. Frozen malformed or oversized bodies now get 410 instead of 400 or 413 (saboteur).
  - The new parsers cap JSON bodies on this route at 16 KiB. Before, the app-wide default of 100 KiB applied.
  - New tests cover the delegation-and-child restart, frozen HTML POST and JSON GET, and an env-switch property (corner-prober, fast-checker).
- **Design and changeset (`52c7b820`):**
  - `designs/claude-agents-capability.md` now has a status note, a *Frozen onboarding* section, `onboarding-frozen` in its unions, and production-sequence and acceptance notes (archivist, integrator).
  - The changeset is now `major` and rewritten as a migration note, one sentence per line (changeset-auditor, releaser).

**Verification**
- **Local:** `tsc` is clean, 328 Claude tests pass across 26 files, and all 46 harness tests pass.
- **Mutation checks:** disabling the responder guard, or putting a JSON parser back ahead of the route, each makes its new test fail.
- **Not run:** ESLint, because the repo has no config for it. I also did not run the full test suite locally; CI's `test` job covers it and passed.

**Not applied**
- **purist:** the race between a concurrent `dismiss` and `provideChild` is still open. It is labeled should-fix, and fixing it properly needs an atomic get-without-create at the provider boundary.
- **integrator:** I did not fold `f2bdecaf` into the earlier test commit, also should-fix. This stage pushes follow-up commits rather than rewriting history.
- **locksmith:** I added the requested guard but not its optional suggestion of a structurally narrowed provider for frozen facets.

**For the maintainer**
- **`major` bump:** I followed the changeset-auditor here, but the package is private at 0.1.0, so the next version becomes 1.0.0. The other pending changesets are `minor`; revert this one if that isn't wanted.
- **Stricter pin:** any wording change to the `--bare` entry now blocks the next pin move until someone reviews it, even if credentials aren't affected. That is deliberate, because added text can appear anywhere in the entry.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1986768 cached reads)
- Output: 29970 tokens
- Cost: $2.0316096
- Wall-clock: 680s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
