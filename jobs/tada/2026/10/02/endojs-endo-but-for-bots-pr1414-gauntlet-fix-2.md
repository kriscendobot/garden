Fix round 2 for endojs/endo-but-for-bots#1414 is pushed and CI is green: all 28 checks finished with no failures (`ci-wait-merge` rc 0).

**What I fixed.** The panel's one must-fix, raised by critic, skeptic and decomplector, was the floot `capId` claim. I applied it as follow-up commit `c80950f0b5` on `design/guest-delegated-host-channel-confinement`, pushed with `safe-push-pr-head.sh` (from `1ad8b493aa` to `c80950f0b5`). It edits one file, `designs/daemon-guest-delegated-host-channel-confinement.md`.

- **floot `capId` (must-fix):** The design no longer says floot's `capId` can be swapped for a pet-name path. A new section, "floot's container mounts", shows that `capId` does three jobs and replaces each one:
  - **Surviving a restart:** a random `pin` token. Each attached capability is copied into a directory only the registrar writes, and that copy also checks that the session holds the capability. A record whose pin is missing is dropped on replay, so it fails closed.
  - **The attach key:** `attachKeyFor(clientKey, pin, innerPath)`.
  - **Telling whether two sessions attached the same capability:** a new provisioner method, `sameCapability(pathA, pathB)`. The daemon compares the identifiers itself and returns only true or false, so no identifier reaches floot.
  - **The mount bridge:** `provideContainerMountBridge` now receives the capability itself (`cap`) instead of `capId` or `mountPath`, so the bridge no longer calls `lookupById`.
  - The test plan now covers two sessions sharing one bind and the restart/replay cases. "Persist a pet-name path" is added as a rejected alternative.
- **Should-fix and comment items:**
  - **Phase 4:** marked as blocked on Open Question 3. That question now suggests a shared name family (`@provisioner` / `@provisioner-unattenuated`).
  - **Survey scope:** states the scoping rule and lists the three out-of-scope sites the skeptic found (agentry, cli `inspect`, agent-mcp-stdio).
  - **`interfaces.js`:** the withheld methods are grouped with one comment per category explaining why.
  - **Method list:** `cancel` gets its own bullet.
  - **Novice notes:** "authority" and "designation" are now defined, Gap 1 points ahead to where the packages are described, and the nixos-admin and deploy presets get a one-line gloss.
  - **Copyedits:** fixed the serial comma in the test list, split the long parenthetical, made the wording for rejected alternatives consistent, and changed "Round-3" to "Round 3".

**Follow-ups:** The panel-3 re-review is posted by the driver. Two comment-only notes are left as they were: renaming the guest-side `host-agent` (Open Question 4) and the pedant's suggestion about link anchor text.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (878770 cached reads)
- Output: 10850 tokens
- Cost: $1.000602
- Wall-clock: 673s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
