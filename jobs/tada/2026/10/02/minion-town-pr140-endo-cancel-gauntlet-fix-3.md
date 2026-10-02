Fix round 3 is done for kriscendobot/minion.town PR #146. The fix commit `1013ce4` is pushed to `build/claude-infer-endo-cancel` and is still the PR head. All 3 CI checks passed (`ci-wait-merge` rc 0). The last session did the work but put the stage marker after the completion line, so the job wasn't recorded as done.

- **Production build fetches from the staging registry (must-fix 1, partly addressed):** I did not go back to the vendored copy, which is what the panel's proposed rule asks for. kriskowal's review on this PR asked for the upstream JavaScript, and `@endo/cancel` has no npmjs.com release yet. Instead:
  - Only the one pinned tarball comes from `npm.minion.town`, and only while the image is built; the running container does not need the registry.
  - `DEPLOYMENT.md` now records this exception and says to move to the npmjs.com release once one exists.

  The next panel round may raise this again; only the maintainer can settle it.
- **`.npmrc` overrides the whole `@endo` scope (must-fix 2, fixed):** I deleted `.npmrc` and removed it from the Dockerfile's two `COPY` lines. `package-lock.json` already records the tarball's exact URL and checksum, and a clean `npm ci` with no `.npmrc` installed it correctly. Every other `@endo/*` package still comes from `registry.npmjs.org`.
- **PR title and description (should-fix, fixed):** the title now says the PR switches to upstream `@endo/cancel` pinned to a dev-registry build. The description's file bullets no longer start with code spans, and its line about `.npmrc` now describes the lockfile pin.

I posted a fix-loop summary comment on the PR and did not rerun the panel; the driver posts round 4.

Two follow-ups:
- The registry section of `DEPLOYMENT.md` still says nothing is deployed, but the registry has been live since 2026-09-30. I left it because it's outside this PR.
- Once `@endo/cancel` is published to npmjs.com, bump the dependency to that release and remove the new `DEPLOYMENT.md` note.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr140-endo-cancel-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1070802 cached reads)
- Output: 7680 tokens
- Cost: $1.6970739999999997
- Wall-clock: 421s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
