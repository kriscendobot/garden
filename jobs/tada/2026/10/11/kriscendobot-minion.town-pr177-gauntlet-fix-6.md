Fix round 6 for kriscendobot/minion.town PR #177 (draft design `designs/git-remote-served-clip.md`) is done. I fixed the one must-fix from the panel-6 review (5482435516), pushed it to the PR head as commit `8b729cb`, and CI is green (`ci-wait-merge.sh` returned 0, 3 of 3 checks passed).

**Must-fix (skeptic): old gateways serving new records wrongly during a deploy (§ 3).** Today's `validateVhostRecord` ignores fields it doesn't know and accepts any record with a valid top-level `contentRoot`. So a gateway that hadn't been upgraded, or one rolled back, would have served a partition's raw tree as `immutable` for a year, and `listSites` would have listed partitions as ordinary sites.
- **Record change:** the Model S record now puts `contentRoot`, `entryRoot` and `roots` inside a `served` object. Neither the `partition` record nor the `alias` record carries a top-level `contentRoot` or `directoryId`. Today's validator therefore rejects both: an old gateway answers 404 on the host and `listVhostRecords` skips the file, rather than caching stale bytes.
- **Deploy order:** upgrading the gateway before git-remote is still the rollout plan, because it avoids a window of 404s. Correctness no longer depends on that order.
- **Build precondition:** the design now says the build must not add a top-level `contentRoot` or `directoryId` to either record kind.
- **New test in § 10:** a frozen copy of today's validator, used as a test fixture, must reject both record kinds. Today's `listVhostRecords` must skip them, and an old gateway must answer 404 on a partition host, never `200 immutable`.

**Should-fix items I also took:**
- **Copyeditor:**
  - "the primer" is now defined at first use, and the § 10 test plan lists it as something increment 5 ships.
  - "powers plane" is now glossed: the `back` CapTP leg, as opposed to the content plane.
  - "succeed" is now glossed using #142's meaning: publish a successor clip at a fresh origin and redirect to it.
  - The Q3 recommendation now reads "do not stage; ship the tier if Q1 picks Model S."
- **Pedant:** I reflowed the over-long "Atomicity unit" and "#142 Q8" paragraphs. The other over-long lines the pedant listed are untouched.

**Should-fix items I left for later rounds or the maintainer:**
- **Decomplector:** `roots` does three jobs (coherence window, list of runnable roots, GC pin set) and should bound each one separately. Q3 should be re-costed now that the tier has been hardened over five rounds.
- **Critic:**
  - State whether existing partitions are served by default when backfilled, given that unpublish is permanent.
  - Bound blob-store growth, or make #93 a predecessor of increment 5.
  - Throttle mass re-projection when `projectionVersion` changes.
  - Pin down how a path is looked up across the entry and raw manifests.
- **Skeptic:** downgrade the timing figures to estimates or cite a measurement, and add a corpus check that the rewrite is actually applied on real sites.

No garden (main2) changes. Panel-7 is up to the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr177-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1717023 cached reads)
- Output: 9822 tokens
- Cost: $1.1094926
- Wall-clock: 942s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
