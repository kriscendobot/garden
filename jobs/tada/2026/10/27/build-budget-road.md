## Report: build-budget-road

I built `designs/budget-road.md` on `main2` and pushed it in four commits (`1c67f6d64a9` through `89a77e757cb`). It is **not cut over**: the new budget code does nothing until `allocation/road.json` or `config/maintainer-reserve` exists, so the weekly slate and the ramp still decide every budget question in the fleet today.

### What was built, in the job's order
1. **Foreman usage rows** (landed first). The foreman's own `claude -p` calls now write a row to `usage/foreman-<YYYYMMDD>.jsonl` with `role: foreman` and the step's arc. A call whose measurement can't be captured is recorded as `source: none`, never as zero.
2. **`posted_at:`** is now stamped by `post-job.sh` (only into a body that already has frontmatter) and carried through `promote-plan.sh`. `post-plan.sh` already stamped it, and readers fall back to the file's mtime. Both posters warn when `--arc` names an arc that isn't on the road.
3. **`budget_road`** is the single shared function, in the new `scripts/jobs/budget-road.sh`. It computes the fixed 0.90 ceiling, the maintainer's decaying reserve, the two lane reservations, discretion, the pool verdict and per-arc admission, with a two-minute host-local cache. The owning host now publishes `road_w_kris:` and `road_p:` in its `budget/live` snapshot.
   - **`set-road.sh`** is the only writer: `show`, `focus`, `unpin`, `add`, `drop`, `alias`, `lanes`, and `init [--from-slate] [--dry-run]`. Writer verbs need a login on `maintainers/allowlist`. Each write is one commit that regenerates `allocation/mandate.md` and `allocation/README.md`.
   - **`set-maintainer-reserve.sh`** is new; `set-token-backoff-initial.sh` still works and points to it.
4. **Foreman and claim gate.** The verdict words stay `ok`/`backoff`/`unknown`, so `pool_admits` and `claim-job.sh` are unchanged. Once armed:
   - Deferred plans are promoted by lane group, then road rank; plans on a held arc are skipped as `arc-held:<arc>`.
   - The digest carries `allocation/mandate.md` and an `arc_admission` block, and a step for a held arc is refused.
   - One "Budget spent" notice goes out, at most once a day per pool, only when everything is spent; never for a pin or the maintainer's reserve.
   - Non-Anthropic pools stay flat but are capped at 90.
   - I also had to change `orchestrate.sh`, which the design's touch list missed. Without it, every orchestration with an arc would have stalled forever once `init` deletes the weekly arc files.
5. **Accountant.** `accountant-statement.sh` renders a no-approval statement from the road (pools, lanes, the road with what gates "(no planned work)" arcs, open budget requests). Once the road exists, `set-apportionment.sh` refuses and the re-slice nudge goes silent; both keep working until then. `review-docket.sh` shows the road table and sorts by road rank.
6. **Docs.** New operator page `context/operations/road.md`, plus updates to the accountant, foreman, liaison and COMMON briefs, the budget-request, job-board and orchestration skills, the accountant, cybernetics and review-docket pages, the README vocabulary (*show the road*, *focus X*) and CLAUDE.md § Capacity. The three replaced designs are marked superseded or subsumed, pending cutover.

### Tests
- `budget-road-test.sh` (new) passes 48 checks: each formula, the 0.90 ceiling at reset, a pin above 0.90 not lifting it, a pin overriding `ok`, a mid-week holder change, a `go-ahead`-only arc and a blocked chain giving up their lanes, no utilization sample giving `unknown`, unknown calibration keeping the maintainer's reserve whole, codex staying flat at 90, the unarmed fallback, promotion order, the statement, and `set-road.sh` checks.
- `foreman-budget-road-test.sh` (new) passes 8 end-to-end checks.
- `foreman-provider-order-test.sh` passes 46/46 and `orchestrate-test.sh` 83/83.
- Of 69 related suites, 66 pass. Three fail (`budget-live-percent-label`, `live-budget-admission`, `token-cost-ledger`), and they fail the same way on unmodified `origin/main2`, so my changes didn't cause them.
- `scripts/checks/run-all.sh` is clean.

### `set-road.sh init --from-slate --dry-run`, run against the live slate
- **`road.json`:** lanes 0.6/0.4; pinned, in order: `minion-town-claude-api`, `minion-town-mcp-ocapn`, `minion-town-git-remote`, `minion-town-ui`. The other arcs follow in slate order: `endo-ocapn-background`, `moonshots`, `garden-upkeep`, `garden-book`, `endo-backlog`. `unallocated` becomes an alias for unarced work.
- **Removed in the same commit:** `config/apportionment`, `config/foreman-mandate`, and all ten schema-2 `config/arc-budgets/*` files (including `unallocated`).
- **The road after init:**
  - Pool `claude-endolin1`: 22% used, maintainer reserve 0.064, lanes 0.135, discretion 0.485 (0.684 at the reset), verdict `ok`.
  - Pool `claude-oros`: 50% used, maintainer reserve 0.016, discretion 0.379, verdict `ok`.
  - Lanes: `minion-town-claude-api` holds primary (reserved). The other three pinned minion.town arcs show "(no planned work)", so **the secondary lane would be empty** right after cutover. The maintainer should know this before going ahead.

**Rollback:** `git revert` the `init` commit on `journal2` and remove `config/maintainer-reserve`. With no `road.json`, the code falls back to the ramp and the restored slate.

### Follow-ups
- I parked **`cutover-budget-road`** in `plan/` behind a go-ahead gate. It holds the full cutover procedure: preview, `set-maintainer-reserve.sh 0.50`, `init`, then rewriting the `accountant-weekly` schedule body.
- After cutover: delete the old slate code paths and turn `set-apportionment.sh` and `accountant-reslice-nudge.sh` into redirect stubs. `accountant-arc-apportionment-test.sh` was kept for now because the slate is still live.
- `budget-level.sh` should read `0.90 − R_k` as its ceiling (the design's own follow-up, not done here).
- The maintainer's own token count leaves out every `claude -p` session and every job worktree under scratch. That is how the foreman's sessions stay off the maintainer's share, but any non-interactive session the maintainer runs themselves will be counted as fleet spend.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-budget-road.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 234 tokens (23396066 cached reads)
- Output: 105807 tokens
- Cost: $9.006505200000003
- Wall-clock: 2738s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
