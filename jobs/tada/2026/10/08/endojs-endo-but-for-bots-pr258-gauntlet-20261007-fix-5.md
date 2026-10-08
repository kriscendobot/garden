Fix round 5 for endojs/endo-but-for-bots PR #258 is done: I applied the panel's two must-fix items, pushed one follow-up commit, and CI came back green on all 16 checks.

**Panel verdict:** this was review 5456910143 on head `1e2312f8`, with must-fix findings from the integrator and corner-prober seats.

**What changed**
- **Store cache key (corner-prober must-fix):** the key now includes `GUIX_TARBALL_SHA256`. Before, if upstream re-published the installer under the same version, the job could restore an old snapshot onto the new installer. The package list is now hashed (sha256, first 16 characters) instead of pasted into the key, which also covers corner-prober's should-fix about key length and characters. A new step, "Compute Guix store cache key", builds the key.
- **Wait for the daemon after an extract (corner-prober):** after restoring the cache, the job now waits up to 30s for the Guix daemon to be ready. Before, the next step could talk to a daemon that hadn't finished starting.
- **Delete the archive after use (saboteur):** the archive, which can be up to 4 GB, is removed once it has been extracted or saved, so it doesn't sit on the runner disk during the test.
- **Comment wording (integrator):** the workflow comment no longer says "Iteration III"; it names the neighbouring measures directly.
- **PR description (integrator must-fix):** I rewrote it from the current code. It now says the archive is uncompressed, `actions/cache` handles integrity, there are no new permissions, and gives the real cache key. I removed the empty "Considerations" sections and the outdated timing table (the pruner's request). It also now states that a saved cache is only reused by re-runs of the same PR or manual runs on the same ref, not by other PRs.

**Pushed:** commit `d07ab3401c` with `safe-push-pr-head.sh`. `actionlint` raised nothing on the lines I changed; its remaining warnings are on older lines.

**Should-fix items I left alone (possible follow-ups):**
- Add a `push` trigger on master, or only save the cache from non-PR runs, so other PRs can reuse it. This would also stop several open PRs from filling the repo's cache quota (saboteur 1 and 2).
- Check that the worst-case snapshot time fits the 45-minute job timeout (saboteur 3).
- Remove the job-level `permissions` block (integrator 3). I kept it because an earlier commit added it for zizmor.
- Squash the commits into logical changes (integrator 2). That means rewriting history, which this stage doesn't do.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1024439 cached reads)
- Output: 7427 tokens
- Cost: $0.9212198000000001
- Wall-clock: 588s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
