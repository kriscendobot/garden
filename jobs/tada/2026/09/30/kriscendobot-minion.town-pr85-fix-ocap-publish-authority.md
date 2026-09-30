PR #85 is fixed: upgrading a clip now depends on holding a capability, not on who the caller is. CI on the new head is green (`test`, both Claude harness jobs, dependabot).

**What changed** (branch `feat/clip-upgrade-in-place`, now rebased onto current `main` `7e87a44`, head `af2d343`):
- **Rebase:** the branch was 133 commits behind `main`. I resolved conflicts in `publish.ts`, `daemon-site-registry.ts` and the daemon integration test, adapting to `main`'s newer upgrade interface. I force-pushed with a lease on the old head.
- **Capability instead of owner check:** a new module, `src/endo/gateway/upgrade-capability.ts`, handles minting, looking up and narrowing capabilities.
  - `publish` now returns an unguessable per-clip `upgradeCapability` that carries two rights: `content` and `powers`.
  - `upgrade` takes that capability in place of the clip hash, and anyone holding it may use it. The `record.owner === owner` check is gone from the upgrade path.
  - A new `attenuateUpgrade` tool makes a narrower capability for the same clip (for example content-only). It can never add rights.
  - Capabilities are stored by their sha256 digest under `<clipStoreDir>/upgrade-capabilities/`, so the stored files contain no usable secret. `http.ts` wires in this on-disk table.
  - The caller's identity is still used, but only for billing: whoever calls `upgrade` is charged for the content it adds.
- **Delegation works on the in-memory path too:** its table of writable directories used to be per guest, which would have blocked a delegate. It is now shared, and the capability check in `publish.ts` is the gate.
- **MCP tools:** updated the `publish` and `upgrade` descriptions and added `attenuateUpgrade`. The tool-name list and its snapshot tests went from 23 names to 24.
- **Tests:** the "rejects an owner who does not own the clip" test is replaced by tests showing that:
  - a caller without the capability is rejected, even the clip's own publisher and even with the public hash;
  - another guest holding a passed-on capability can upgrade and is charged for it;
  - a content-only capability cannot change powers or gain rights;
  - the on-disk table survives a restart.
- **Local verification:** typecheck is clean. The full suite has 689 passed, 8 skipped and 1 failed. The failure is in `test/git-remote/capability.test.ts`, and my notes record it as an existing host-environment failure; I didn't recheck it on `main` this session.
- **PR body and reply:** rewrote the body's Authorization section and test notes, and posted a reply to the review: https://github.com/kriscendobot/minion.town/pull/85#issuecomment-5903264374

**Follow-ups:**
- **Designer job posted:** `design-minion-town-clip-lifecycle-capabilities`. It covers what I left undecided: making `unpublish` a capability right (it and `listSites` still use the owner), passing the capability as a daemon-side object rather than a string that ends up in model contexts, what to do for clips published before this change, and revocation. The post script tagged it with the same review identity as this job.
- **Needs a decision:** calling `upgrade` with `hash` no longer works. A publisher who loses their capability cannot upgrade that clip; they can only unpublish and republish it.
- **Gauntlet:** the PR is still a draft, and I left the gauntlet re-run to the automatic completion step.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-fix-ocap-publish-authority.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (4248651 cached reads)
- Output: 39904 tokens
- Cost: $2.7429941999999996
- Wall-clock: 647s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
