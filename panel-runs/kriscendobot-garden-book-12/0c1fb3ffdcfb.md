---
kind: panel-run
repo: kriscendobot/garden-book
pr: 12
panel_kind: code
base_ref: main-6e0ad97
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 634e04b9fc9f250826e82c2073340c35ba50d183
must_fix_total: 13
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 0c1fb3ffdcfb
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/garden-book #12 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `634e04b9`

seat verdicts (33): archivist=must-fix assessor=comment benchmarker=pass breaker=comment changeset-auditor=comment corner-prober=must-fix coverage-auditor=pass curator=comment duality-auditor=pass engine-realist=comment fast-checker=comment gateway=pass integrator=comment locksmith=comment migrator=pass orthographer=pass packager=comment procurer=comment prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=must-fix scribe=must-fix spec-keeper=comment stylist=comment surfacer=pass thesaurus=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (13):
- archivist: `tools/equilibrium/rules.mjs`: `// ---- statistics`, `// ---- regime rules`, `// ---- reviewers`, `// ---- prices` (a...
- archivist: `tools/equilibrium/analyze.mjs`: `// ---- snapshot`, `// ---- completion reports`, ..., `// ---- output` (approx. 16)
- archivist: `art/generate-equilibrium-charts.mjs`: `// ---- E1` through `// ---- E9` (9)
- corner-prober: **`scenario.mjs` anchor-sanity guard has a blind spot for a partial-null anchor.** `anchors.c = panel.allocatedDollar...
- corner-prober: **`isoWeek` throws on a parseable-JSON-but-malformed `ts`; `month` silently returns garbage on the same input — unt...
- corner-prober: **`linearScale(min, max, start, end)` divides by `max - min` with no degenerate-domain guard** (art/generate-equilibr...
- pruner: **PR body: Verification paragraph reciting test results without links** (`PR body, "Checks" section`)
- pruner: **`art/equilibrium-charts-evidence.md`: Measurements table with repetitive metadata** (`lines 24–50`)
- saboteur: **Must-fix** — `tools/equilibrium/scenario.mjs:45` (`c = panel.allocatedDollarsPerBase.median + fix.allocatedDollar...
- saboteur: **Should-fix** — `tools/equilibrium/analyze.mjs:453` (`readJson`) and `tools/equilibrium/scenario.mjs:35` (top-leve...
- saboteur: **Mitigated** — `reconciliation.windowOverstatement` (`analyze.mjs` reconciliation block) divides `windowNotional /...
- scribe: Root cause looks structural, not a one-off oversight: the live gauntlet fix-loop job driving this response (`journal/...
- scribe: No maintainer "note this" / "add to CLAUDE.md" / "for future reference" asks appear anywhere in this PR's history (re...
