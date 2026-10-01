Panel round 3 on endojs/endo-but-for-bots#1340 came back **must-fix**, and I posted the verdict to the PR as a comment review.

**What ran:** the single-round panel on the PR head `7fa9ac097d` (branch `design/agent-confined-application-makers`), against base `6726b0fba2` (`llm-6726b0f`). `panel.sh` exited 0 and all 10 seats returned.
- **Request changes:** skeptic, decomplector, copyeditor, novice, pruner.
- **Comment only:** critic, ergonomist.
- **Approve:** pedant (with one should-fix), orthographer, thesaurus.

**Review:** I posted a COMMENT review with a "must-fix" header, the same shape as round 2, because GitHub won't accept REQUEST_CHANGES on the bot's own PR. It contains a summary of the must-fix items followed by every seat's full report.

**Must-fix items for the next fix stage:**
- **Skeptic:** the design says `canonical` for a `Mount` reuses the mount's existing `realPath` check, but the methods behind that check are host-private and not on `MountInterface`. The design has to name the capability `@endo/platform/fs` would actually call, or say that this needs new daemon work.
- **Skeptic:** the test plan never covers Yarn `nodeLinker: pnpm`, which is the repo's own linker setting. It should support, reject, or test it.
- **Decomplector:** the layout is recorded in provenance when the formula is created but re-detected at every incarnation. The design should say whether the field the inspector shows is fixed history or a live value.
- **Novice:** define these terms where they first appear: host/guest, facet, formula/incarnation, name hub, and what "confined" guarantees.
- **Copyeditor:** use ASCII `->` instead of `→` in the ownership-map table.
- **Pruner:** trim Design decisions 5 and 6, which repeat the main body. The pruner also asked to remove the PR-body template sections that say nothing applies. I marked that request as overridden in the review, because round 2's template check requires every template heading.

**Should-fix and comment-only items** (all listed in the review):
- **Critic:** the "one worker entry point" claim doesn't hold for the `'archive'` layout, which still goes through the Node worker's own `makeFromTree`.
- **Critic:** `prepareMakeCaplet` is private to the host, so the guest needs its own equivalent.
- **Ergonomist:** `makeArchive` breaks the `makeFrom<Source>` naming pattern, and the `'archive'` layout value shares its noun with `makeArchive`.
- **Pedant:** use relative paths when referring to files in the repo.
- **Skeptic:** add a positive end-to-end test for `node-modules-with-map`.

kriskowal approved the PR at 2026-10-01T20:41Z with "Please conduct and build." That is outside this panel-only stage, so I took no action on it. Whoever drives the gauntlet should reconcile that approval with this must-fix verdict.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (540384 cached reads)
- Output: 3598 tokens
- Cost: $0.6405408000000001
- Wall-clock: 308s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
