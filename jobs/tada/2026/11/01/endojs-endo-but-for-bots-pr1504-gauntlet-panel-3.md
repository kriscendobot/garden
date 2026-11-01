PR #1504 failed panel round 3 with a must-fix verdict. `panel.sh` exited 0 and posted exactly one review, as a COMMENTED review because the PR is self-authored.

**Setup:** I pinned the PR's base (`9a14ddf660912ed624e2d9047671d43e3a2f0cec`) and head (`4fd495067966e5f7a45bf1aa3e9e49dac9b2bad0`, `endojs/build/daemon-agent-tools-sandbox-shell`). I checked the head out detached in an isolated project worktree and confirmed `git rev-parse HEAD` matched it.

**Style pre-pass:** the read-only probes (`pre-push-gates.sh --no-auto-fix --probes-only`) exited 0. The only output was one non-blocking warning, for a 7-line prose comment at `packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs:45`. It was flagged for the pruner seat to decide whether the comment earns its place.

**Panel:** one round in single-round mode against the pinned base. Three probes added seats: the new-mechanism probe and the repeated-must-fix probe each brought in the decomplector, and the PR-body concision probe brought in the pruner.
- The review was posted at 2026-11-01T02:39:04Z under the "Must-fix before merge" heading.
- **Curator, must-fix:** the published `@endo/exo-shell` now lists the private `@endo/host-spawner` (version 0.0.0) under `dependencies`. Its `types.ts` also re-exports `Spawner`, `ProcessLike` and `SpawnerOptions` from that private package. The fix is to keep the structural types in `exo-shell`, or make `host-spawner` public and give it its own release path.
- **Curator, should-fix:** renames and removals on the public type surface aren't called out.
- The full aggregate is in the posted review on the PR.

**Process note:** my first panel launch was a background task with a 10-minute timeout that could have killed it mid-round. I stopped it about a minute in, killed its leftover child processes, and relaunched once, detached, polling in the foreground. The stopped launch posted nothing, and the PR has exactly one review in this window.

No fixes, no un-draft, no garden changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (685999 cached reads)
- Output: 3629 tokens
- Cost: $0.6701077999999999
- Wall-clock: 218s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
