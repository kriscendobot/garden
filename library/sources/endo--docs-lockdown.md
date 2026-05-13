---
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
section_count: 15
status: current
notes: Single commit in git log; content reads as having older origins. The original document has two H1 headings ("Lockdown" and "lockdown Options"); both were folded into the overview section since the first is a thin frame and the second is the options-table introduction.
---

> Abstract: The canonical reference for the `lockdown()` function's option taxonomy. Covers 14 safety-vs-compatibility options whose defaults are `'safe'`, plus an environment-variable fallthrough convention (`LOCKDOWN_*`). The largest single document in endo's `docs/` tree and the primary entry point for anyone configuring SES. Each option section follows the same shape: background (the JavaScript surface the option tames), example code with both the safe default and the unsafe alternative, env-var equivalent, and discussion of the trade-off.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--docs-lockdown--overview.md) | hardened-javascript | current |
| [regexp-taming](../sections/endo--docs-lockdown--regexp-taming.md) | hardened-javascript | current |
| [locale-taming](../sections/endo--docs-lockdown--locale-taming.md) | hardened-javascript | current |
| [console-taming](../sections/endo--docs-lockdown--console-taming.md) | hardened-javascript, errors | current |
| [error-taming](../sections/endo--docs-lockdown--error-taming.md) | hardened-javascript, errors | current |
| [error-trapping](../sections/endo--docs-lockdown--error-trapping.md) | hardened-javascript, errors | current |
| [reporting](../sections/endo--docs-lockdown--reporting.md) | hardened-javascript, errors | current |
| [unhandled-rejection-trapping](../sections/endo--docs-lockdown--unhandled-rejection-trapping.md) | hardened-javascript, errors, eventual-send | current |
| [eval-taming](../sections/endo--docs-lockdown--eval-taming.md) | hardened-javascript, compartments | current |
| [stack-filtering](../sections/endo--docs-lockdown--stack-filtering.md) | hardened-javascript, errors | current |
| [override-taming](../sections/endo--docs-lockdown--override-taming.md) | hardened-javascript | current |
| [override-debug](../sections/endo--docs-lockdown--override-debug.md) | hardened-javascript | current |
| [domain-taming](../sections/endo--docs-lockdown--domain-taming.md) | hardened-javascript | current |
| [legacy-regenerator-runtime-taming](../sections/endo--docs-lockdown--legacy-regenerator-runtime-taming.md) | hardened-javascript | current |
| [harden-taming](../sections/endo--docs-lockdown--harden-taming.md) | hardened-javascript | current |

## Provenance

- File last modified 2025-09-25 by Kris Kowal. Single commit in `git log`; pre-rename history not visible.
- Captured at endo file-specific commit `fe81477b`.
- Two H1 headings in the source ("Lockdown" and "lockdown Options") were folded into a single overview section; the rest are H2 per the conventions default.

Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md).
