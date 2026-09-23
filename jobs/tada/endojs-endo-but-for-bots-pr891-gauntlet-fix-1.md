Fix stage complete: panel round-1 must-fix items applied, head unblocked, CI green.

## What I found on resume

A prior attempt of this job had already applied and pushed the panel's must-fix items as `701eaca1d` ("design(zone): apply panel round-1 must-fix items"). But CI had **zero runs** on that head for 13 hours, and the job had already been reaped twice. Root cause: the PR's `mergeable_state` was `dirty` — the head was based on `b377b0ed0` (2026-07-30) while `llm` had moved 5 weeks. GitHub cannot compute `refs/pull/N/merge` for a conflicted head, so `pull_request` workflows never dispatch and the rollup stays `[]` forever. `ci-wait-merge.sh` reads an empty rollup as "checks not attached yet" and times out at exit 4 = still-pending, which re-posts this same stage — an unbounded loop that no amount of waiting could break. (Closing/reopening the PR did not help, as expected.)

## What I did

**PR #891 (endojs/endo-but-for-bots, head `kriscendobot:design/endo-zone`)**
- Rebased both commits onto current upstream `llm` (`27a892a99`), resolving four conflicts in `designs/README.md` — all index-arithmetic collisions, none touching `designs/endo-zone.md`:
  - recently-added list: kept upstream's entries plus the `endo-zone` entry
  - totals block: kept upstream's lineage, appended a 2026-09-04 note (Proposed 39→40, designs 196→197)
  - estimate table: kept both the upstream `endo-workflow` row and the `endo-zone` row
  - milestone summary: folded `endo-zone` into M10 (7→8) and bumped Total remaining 65→66
- `designs/endo-zone.md` is **byte-identical** to the reviewed post-fix version — the rebase changed no design content.
- Pushed via `safe-push-pr-head.sh --mode rewrite`: `701eaca1d` → `e2a7d774851`.
- CI: `rollup-terminal total=5 failed=0 → CI GREEN` (browser-tests, lint, build, zizmor, test all SUCCESS). `mergeable: MERGEABLE`, still draft as expected for a gauntlet mid-stage.

Panel must-fix coverage verified against the round-1 verdict: critic (Phase-2 cross-org coordination + fallback + open question), skeptic (agoric-sdk source citation; cross-org risk; maker-throws un-happy path + test scenario), decomplector (`detached()` as a type-level brand the durable-write path rejects), ergonomist (`makeAdapterZone` named with an options bag; `isStorable` default-and-override relationship), pedant (title, `Zone` capitalization, citation form), plus copyeditor and novice should-fixes.

**Garden (`main2`, commit `8515009530`)**

Encoded the trap that cost this job two reaper cycles: `ci-wait-merge.sh` now reads the `mergeable` field its rollup query already fetched but discarded, and when an empty rollup pairs with `CONFLICTING`, reports it terminal (exit 3, the needs-a-human code) naming the required rebase, instead of polling to deadline and re-enqueueing forever. Two consecutive `CONFLICTING` reads are required — `mergeable` is computed asynchronously and a single sample is not an answer. The in-place auto-rebase that would fix this is merge-mode-only by design (a `--no-merge` probe must not mutate the PR), which is precisely why the probe needs its own way to say "this cannot become green". Added tests T26/T27; suite 60/60 pass.

## Follow-ups

- The garden fix is on `main2` but not deployed — it lands on this host's next `deploy-garden.sh`.
- `designs/README.md`'s counting lineages have drifted independently upstream (the "Current totals (2026-08-29)" header block does not reconcile with the later per-rebase delta notes). I continued the most recent delta lineage rather than re-groom the index, which is out of this stage's scope.
- Per the stage contract I did not re-run the panel; the driver posts panel-2 against head `e2a7d774851`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr891-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 2 host(s)
- Input: 264 tokens (12095705 cached reads)
- Output: 74066 tokens
- Cost: $10.784976250000001
- Wall-clock: 3126s
- Model(s): claude-opus-4-8 ×7

<!-- garden-usage-end -->
