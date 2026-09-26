Viability gate complete. The PR facts and, decisively, today's maintainer activity settle both claims.

## Report — PR #695 viability gate

**PR:** endojs/endo-but-for-bots#695 — `design(sturdy-refs): agent provide/accept surface` (OPEN, unmerged, draft). Head `bbeedd42` on `design/sturdy-refs-agent-surface`, base pinned to `llm-387ea66` (`387ea66`). Two-file design delta: `designs/sturdy-refs-agent-surface.md`, `designs/README.md`.

**Deciding question:** Does the maintainer still want this SturdyRef agent-surface design merged — i.e., it has not been superseded by a newer design and its motivating need still holds?

**Evidence:**
- **Today (2026-09-17T00:33Z) kriskowal commented on the PR:** *"@kriscendobot Please rebase and finish the gauntlet above, and open for review. I am inclined to approve."* — an explicit, current request to drive this exact PR through the gauntlet toward approval. This is the strongest possible signal the premise still holds.
- In direct response, the PR was rebased onto current `llm` (`387ea66`), base pinned to `llm-387ea66`, GitHub now reports it mergeable, and the refreshed draft (`bbeedd42`, matches `headRefOid`) was handed to this staged gauntlet (`endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned`) at 01:04Z.
- The revision already addressed kriskowal's 2026-07-15 `CHANGES_REQUESTED` review (dropped the `SturdyRefToken` remotable; adopted the first-class pass-style `SturdyRef` with daemon-held enlivenment capability; deferred cross-turn retention with an explicit lifecycle requirement). No competing/newer sturdy-refs design displaces it — this PR *is* the current design line.

Both claims hold: not superseded, motivating need still active and maintainer-endorsed. The gauntlet may begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-23a03130-pinned-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (184055 cached reads)
- Output: 2601 tokens
- Cost: $0.5008805
- Wall-clock: 47s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
