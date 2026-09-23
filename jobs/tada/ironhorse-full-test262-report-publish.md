All done. Existing `docs/bulletin`, `docs/index.html`, `docs/.nojekyll` preserved; report added alongside.

## Completion report

**Job:** Run and publish the authoritative Ironhorse full-test262 report (kriscendobot/garden#51), using the automation delivered by `ironhorse-full-test262-automation`.

### What I did
- Created the isolated project checkout of **endojs/endo-but-for-bots** at the automation's delivered head — PR **#969**, branch `feat/ironhorse-full-test262-report`, exact SHA **`14f26d0a6`** — initialized the `c/moddable` XS-oracle submodule (`23b4d6b0`, moddable 8.3.1), and built the runner + report binaries (release).
- Validated end-to-end on two subtrees (Proxy → 0 covered; `language/types/boolean` → 3 covered, proving the oracle differential really engages).
- Ran the **complete** `test/**` tree (no curated sample; `staging/` excluded as the runner does) via the automation's bounded, resumable `scripts/full-run.sh --jobs 16`. **1727 of 1730 per-directory batches auto-completed in ~90 s** (16 parallel oracle processes).

### Infrastructure failure handled honestly
- **3 batches hung >11 min** with no verdict: `language/statements/{await-using,const,using}/syntax`, each on its `*-invalid-assignment-next-expression-for.js` case — the Ironhorse engine **infinite-loops** on `for (await using|using|const i = null; …; i = …)`. **The hang reproduces with `--no-oracle`**, so it is a genuine engine defect, not an oracle problem (the runner has no per-case timeout). I killed the hung processes, re-ran each directory with the offending file held aside (getting clean verdicts for the other 35/24/36 cases), and recorded each hanging case as an **`outcome=fail` → ironhorse-failure** (a bar-forbidden non-termination-vs-oracle divergence) — not collapsed into a pass, not mislabeled as a language gap or oracle failure. Documented in the run provenance.

### Results (52,092 cases, tc39/test262@`be13516f`, 2026-08-07)
- **Covered 4,740 (9.10%)** · Unsupported 38,400 (73.72%) · Skipped 8,932 (17.15%) · **Ironhorse-failure 19** · Infrastructure 1.
- **Proxy result (explicit): entirely unimplemented — 0 of 311 `built-ins/Proxy` cases covered** (307 unsupported, 4 skipped).
- The 19 failures: 16 Unicode identifier-start over-acceptances (`language/identifiers/start-unicode-*`) + the 3 hangs above.

### Published (garden Pages, kriscendobot/garden `main2` `/docs`)
- `docs/reports/ironhorse-test262/20260808-14f26d0a6/{report.html,report.json,provenance.json}` (self-contained HTML — no external assets — + machine-readable JSON + provenance) and a stable `docs/reports/ironhorse-test262/index.html` landing/index. Committed with explicit pathspecs, pushed via rebase/CAS to `origin/main2` (`b771c6ff84`). Existing bulletin/Pages content preserved.
- Waited for the Pages build (`built` @ `b771c6ff84`) and **verified all public URLs with real HTTP 200 fetches**:
  - https://kriscendobot.github.io/garden/reports/ironhorse-test262/
  - https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260808-14f26d0a6/report.html
  - …/report.json (52,092 cases, covered=4740) and …/provenance.json

### Not done (by design / follow-ups)
- **Issue #51 left open** — the next orchestration child analyzes the published data and posts the substantive reply.
- **Runner gap surfaced for that child:** `ironhorse-xst` has no per-case wall-clock timeout, so a non-terminating case hangs a whole batch; worth adding a bounded per-case timeout classified as infrastructure. The 3 hangs and the 16 Unicode over-acceptances are concrete engine defects for the implementation backlog.
- No scripted panel was run on PR #969 (available on demand via "run the gauntlet #969"); the report job did not modify any engine/runner source, so the published report's provenance matches the unmodified #969 head.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-full-test262-report-publish.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (4787604 cached reads)
- Output: 46404 tokens
- Cost: $4.592257
- Wall-clock: 1685s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
