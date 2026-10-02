The 2026-10-02 recheck sweep for `endojs/endo-but-for-bots` found nothing due, so no verdicts were executed and no PR was touched.

- **Ledger:** the case-insensitive grep recovered 115 entries. No embargo row is due or still active. The latest rows all match current GitHub state:
  - #1350 was merged.
  - #1351, #1353 and #1354 were closed as rejected.
  - Dependabot closed #1352 itself, and it was never embargoed.
- **Live state:** checked just now, `dependabot[bot]` has no open PR on the repo.
- **Schedules:** no per-PR recheck schedule is left in `schedules/`. The daily backstop `dependabotany-recheck-endo-but-for-bots` is still installed, as it should be.
- **What changed:** I added one short ledger entry, `journal/entries/2026/10/02/024611Z-message-botanist-eb8eb8.md`, recording this sweep. No garden code changed and nothing was pushed to `main2`.

**Follow-up:** this sweep was dispatched even though there were no open Dependabot PRs and no due rows. That is exactly the quiet day that `dependabotany-preflight.sh` is supposed to skip. The likely cause is the preflight's fail-open path, where a GitHub or ledger read error makes it dispatch anyway. Worth checking if it keeps happening.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20261002-020528.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (653646 cached reads)
- Output: 2646 tokens
- Cost: $0.6928091999999999
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
