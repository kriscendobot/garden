Fix round 3 for kriscendobot/minion.town#152 is pushed, and CI is green (all 3 checks passed).

**Must-fix items from panel round 3**
- **integrator:** #151's current head (`11fc6bb8f`) removed the `repoRoot` export from `lib/common.js`. Three of this PR's scripts import it: `deploy-thunk.js`, `deploy-pre-token-gen.js` and `seed-clip-fixture.js`. Each now builds its own `repositoryRoot` from its own location (`fileURLToPath(new URL("../../..", import.meta.url))`). I also dropped the export, and the `fileURLToPath` import it was the only user of, from this PR's `lib/common.js` to match #151. Weaving onto #151 can no longer leave those imports `undefined`.
- **stylist:** renamed `storeDir` to `storeDirectory` in `seed-clip-fixture.js`.

**Lower-severity items also addressed**
- **pruner (header):** removed the systemd `EnvironmentFile=-…` and `0600 root` detail from the header comment in `deploy-account-endpoint-secret.js`.
- **pruner (PR body) and integrator (title/body, open since round 1):**
  - Dropped "(2a)" from the title.
  - Cut the "How each script was exercised" section down to one sentence about the production incident, placed under the behavior changes.
  - Shortened the "Shared helpers" list to a one-sentence summary of the modules.
  - Moved the note about depending on #151 to a closing "Series" section.
  - Kept the garden-job marker.

**Verification**
- Commit `18d1006` was pushed on top of `478f9bd` with `safe-push-pr-head.sh`.
- Locally, all 29 tests in `deploy-provisioning-scripts.test.mjs` and `deploy-render-reconcile.test.ts` pass.
- `tools/check-javascript-only-scripts.js` passes, and the three edited scripts import cleanly.
- `ci-wait-merge.sh --no-merge` returned rc 0.

**Follow-ups:** #151 is now at `b74c55e`. When this PR is woven onto it, recheck that `lib/common.js` still lines up.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1022289 cached reads)
- Output: 6777 tokens
- Cost: $0.8307898
- Wall-clock: 389s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
