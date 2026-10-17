I applied the round-8 must-fixes to PR #192, and CI is green on the new head `72e8d48` (`ci-wait-merge.sh` rc=0; test, Claude harness amd64 and arm64 all pass).

**Pushed with `safe-push-pr-head.sh`:** two follow-up commits on `fix/node-install-root-ownership`, `e33f970` → `72e8d48`.

**Must-fix items:**
1. **Units still running the old Node path (themes 1, 2).** `reclaim_usr_local` no longer just deletes the old `/usr/local` Node install. It first re-owns `/usr/local` to root and removes group and other write bits. Once `/opt/node/current/bin/node` exists, it replaces `/usr/local/bin/{node,npm,npx,corepack}` with root-owned links into `/opt/node/current/bin` and deletes the rest of the old install. Before `/opt/node` exists, it leaves the old files where they are. This means:
   - Units not yet rewritten, and the hand-installed `endo-ocapn-daemon.service`, keep running instead of failing with 203/EXEC.
   - The oauth2-proxy deploy no longer depends on `/opt/node` being present.
2. **Swapped `oauth2-proxy` binary becoming trusted (theme 3).** `deploy-oauth2-proxy.sh` now downloads and reinstalls the binary on every deploy, into a `mktemp -d` directory. It never runs the existing binary first.
3. **Consumers that assumed `/opt/node` (theme 4).** `endo-root-host.sh`, `git-remote-partition.sh` and `npm-registry-backup.sh` now stop with a message if `/opt/node/current/bin/node` is missing. The content-gc runbook notes where that Node comes from.
4. **Docs contradicting the code (theme 5).** I rewrote the `DEPLOYMENT.md` section into two parts, Node ownership and system PATH / `/usr/local`. I also rewrote the PR's *Behavior* and *Out of scope* sections and retitled it to "fix(deploy): install Node under /opt/node, pin root's PATH, reclaim /usr/local".
5. **Simplification (theme 6), done in part.** `reclaim_usr_local` now runs once at the end of the shared prelude (`reclaim_usr_local || exit 1`) instead of at four call sites. Running it in the prelude also covers the ci-runner host. I kept the `sudo()` wrapper on purpose, and its header comment now says why. Re-owning `/usr/local` doesn't remove a command the build uid planted under a system name such as `systemctl`. Without the wrapper, `sudo` would still find that command through `secure_path`, now root-owned. The next panel may raise this again; it's a deliberate disagreement with the decomplector, not something I missed.
6. **Should-fix:** the `install-node22.sh` comment now reads "never reads, runs or repairs the contents of".

**Tests:** I rewrote the reclaim tests in `test/install-node22.test.ts` to cover:
- re-owning while keeping the old files before `/opt/node` exists;
- the links and cleanup after it exists, and that a second run changes nothing;
- the prelude stopping the script when `/usr/local` is a symlink;
- the prelude, not the deploy scripts, calling the reclaim;
- oauth2-proxy being installed before it is run.

Prelude runs in the tests point at a temporary tree, never the real `/usr/local`. Locally, `tsc` passes and `npm test` has 1159 passing and 1 failing. The failure is `test/git-remote/capability.test.ts` ("propagates a git failure"), a file this PR doesn't touch; it looks like a quirk of this machine's environment, and it passes in CI.

**Follow-ups:**
- `designs/mcp-endo-guest.md` and `designs/ocapn-iroh-validation-lane.md` still show `/usr/local/bin/node`. The links keep those examples working; I listed them under *Out of scope*.
- Nothing has been run against the live box, because that needs SSM.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2839748 cached reads)
- Output: 26112 tokens
- Cost: $1.9506695999999997
- Wall-clock: 1158s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
