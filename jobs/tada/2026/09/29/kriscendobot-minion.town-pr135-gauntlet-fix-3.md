# Fix round 3 for PR #135: all fixes pushed and CI is green; one must-fix item is deferred

I pushed six follow-up commits to kriscendobot/minion.town#135 (head `a79aa0f` → `dd72592`, branch `build/npm-minion-town-registry`). `ci-wait-merge.sh --no-merge` returned rc 0 (3/3 checks green). The full local `npm test` suite passes (566 tests) and so does `npm run typecheck`. Shellcheck reports no warnings on the changed scripts. One must-fix item, packager's commit split, is deferred on purpose (see below).

**Fixes, one commit each:**
- **`c1b98da` Node tarball check (saboteur and wire-watcher must-fix):** the script now takes the sha256 from the same `SHASUMS256.txt` line it uses for the file name. The box runs `sha256sum -c` on the download before `tar` unpacks it into `/usr/local`.
- **`e30f3b5` Verification no longer touches the live store (breaker must-fix):** the new release's `verify` runs the server's schema setup (`CREATE TABLE IF NOT EXISTS …`) on whatever database it opens. It now opens a snapshot instead: a SQLite backup of the live database (opened read-only) plus a link to the live CAS, which `verifyStore` only reads. Also fixes assessor's should-fix: after an automatic rollback, the script probes the previous release before reporting success.
- **`28dab53` CAS inventory check on restore (saboteur should-fix):** every inventory entry must look like a sha256 hash (`^[0-9a-f]{64}$`) before it is used as a path.
- **`9ce8f07` Restore tests (prover must-fix):** new `test/npm-registry-backup.test.ts` with four tests, run with root-only commands replaced by stubs on PATH:
  - a restore that comes up ready is swapped in;
  - a restore that does not come up ready is rolled back to the previous state;
  - a copy that fails verification never touches the live state;
  - a malformed inventory entry is refused.

  Mutation-checked: breaking the rollback trap, the step that moves the rejected state aside, or the inventory check makes the matching test fail. To let the tests use scratch directories, the state and current-release paths can now be overridden (`REGISTRY_STATE_DIR`, `NPM_REGISTRY_CURRENT`); the defaults are unchanged.
- **`ba27f4f` `EIP` → `ELASTIC_IP` (stylist must-fix):** a rename-only commit.
- **`dd72592` README (archivist and integrator must-fix):**
  - links the design to its review branch and PR #134;
  - records that the port is 3004, not the design's 3003;
  - explains the tag rule with a worked example: the publish tag is `dev-YYYY-MM-DD` for the date in the version's UTC commit timestamp;
  - lists what each setup step and each backup writes on the box (archivist should-fix).

**Updates on GitHub:**
- I edited the PR #135 body: port 3003 → 3004, a new bullet in the deviations section explaining the port, and the regression evidence for the new tests.
- I posted a comment on #134 asking for the port to be changed to 3004 in four places in the design.
- I posted a comment on #135 giving the disposition of every item.

**Not done:**
- **Packager must-fix, deferred:** earlier commits (`24a9d63`, `67ed047`, `a79aa0f`) mix renames with behavior changes. Splitting them means rewriting pushed history, which a fix stage doesn't do, so it belongs with the pre-merge retcon of this branch. The next panel may raise it again.
- **Prover should-fix, open:** the deploy script's `OLD`/`PREVIOUS` rollback-target logic is still untested because it sits inside the script's SSM heredoc. Extracting it into a testable helper is a follow-up.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3726365 cached reads)
- Output: 23986 tokens
- Cost: $2.119369
- Wall-clock: 567s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
