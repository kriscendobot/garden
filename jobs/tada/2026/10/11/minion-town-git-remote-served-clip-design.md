# Completion report: `minion-town-git-remote-served-clip-design`

The design is up as draft PR **kriscendobot/minion.town#177** (https://github.com/kriscendobot/minion.town/pull/177). It adds one file, `designs/git-remote-served-clip.md` (slug `git-remote-served-clip`), on branch `design/git-remote-served-clip`. The base is a frozen snapshot, `main-c7bdf20`, of `main` at c7bdf20. Nothing was built.

## What the design settles
- **Stable host (parent OQ 10).** A partition's clip id is `sha-256("minion-git-partition-clip-v1\n" + partitionId)`. It is computed once when the partition is created, stored, and never recomputed. It fits the existing 52-character host label and `vhosts/` file layout. An operator-only override covers the vitals clip's planned switch from polling to push (Q6). Guests can never set it.
- **How the gateway finds the content, with only content-store access.** The git-remote process writes an ordinary `vhosts/<clipId>.json` record marked as a partition, as its last step and atomically. The gateway reads it with the file-based lookup it already has. It gets no access to partitions, refs, or the git-remote process. Mutable records get a shorter cache time (5 s).
- **Background repair sweep.** Before each push, the router writes a "pending" marker. A sweep every 30 s redoes the projection for any marked partition, and a full sweep runs hourly and at startup. Re-running a projection always gives the same result. Failures back off, and visitors keep seeing the last good version.
- **Two cache tiers for coherent deployments.** When a push is processed, links to scripts, styles and images in HTML are rewritten to `/.content/<root>/…` and cached forever. Ordinary page URLs revalidate on every load. Page-to-page links are left alone, so copied links stay clean. `/.content/` only serves versions this partition itself published, which stops one partition's code from running on another's host. This rewrite replaces the parent design's "reject absolute asset paths" rule.

## Reconciliation and costs
- The main choice is left to the maintainer as Q1:
  - **Model S (recommended):** one stable host whose content changes. It matches the merged #41 and #49 designs, but it is a declared exception to #88's rule that a clip's content never changes.
  - **Model P:** a new, unchangeable host for every push, behind a stable redirect. It fits #88, but it reverses the earlier #39 decision about copied links, and the site's browser storage resets on every push.

  A comparison table covers both models plus a cheaper variant without the cache tiers. The design also notes that kriskowal's 2026-10-02 comment on #85 accepted in-place upgrades, so #88's direction is not settled.
- **#142:** the partition fits #142's per-clip controller model (its "registration id" is the clip id). Unpublishing writes a permanent marker that the sweep respects.
- **#170:** the lesson about fragment cleanup carries over. Under Model S, holding a write URL also gives access to the site's browser storage.
- **#93:** its cleanup of unused content must keep every version that is still being served.
- The design includes an ownership map and a test plan. There are 8 open questions, each with a recommendation.

## Checks
- The mermaid diagram parses (`mm-1.mmd OK flowchart-v2`).
- The cliché and spelling scans on the diff found nothing.
- The PR is a draft and contains only the design file.

## Follow-ups
- The build is increment 5, `minion-town-git-remote-served-clip`, which is already parked waiting on this design. It should build whichever model the maintainer approves.
- The design gauntlet is staged automatically when this job completes. I did not un-draft the PR or post a gauntlet by hand.

<!-- garden-design-build-handoff: successor=minion-town-git-remote-served-clip-design-build state=recheck:kriscendobot-minion.town-pr177-gauntlet pr=https://github.com/kriscendobot/minion.town/pull/177 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-git-remote-served-clip-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (4632038 cached reads)
- Output: 43729 tokens
- Cost: $3.1981795999999996
- Wall-clock: 608s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
