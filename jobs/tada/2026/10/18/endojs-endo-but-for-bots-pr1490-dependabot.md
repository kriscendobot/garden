I merged PR #1490 (`actions/setup-node` v7.0.0 → v7.1.0) on `endojs/endo-but-for-bots`. The verdict was MERGE-NOW.

**Supersession check:** The PR is not superseded. All 26 `setup-node` pins on `llm` were at v7.0.0, and the PR moves all 26. The head was 1 ahead and 0 behind `llm`.

**Pin and release:** The v7.1.0 tag resolves to `949feb2413d6458794dcd2491c4babbbce0c15c1`, which matches the diff. GitHub's release record shows it published 2026-10-08T02:52:34Z by the same person who released v7.0.0. The 7-day maturity floor passed on 2026-10-15.

**Upstream source (22 commits):** Nothing suspicious.
- Changes: manifest-fetch retry, a `node --version` check after install, absolute `node-version-file` paths, and `mise.toml` support via `smol-toml`.
- The rebuilt `dist/*.js` bundles have no new URL hosts and no new `child_process`, `eval` or `new Function`.

**Advisories:** No `actions`-ecosystem advisories for `setup-node`.
- `brace-expansion` 5.0.12 and `minimatch` 10.2.6 / 9.0.9 are at patched versions.
- `undici` 6.27.0 → 6.29.0 clears GHSA-r53p-7pc4-xj5r.
- The new bundled `smol-toml` 1.7.1 is inside GHSA-r4xh-jqrq-34v2: a medium-severity slowdown when parsing large TOML, fixed in 1.9.0. It doesn't matter here. The repo's 12 `node-version-file` sites only read its own one-line `.node-version` files, so there is no way to feed it a large input.

**What changed:**
- **Verdict comment:** posted at https://github.com/endojs/endo-but-for-bots/pull/1490#issuecomment-6255328424
- **Merge:** CI was 40/40 green on `fbe1c5c2`. `ci-wait-merge.sh --dependabot-auto-merge` merged it at 2026-10-18T21:48:17Z as merge commit `c63bf3d8965b`, and I confirmed the PR state is MERGED.
- **Ledger:** entry posted at `journal/entries/2026/10/18/214840Z-message-botanist-6994f3.md`. The job's slug `endojs-endo-but-for-bots` was refused by `journal-entry.sh`, so the entry uses the project slug `endo-but-for-bots` that earlier ledger rows use.

**Follow-up:** No action needed. A later `setup-node` bump should bring in `smol-toml` 1.9.0 or newer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1490-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1384788 cached reads)
- Output: 9691 tokens
- Cost: $1.0789616
- Wall-clock: 1541s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
