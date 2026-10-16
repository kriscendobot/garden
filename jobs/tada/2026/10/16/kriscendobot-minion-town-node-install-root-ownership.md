**Completion report: `kriscendobot-minion-town-node-install-root-ownership`**

Step 1 is done and up as draft PR https://github.com/kriscendobot/minion.town/pull/192, based on the frozen `main-30a4c62`. Step 2 is parked as a separate job until #171 merges, which it hasn't yet (#171 is still an open draft).

**What I changed (step 1)**
- **The risk is real.** Every file in the current Node tarball (`node-v22.23.3-linux-arm64`) is owned by uid/gid 1001. Unpacked as root without `--no-same-owner`, the Node files under `/usr/local` (including `bin/node` and its directories) would belong to whatever account has uid 1001 on the box.
- **New shared helper.** `deploy/aws/scripts/lib/install-node22.sh` defines `install_node22 <file> <url> <sha256>`. `common.sh` inlines it as `$INSTALL_NODE22`, the same way it already does `$INSTALL_SECRET` and `$ENSURE_SETFACL`. `deploy-app.sh`, `deploy-endo-daemon.sh` and `deploy-npm-registry.sh` now all call it instead of carrying their own copy.
  - It still downloads, checks the checksum and installs only when Node v22 is missing, as before, but now unpacks with `--no-same-owner`.
  - It resets ownership on every deploy, not just on a fresh install, so a box that an earlier deploy left with the wrong owner gets repaired:
    - the `/usr/local` directories the tarball fills are set to `root:root` (not recursively);
    - only the Node entries themselves are set to `root:root` recursively, so other things under `/usr/local` (such as `oauth2-proxy` and `ci-runner-controller`) are left alone;
    - group/other write is removed from `node`, `/usr/local/bin` and `/usr/local`.
- **Docs.** I added a "Node ownership" bullet to `DEPLOYMENT.md`.
- **Tests.** The new `test/install-node22.test.ts` (6 tests) covers:
  - a fresh install: `--no-same-owner` is used, the right paths get chowned and nothing is left group/other-writable;
  - an existing install: nothing is downloaded, and ownership and permissions are still reset;
  - a checksum mismatch: nothing is unpacked;
  - all three deploy scripts going through the helper.

**Verification**
- The new tests pass, and so do the existing deploy tests (`test/deploy-*.test.ts` and `claude-cli-deployment`).
- `tsc --noEmit` and shellcheck on the new helper are clean, and `bash -n` passes on the three deploy scripts.
- I have not run it against the live box, which needs SSM.

**Step 2 (blocked on #171)**
- It is parked as `kriscendobot-minion-town-node-observed-interpreter`, blocked on https://github.com/kriscendobot/minion.town/pull/171. It gets promoted when #171 is merged or closed.
- If #171 was closed without merging, the job is told to report that and stop.
- The work: add `/usr/local/bin/node`, `/usr/local/bin` and `/usr/local` to the checked set in `deploy/probe/claude-harness-layout.cjs`. Node's rule is root-owned with no group/other write, not the read-only 0444 rule the harness files use. Then remove the "trusted rather than observed" paragraph from `DEPLOYMENT.md` § AWS/SSM.
- If #192 is still open by then, the job adds this to #192's branch after rebasing it onto a fresh frozen base of `main`. Otherwise it opens a new draft PR.

**Follow-ups**
- The automatic review chain (clean, panel review, fixes, un-draft) should pick up #192.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-node-install-root-ownership.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1829051 cached reads)
- Output: 20138 tokens
- Cost: $1.3374261999999997
- Wall-clock: 731s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
