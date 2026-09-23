---
orchestration-failed: true
---
Everything is committed and pushed; the interim refresh is live and verified. Here is my completion report.

---

## Completion report — Ironhorse full-suite report refresh (js-27)

**Repository:** `endojs/endo-but-for-bots` (measured) · **PR:** https://github.com/endojs/endo-but-for-bots/pull/970 (OPEN, draft, **not merged**) · **Published to:** `kriscendobot/garden` `main2` `/docs` (Pages) at `40ddf6543d`.

### What I did
- Took an isolated project checkout of PR #970 at head **`b3c3ae93b8`**, initialized the `c/moddable` XS-oracle submodule at the pin **`23b4d6b0`**, and built `ironhorse-xst` + `ironhorse-262-report` release (XS oracle compiled clean).
- Ran the bounded/resumable oracle-backed automation end to end against the **pinned 52k corpus** (`tc39/test262@be13516f`): `full-run.sh --jobs 12 --oracle on`. 1,930 batches, **completion=complete**, no quarantine.
- Published the refreshed self-contained **HTML + JSON + provenance** to `docs/reports/ironhorse-test262/20260814-b3c3ae93b8/`, updated the stable index with an exact before/after and an in-flight disclosure, committed with explicit pathspecs, and CAS-pushed to `main2`.
- **Verified all four public URLs by HTTP 200 and parsed the public JSON** (pins match: endo `b3c3ae93b8`, test262 `be13516f`, oracle `23b4d6b0`; `completion: complete`): https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260814-b3c3ae93b8/report.html
- Ran the regression gates at this head: **exact-metering corpus passes 1,711/1,711 (0 failed under `--gate-meter-exact`)**, dual-run regressions pass — computron expectations unchanged.

### Before → after (same pinned corpus)
| Outcome | 2026-08-08 (`14f26d0a6`) | 2026-08-14 (`b3c3ae93b8`) |
|---|---|---|
| Covered | 4,740 (9.10%) | **23,496 (45.21%)** |
| Unsupported | 38,400 | 23,233 |
| Skipped | 8,932 | 4,406 |
| Ironhorse-failure | 19 | **194** |
| Infrastructure | 1 | **647** |
| Total | 52,092 | 51,976 |

Covered grew **×5**; Proxy went 0 → 188/311. Total differs because this head's discovery excludes harness support files and reclassifies module cases. Runtime: whole-tree sweep completed in a few minutes at `--jobs 12`.

### Why this is signalled orchestration-failed (gate not met at a mid-flight head)
The job's gate ("zero failures, zero unsupported, zero infrastructure; final authoritative state") is **not achievable at this head** — it is a live, actively-converging branch:
- **Two sibling children are running right now** on the same branch: `js-26-ca-regexp-u-core` and `js-26-cb-with-statement`. They own the two largest residual buckets — RegExp `u`/`v` (2,870 unsupported **+ 185 of the 194 failures**, all `built-ins/RegExp`) and `with` (943 unsupported). The truly-final refresh must run **after** the js-26 closure lands.
- **6 previously-covered cases regress to `unsupported`** at this head (`Set.prototype.keys`, the `trimLeft`/`trimRight` Annex-B refs, 3 strict-mode cases). Reproduced in isolation → a genuine branch defect from an earlier child, **not my work**; needs a fixer.
- Infrastructure (647) is dominated by structural module gaps (443 `module:evaluation`, 99 `module:compiler-rejected`), not contention.

### Not done / follow-ups (owned by the post-closure final refresh)
- **Second sweep against the current `tc39/test262` tip** — deliberately deferred: running it against a mid-flight branch produces a soon-superseded artifact; it belongs to the post-js-26-closure final refresh.
- **Final zero-everything refresh** after js-26 closure completes.
- **Fixer** for the 6 covered→unsupported regressions.
- No engine source changed (this is a report-refresh job); no Rust tests added because I converted nothing.

Maintainer notified via the liaison with the interim publish, the regressions, and the recommendation to re-run post-closure.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-27-full-suite-report-refresh.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (5787247 cached reads)
- Output: 51016 tokens
- Cost: $5.457526499999999
- Wall-clock: 817s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
