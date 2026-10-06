I applied the round-2 panel fixes to endojs/endo-but-for-bots#1428 and pushed them, and CI is green: all 14 checks passed, with `ci-wait-merge` exiting 0.

**Fixes**
- **PR body (the binding must-fix):** I rewrote the body to include every heading from the upstream template in template order (Description, Security, Scaling, Documentation, Testing, Compatibility and Upgrade Considerations). The Compatibility section explains that the `configstore` (now 5.0.1) and `nconf` (now 0.13.0) resolutions jump a major version, but only declare versions the lockfile already installed. The Documentation section names the `scripts/pack-all.mjs` comments.
- **`scripts/pack-all.mjs` comment** (raised by archivist, saboteur, pruner and corner-prober): commit `042ec99966` only changes this comment, and the `git clean` commands are unchanged.
  - I removed the wrong claim that `-e '!node_modules'` makes `git clean` descend into `node_modules`.
  - The comment now gives the real reason once: `-fX` without `-d` never removes an ignored directory, so the plain `-e node_modules` and `-e /dist` only repeat `.gitignore`. It also warns never to add `-d`.
  - I deleted the step-6 sentence that contradicted this.
  - I pushed it with `safe-push-pr-head.sh` (`c6af9f0aa8` → `042ec99966`).
- **Title (should-fix):** retitled to "fix: restore hardened yarn install and preserve install state across git clean".
- **Scribe's ask:** I posted a top-level comment on the PR naming the new head and how each item was handled.

**Not done:** the integrator suggested dropping or squashing the empty commit `75c4c7de2e` when the PR leaves draft. It was comment-only, so I left the history alone for the un-draft or merge stage. I did not re-run the panel; panel-3 is the driver's job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1428-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (616407 cached reads)
- Output: 4903 tokens
- Cost: $0.6708694
- Wall-clock: 637s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
