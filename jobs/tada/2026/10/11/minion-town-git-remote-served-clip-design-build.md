# Completion report: `minion-town-git-remote-served-clip-design-build`

I built the served-clip design from #177 (Model S) and opened it as draft PR **kriscendobot/minion.town#181** (https://github.com/kriscendobot/minion.town/pull/181). After this change, a push to a git-remote partition is served as a clip at a fixed `<label>.ocap.site` address. Before it, pushed content was copied into the content store but nothing served it.

- **Branch:** `git-remote-served-clip`, one commit (`f24eff0`). It is stacked on the #177 design branch, so the PR also carries the design commits.
- **Base:** the frozen snapshot `main-c7bdf20`, which still equals `main`.
- **Checks:** `npm run typecheck`, `npm run build` and `npm test` all pass locally (1022 tests pass, 11 skipped). On CI the `test` job and the amd64 harness job passed. The arm64 harness job was still pending when I stopped; it builds an image this change doesn't touch.
- **No panel review has run on the code yet.** The review chain is staged automatically when this job completes.

## Decisions taken without the maintainer
The design left eight questions to the maintainer. Under the 2026-10-07 minion.town review inversion, I took the design's recommendation on each, and the PR body lists them:
- **Q1:** Model S, one stable address whose content changes. Model P is not built.
- **Q3:** the cache tier ships now, not staged for later.
- **Q4:** a failed projection never refuses the push.
- **Q5:** unpublishing is permanent.
- **Q6:** no operator override for the clip id.
- **Q2, Q7, Q8:** as written. That means 24-hour / 16-version retention, and the 16 is now configurable.

## What changed
- **Address:** each partition stores a clip id derived once from its partition id. Older partitions get one filled in on first use.
- **Gateway:**
  - There is a new partition record type. A gateway from before this change answers 404 on a partition host rather than caching changing content for a year; a test checks this against a frozen copy of the old record check.
  - Ordinary page URLs are revalidated on every load.
  - `/.content/<root>/…` is cached permanently, but only for versions this partition itself published. That check is what stops one partition's code running on another's address.
  - Partition records are cached for 5 seconds instead of 30.
  - Record files are now written by temp-file-then-rename, so a reader never sees a half-written one.
- **Git remote side:**
  - Each push writes a marker before it runs, so a crash leaves evidence for the repair sweep.
  - Pushes and sweeps share one queue per partition.
  - HTML is rewritten (with parse5) so scripts, styles and images point at the version-pinned URLs. A document with a `<base>` tag, a parse error, invalid UTF-8 or more than 2 MiB is served unchanged, with a warning.
  - Sweeps: a repair sweep every 30 seconds and a full check every hour, with retries backing off up to an hour.
  - Unpublish and purge are applied inside the queue.
  - It refuses to overwrite a snapshot site's record (a review finding on #177).
- **Operator script:** `git-remote-partition.sh` gains `status`, `unpublish` and `purge-root`. These only write requests, which the running service applies on its next sweep. `destroy` now refuses until a served partition has been withdrawn, so no record is left behind.
- **Reserved path:** `.content` is now a reserved top-level folder name, in any letter case.
- **New dependency:** `parse5@7.3.0`.
- **Docs:** a new author and operator guide, `designs/git-remote-served-clip-primer.md`.
- **Tests added:**
  - the HTML rewrite edge cases;
  - the two cache tiers, including refusing another partition's version;
  - retention, purge and unpublish;
  - crash recovery, including a marker from a later push surviving an earlier projection;
  - a failing projection that keeps serving the last good version;
  - a real `git push` end to end: served, pushed again, the served content follows, and the old version stays available;
  - the operator script's box-side code, run locally against a scratch store.

## Gaps and follow-ups
- **No real-browser test.** The design asks for a headless-browser test of a page loading while a push lands. The repo has no browser dependency, so that case is only covered at the HTTP level.
- **Mis-nested tags don't trigger the unchanged-document fallback.** parse5 reports only tokenizer errors (such as a duplicate attribute or an unterminated tag), not mis-nested tags. Those are still rewritten. This doesn't weaken the guarantee, because the HTML standard fixes how mis-nesting is recovered and it can't change where an attribute value starts or ends. A missing doctype is also tolerated, since it only switches quirks mode.
- **Deploy order:** deploy the gateway before the git remote to avoid a brief 404 window. Both ship in the same app build.
- **Local test environment:** two existing tests fail on garden hosts because of the garden's own `git` wrapper on PATH: it changes the exit code for a missing repository, and that broke the existing "propagates a git failure" test. I ran the suites with the garden directory removed from PATH. CI is unaffected.
- **Duplicate job:** the parked `minion-town-git-remote-served-clip` job did the same work as this one and was already handed off to it, so nothing else needs posting.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-git-remote-served-clip-design-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (9929939 cached reads)
- Output: 88143 tokens
- Cost: $5.547623800000001
- Wall-clock: 1420s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
