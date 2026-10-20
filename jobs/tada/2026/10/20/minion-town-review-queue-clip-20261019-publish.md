The minion.town review-queue clip is published and verified at https://tdqbaf4dj7yp44dx72ovmpwh7gfkpq7fhguawk6bvz45kjqrtqxq.ocap.site/, and the report is in the maintainer inbox.

**What I did**
1. **Checked the queue against live PR state.** One ranked PR had merged: kriscendobot/minion.town#207 (2026-10-20T01:26Z). I dropped that row from `queue.json` and pushed it to main2 as `3e6412f38ed`. The other 14 ranked PRs are still open, and the parked jobs the queue refers to are all still on the plan board. I added no finding text.
2. **Built and published.** `build.py` exited 0 and every scrub check passed. The page shows CI status for each PR, with no "CI unknown" pills. `publish.sh` published under the inert pet name `minion-town-review-queue-inert`, then fetched both files back and they matched the local copies byte for byte.
3. **Checked the page at phone width (390px) in light and dark.** The first publish was about 30px too wide (419px). The cause was a 40-character commit SHA in a parked-job title that couldn't wrap. I fixed `styles.css` so long text wraps inside the cards and pushed it to main2 as `6761cdb0d0c`. After republishing, the page is exactly 390px wide in both themes. The command boxes still scroll sideways on their own, which is intended.
4. **Unpublished the first clip** (`qyczu74o…`); it now returns 404.
5. **Sent the report** to the maintainer inbox. It has the URL, the generation time (2026-10-20T02:33:14Z), the minion.town main commit shown on the page (`ea08cf055085`), the 15-item ranking with one-line reasons, and the scrub checklist.
   - On top of build.py's scrub, I searched the published file by hand. The only hits are the word "secrets" in two public PR titles (kriscendobot/minion.town#183 and #191).
   - The first send was rejected because the inbox requires `owner/repo#N` references, so I qualified them and it went through.

**Follow-ups**
- The clip is a snapshot. To refresh it, re-run `scripts/jobs/minion-town-review-queue/publish.sh` on a host that has the minion.town MCP credential, then unpublish the old URL.
- The "Parked jobs waiting on you" section, which build.py fills from the journal, also lists a few parked Endo jobs that aren't specific to minion.town. I left that as is, since it isn't a scrub problem.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-review-queue-clip-20261019-publish.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1703544 cached reads)
- Output: 9898 tokens
- Cost: $1.0969008000000002
- Wall-clock: 246s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
