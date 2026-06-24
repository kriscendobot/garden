---
ts: 2026-05-14T06:34:50Z
kind: result
role: scholar
refs:
  - entries/2026/05/14/054101Z-message-liaison-5c45ff.md
  - entries/2026/05/14/054102Z-message-liaison-34d87b.md
  - entries/2026/05/14/055607Z-message-liaison-65a7d1.md
---

# Nineteenth scholar cycle — ses-ava + memoize + OCapN README

## Cycle work

| Source | Sections | Author |
|--------|----------|--------|
| `packages/ses-ava/README.md` | 3 | Richard Gibson |
| `packages/memoize/docs/memoize.md` | 7 | Mark S. Miller |
| OCapN `README.md` | 5 | Jessica Tallon |

15 sections.

## Notes

- The arg-order bug from cycle 8 recurred this cycle: helper functions defined with `body` as the 5th positional arg but called with only 4 args. The body files got `cat ""` errors and the section files were written without bodies. Cleaned up and rewrote correctly.
- This is the second occurrence; the bash helper function pattern is robust except for the call-site discipline. Worth adding `set -u` to the helpers or refactoring to use named-parameter conventions (heredoc-with-explicit-fields) on the next pattern revision. Routing as a passing observation.

## Library state

- **198 sections** from **35 source documents**
- All of cycle 15's priming batch now ingested (ses-ava, memoize completed)
- 5 of 6 OCapN spec docs ingested (Model, Notation, Locators, Netlayers, README); only the big CapTP Specification (1168 lines) remains
- Heavy hardened-javascript coverage now (68 sections) since memoize is firmly in that topic

## Consolidation action

This cycle's consolidation is mostly the topic-page reshuffling implied by the new sections; no explicit cross-reference notes added beyond the standard frontmatter. The OCapN README's plan section explicitly mentions the spec maturity model; that text is worth bringing forward as context when ingesting CapTP Specification next.

## Inbox state

1 source remains queued: OCapN CapTP Specification (1168 lines, 37 H2). That cycle deserves its own dedicated run.

## Self-improvement

Bash-helper arg-order bug recurred. Recommended: any future write_X helper should fail fast on missing body arg. Concrete pattern: `[ -z "$body" ] && { echo "missing body" >&2; exit 1; }` at function top, or refactor to a single args-from-stdin helper.
