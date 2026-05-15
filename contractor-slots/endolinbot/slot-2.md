---
slot: 2
status: in-flight
design_path: designs/ses-import-attributes.md
pr_number: 248
current_stage: fixer
in_flight_dispatch: 50b5ec
last_update: 2026-05-15T03:47:00Z
started_at: 2026-05-15T03:57:00Z
host: endolinbot
---

Judge `96490a` returned at 03:46Z. Panel verdict: 11 must-fix (all
kriskowal inline comments — empty-body review carried substantive
inline feedback as expected; the dispatch's `gh api comments` fetch
caught them all) + 7 should-fix + 3 out-of-scope.

Heaviest must-fix: item 5 (line 252) — "drop JSON modules". Significant
design reshape: source-type table loses 3 of 4 rows; `### JSON modules
in detail` section deletes; Mermaid diagram deletes; rejected
"Separate jsonImportHook" alternative rewrites or drops.

Other notable must-fix:
- M1: canonical front-matter table per `designs/CLAUDE.md`.
- M2: designer dispatch directive logged as steward journal message.
- M3: revise byte-identity legacy-collapse claim (null byte not
  forbidden in specifiers; JSON-stringify both halves).
- M4: arity-based backcompat shim-side only.
- M6: clone+freeze options bag, don't mutate.
- M7: throw if type != 'js' and arity is 1.
- M11: expand compartment-mapper implications.

Dispatch root: `dispatches/fixer--50b5ec`.
