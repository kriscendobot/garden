**pr-readiness-arc-classify-20261007: done**

I classified all 115 PRs and pushed the table to journal `projects/garden/pr-readiness-arc-classification-20261007.md` on `origin/journal2`. A fresh fetch of `journal2` shows all 115 rows.

**What I did**
- Fetched each PR's title, body, branch, base and files with `gh`. All 115 are still open and not draft. Where GitHub reports a review decision, it matches the one in the job spec.
- Took arcs from `config/arc-budgets/` and the foreman mandate. Took milestones from journal `plan/milestones/`, matched through each PR's design record in `plan/README.md`.
- Checked for supersession against upstream `endojs/endo` PR states and the current `llm` and `master` branches. Nothing was closed, posted or planned.

**Per-arc counts**

| arc | total | gauntlet | verify-changes | flagged superseded/duplicate |
|---|---|---|---|---|
| minion-town-mcp-ocapn | 6 | 5 | 1 | 0 |
| minion-town-git-remote | 0 | 0 | 0 | 0 |
| minion-town-ui | 1 | 1 | 0 | 0 |
| endo-ocapn-background | 13 | 10 | 3 | 2 |
| moonshots | 12 | 10 | 2 | 1 |
| garden-upkeep | 7 | 6 | 1 | 1 |
| garden-book | 0 | 0 | 0 | 0 |
| endo-backlog | 0 | 0 | 0 | 0 |
| unallocated | 76 | 57 | 19 | 10 |
| **total** | **115** | **89** | **26** | **14** |

By milestone: M1 7, M2 9, M3 8, M4 7, M7 2, M9 7, M10 2, M11 8, and 65 with none.

**Choices children 2 and 3 should know about**
- **endo-backlog is empty on purpose.** Per the spec it covers only gauntlets already staged, so PRs that serve no named thread went to `unallocated`. That is 76 PRs, mostly upstream SES and compartment-mapper mirrors, Familiar release (M1), Chat (M9), and lint.
- **garden-upkeep** holds the CI fixes that keep the fleet's own builds green, plus minion.town deploy-script hygiene. This matches the infra section of `review-priorities.md`.

**Flagged in the `superseded?` column (none closed)**
- **Already landed:** endojs/endo-but-for-bots #253 (endojs/endo#3258 merged), #329 (`docs/spackle.md` already on `llm`), #334 (endojs/endo#2887 merged), #469 (the upstream tip is already in `llm`), and #1089 (range attenuation was reimplemented on `llm`).
- **Partly overtaken:** #347 (its own body says the change is mostly on `llm`), #756 (overlaps #1355), and #887 (overlaps #1146).
- **Duplicate pairs:** #235 and #303; #355 and #509.
- **Other:** #847 has an empty diff (a diagnostic PR), and kriscendobot/moddable#1 overlaps moddable#2.

**Worth a look before planning a gauntlet**
- #288: #738 merged a rename to `cbor-frame`, yet `llm` has no `packages/cbor-frame`.
- #79 and #356 carry diffs inflated by stale bases and need a weave first.
- #251 mirrors upstream endojs/endo#2404, which was closed without merging, so the mirror may no longer be wanted.

The arc calls for the weaker cases (#241, #508, #825, #1156, #1343, #1416, minion.town#37, #153) are judgement calls; each row's `why` column gives the reasoning. No follow-ups were posted; children 2 and 3 act on the table.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr-readiness-arc-classify-20261007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2589883 cached reads)
- Output: 26421 tokens
- Cost: $2.0304926
- Wall-clock: 442s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
