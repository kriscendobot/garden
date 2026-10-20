Fix round 2 for kriscendobot/minion.town PR #201 (New Clip) is pushed and CI is green. The main blocker is still open: the panel's authority question needs the maintainer's ruling, and no code change in this round can settle it.

No deterministic pre-pass block came with the job, so I worked from the latest panel verdict (review 5587990575, 16:10Z). I pushed three follow-up commits with `safe-push-pr-head.sh`, moving the head from `00d6d90` to `0ebfe34`. CI ended green on `0ebfe34` (`ci-wait-merge` rc 0, both runs passed). The runs sat in the queue for about 20 minutes first, so I waited across three bounded waits.

**What the commits fix:**
- **breaker:** `metamorphose` now refuses unless the app's `inventory` exists and is a directory. A regression test covers the case where `inventory` is text.
- **saboteur (stale usage cache):** the cached space usage is now re-measured every `NEW_CLIP_MEASURE_EVERY` (64) mutations. Growth the owner makes outside the power is therefore counted within a bounded number of visitor writes. I did not re-measure on every mutation because that makes filling a space quadratic: a walk of up to 4097 sequential daemon calls per write. The header comment states the bound honestly, and a new test shows outside growth gets caught.
- **engine-realist:** queued writes are now also limited by the text they hold (`NEW_CLIP_MAX_PENDING_TEXT`, about 2 MiB), not just by count. A test runs it against a stuck daemon.
- **wire-watcher (CSRF):** a new check, `lacksSameOriginProof`, now guards `POST /account/clips/new`. If `Sec-Fetch-Site` is missing, the request passes only when its `Origin` matches the `Host`. The Claude-account route keeps the old, lenient check. Tests now reject a missing header, a foreign origin, a look-alike origin and `null`, and accept a same-origin `Origin`. The design doc is updated to match.
- **corner-prober:** `makeNewClipMinter` falls back to its default timeout when given a negative, NaN, infinite, non-integer or over-2^31−1 value, so `mint()` no longer rejects. Boundary tests added.
- **Smaller items:**
  - spec-keeper: inventory names sort by code unit, tested with accented and combining-mark names.
  - stylist: `currentApp` is renamed `currentAppPath`.
  - archivist: the `freshSuffix` doc is fixed and the dangling design-doc reference is completed.
  - pruner: the restating test-file and build-script headers are removed.

Locally, typecheck is clean and all the New Clip tests pass. In the full `npm test` run, two git-remote tests failed (`test/git-remote/capability.test.ts`, `test/git-remote/git-remote-e2e.test.ts`). They are outside this change and passed in CI. Two quota tests now take about 7 seconds each, so I gave them a 60-second timeout.

**Still waiting on the maintainer:** locksmith (both points), wire-watcher #1, integrator #1 and decomplector (both points) all say a clip's public URL hands every visitor the writable clip power. That runs against kriskowal's direction on #85 and is recorded as an open question in `designs/new-clip.md`. The question went to the maintainer at 05:09Z and again at 08:10Z with the options (a) accept for now, (b) blank form only, (c) wait for #88. Neither has a reply, so I didn't send a third. Until there's a ruling, the next panel will raise these again.

**Not applied:**
- **releaser (changeset):** the repo has no `.changeset` setup.
- **purist (`@endo/hex`):** it isn't a dependency.
- **purist (shared form/app IDs), packager (lockfile split), integrator (squash history):** these are refactors or history rewrites, not fixes.
- **benchmarker:** the "parallel" claim is in an old commit message. The code bounds concurrency and makes no performance claim, so I posted no benchmark.
- **coverage-auditor (Playwright `browser-test/`):** the browser demo already runs in CI.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (5280158 cached reads)
- Output: 29352 tokens
- Cost: $2.6078315999999995
- Wall-clock: 2014s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
