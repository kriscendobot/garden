---
role: builder
arc: daemon-git
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
# Open the DRAFT PR for fu-design-daemon-git-clone-provide-git-clone-bootstrap-1 (build-daemon-git-clone)

Repo: https://github.com/endojs/endo-but-for-bots. The predecessor builder job `fu-design-daemon-git-clone-provide-git-clone-bootstrap-1` ran on oros-studio-garden-ce242c49 and finished the implementation of the `daemon-git-clone` design (design PR https://github.com/endojs/endo-but-for-bots/pull/709). It pushed head branch `build/daemon-git-clone` (commit eafcef12bb) on top of the frozen base `llm-54d3d2a`. Opening the PR failed there with `createPullRequest` 403, because that host's bot token lacks PR write on endojs.

Steps:
1. Get the project worktree for this job's base and check out `origin/build/daemon-git-clone`. Run the following from that checkout.
2. Write the PR body below (between the BODY markers) to a file. Do not edit it, except that you may append any marker ensure-pr requires.
3. Run `scripts/jobs/gardening/ensure-pr.sh fu-design-daemon-git-clone-provide-git-clone-bootstrap-1 endojs/endo-but-for-bots build/daemon-git-clone llm-54d3d2a --title "feat(daemon): provideGitClone(destMount, petName, { origin }) with discard on failure" --body-file <file>`. Keep the predecessor's job base as the first argument so the PR carries its `garden-job` marker.
4. Name the PR URL in your completion report so the gauntlet is staged.

Do not change the code. If the head has gone stale against `llm`, still open the PR against `llm-54d3d2a`; the gauntlet's weave handles the drift.

----- BODY -----
Refs: https://github.com/endojs/endo-but-for-bots/pull/709

## Description

`EndoHost.provideGitClone` becomes `(destMount, petName, { endpoint, identity, origin })`, implementing all four phases of the `daemon-git-clone` design in https://github.com/endojs/endo-but-for-bots/pull/709, including the five tests it lists. The host now chooses the `origin` remote's policy at clone time, and that policy defaults to fetch-only. `petName` and `origin.petName` are stored only after the whole composition succeeds. On any failure after the host checks that the destination is empty, the destination is emptied before the error is rethrown. The floot bootstrap shrinks to one call.

One fix outside the design is in a separate commit. Aborting a credentialed git call sent SIGTERM to `git` only, and the orphaned `git-remote-https` kept the pipes and the connection open, so an aborted https clone never settled. `@endo/git` now signals the process group. The new rotation test hangs without this fix.

<!-- garden-related-design: 709,1367,988 -->

### Security Considerations

This narrows authority. A clone no longer grants push over `refs/heads/*` by default; push is opt-in policy. `origin` cannot override the remote's name, URL, credential or transport, so the remote always talks to the server that was cloned. Discard runs only after the host has itself found the destination empty, so it never removes content the caller had before the call.

### Scaling Considerations

None.

### Documentation Considerations

The changeset records the new signature and the migration.

### Testing Considerations

Beyond the design's five tests, there is a test that a non-empty destination is refused and left untouched. A type test pins the call shape and that `origin.url` is refused.

### Compatibility Considerations

This is a breaking change to a host-only method. Every in-tree caller is migrated, and the changeset is `major`.

### Upgrade Considerations

Existing clone formulas are unaffected. Only the call shape and the default policy of newly minted `origin` remotes change.
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-22T17:21:19Z
