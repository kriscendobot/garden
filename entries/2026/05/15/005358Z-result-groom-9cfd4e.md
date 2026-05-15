---
ts: 2026-05-15T00:53:58Z
kind: result
role: groom
project: endo
worktree: dispatches/groom--9cfd4e/project
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/13/210550Z-result-groom-6113f3.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 236
    role: superseded
---

# Result: groom full pass on `designs/README.md` (llm branch)

Commit on llm: `56d3275ea` "docs(designs): groom roadmap — 2026-05-14 recalibration, M1 raise of endo-gateway, status updates" (-127 / +87 net; 214 lines changed).
Tip before push: `93c649130` (#255 ocapn-guile-interop ci). Push succeeded against fresh fetch (no concurrent groom intervened).

## Sub-mode

Full grooming pass (not targeted, not drift-check). The dispatch said "recalibrate + update the roadmap" after heavy weekly activity, which matches the full procedure: status reconciliation, velocity recalibration, roadmap re-projection, dependency-graph maintenance, no open-questions append needed.

## Inputs read

- Prior groom result `entries/2026/05/13/210550Z-result-groom-6113f3.md` (the targeted M1 raise of `endo-gateway`; never merged via PR #236, so its intent is now folded directly into llm).
- Merged-PR history on `endojs/endo-but-for-bots` from 2026-05-08 (last calibration) through 2026-05-14: 16 implementation PRs, 8 design-only PRs.
- Each design file's metadata for the rows I touched (statuses, dates).
- `git log --since='2026-05-08' --diff-filter=A -- designs/` to find the two new shim designs added 2026-05-06 (hardened-text-codecs-shim, hardened-url-shim) that were absent from the summary table.

## Substantive diff (one file, one commit)

`designs/README.md` only. Changes by section:

- **Header `Last updated`**: 2026-05-11 → 2026-05-14. "See also" reshaped: added "Recently added or revised" subsection naming the two new shim designs; folded older entries into "Earlier additions" with updated annotations.
- **Summary table**:
  - `unhandled-rejection-display`: Proposed → **Implemented** (PR #187, 2026-05-12).
  - `break-dev-dependency-cycles`: Proposed → In Progress (Cuts 2-4 merged via PRs #209, #210, #211; Cuts 1 and 5 open).
  - `hex-package`: Not Started → In Progress (`@endo/hex` package landed 2026-04-28; ocapn sites migrated via PR #223; daemon/relay-server still pending).
  - Added rows: `hardened-text-codecs-shim`, `hardened-url-shim` (both Not Started, created 2026-05-04).
  - **Totals**: 27/15/43/9 → 28/17/44/7 (Complete/InProgress/NotStarted/Proposed), 104 → 106 designs.
- **Dependency graph**: `endo-gateway` (node `egate`) inserted in the Remote Access subgraph between `gauth` (bearer-token-auth) and `ddock` (docker-selfhost).
- **Milestone 1 table**: added `endo-gateway` (Proposed) and `break-dev-dependency-cycles` (In Progress) rows; expanded `endo-bytes` annotation to cite PRs #227 and the immutable helper follow-up; rewrote `hex-package` annotation to cite the ocapn migration via PR #223.
- **Size and Time Estimates**:
  - Calibration round 2026-05-08 → 2026-05-14. N=13 new S impl PRs, 3 new M, 1 new L observed since the prior round (cumulative S=18, M=10, L=2).
  - Per-size ratios: S 0.64 → 0.70, M 1.20 (unchanged), L 1.53 → 1.21 (relaxed from 1.5x to 1.3x with the new `@endo/sandbox`-confines-`@endo/genie` data point #148).
  - Review-queue median elapsed-since-original-branch: 13.9 → ~21 days (the 2026-04-23/04-24 bot-forwarded batch still mostly unreviewed).
- **Per-Design Estimates**: new rows for `endo-gateway` (L, 1.5-3w, M1), `break-dev-dependency-cycles` (M, 3d, M1), `unhandled-rejection-display` (S, 1d, out-of-milestone diagnostic).
- **Summary by Milestone**: M1 12 → 14 remaining, effort 8-10w → 10-13w, plus review 12-15w. Cumulative total 50 → 52 items, 51-70w → 53-73w.
- **Timeline**: Gantt M1 bar 5w → 12w (incorporates queue carry). Cumulative duration table re-projected. Target-date language shifted to ranges ("Late July to mid-August 2026") for honesty given the 2-week-wide window.
- **Progress as of**: rewritten to 2026-05-14, enumerating the week's 17 impl PRs and 8 design-only PRs, and the M1 raise from 12 → 14.

## What I did not change

- The estimation methodology section (verbose Feb 15-Mar 2 narrative) was left intact. It's historical; the calibration round above supersedes it operationally.
- The Mermaid graph's other subgraphs were untouched. The week's design PRs (cli-edit-verb, cli-store-verb-text-modes, etc.) merged design-only PRs; the new edges they introduce are already absorbed by their existing M3/M4 placements.
- PR #236's branch (`roadmap/gateway-m1`) is now stale: this commit on llm contains its single substantive edit plus much more. PR #236 should be closed as superseded; I did not close it (no per-action authorization in this dispatch's brief; the liaison can close it on the next pass or leave it for the next steward cycle close).

## Status drift surfaced (no separate process commit needed)

One status drift between a design file and the README is preserved as-is:

- `daemon-content-store-gc.md` metadata says `Status: Not Started`; README says **Complete** (PR #99 landed). README is authoritative here (the implementation has merged). The design file's metadata should be updated by the design's author on its next edit; it is below the threshold for a groom-side fix because (a) only the maintainer should flip an upstream-authored design's status field, and (b) the README is what feeds the roadmap projection.

No open-questions journal `message` entry filed for this dispatch: every reclassification was mechanical (PR-evidence-driven), and the M1 raise of `endo-gateway` was a recorded directive applied verbatim. If the maintainer wants `daemon-content-store-gc.md`'s metadata reconciled, that's a one-line designer dispatch.

## Push

`git push origin HEAD:refs/heads/llm` succeeded first try (FETCH_HEAD matched parent; no concurrent groom).

## Identity

Author and committer pinned by `dispatch-prepare.sh` to `endolinbot <main.barn5084@fastmail.com>` for this host's bot identity. No `Co-authored-by` / `Generated with [Claude Code]` trailers.

Self-improvement: the M1 table has been growing during recent rounds (added `endo-bytes`, `endo-gateway`, `break-dev-dependency-cycles`, `unhandled-rejection-display` in the last 10 days); the milestone is starting to absorb out-of-band hygiene work alongside the intended Remote-Access scope. This is below the structural-lesson threshold for a role/skill edit, but worth flagging on the next maintainer review of the roadmap: "Is M1 the right home for build-system hygiene like `break-dev-dependency-cycles`, or should an M0.5 / M-side bucket exist?" Logged here for the next groom (or liaison) to surface.
