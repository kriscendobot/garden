---
ts: 2026-05-15T04:00:45Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/034647Z-result-judge-69e97d.md
  - entries/2026/05/15/035537Z-message-fixer-f1bfe3.md
---

PR #248 (`design(ses,module-source): import-attributes proposal`),
fixer round 1 against the judge's panel-and-maintainer-inline must-fix
list.

Pushed seven commits on `design/ses-import-attributes`
(`bc3720dbb..375a3af65`):

- `72ef40466` — canonical front matter table (M1).
- `5e2cea8fe` — drop JSON modules; defer typed source variants (M5).
- `c1461821d` — JSON-tuple memo key; clone-then-freeze normalize (M3, M6, S3).
- `ec63e769f` — arity dispatch tightens; shim-side; exact TypeError text (M4, M7, S2, S4).
- `8685bf4cf` — resolve open questions; modulesWithAttributes; compartment-mapper impl (M8, M9, M10, M11, S1, S5).
- `3a52f698b` — align References citation form; add Prompt heading (S6).
- `375a3af65` — bump `designs/README.md` row Updated to 2026-05-15 (S7).

### Must-fix coverage

| # | Item | Addressing SHA |
|---|------|----------------|
| M1 | Canonical front matter table | `72ef40466` |
| M2 | Designer-dispatch directive for compartment-mapper-attributes follow-up | journal `message` `035537Z-message-fixer-f1bfe3` to liaison |
| M3 | Memo key: JSON-stringify `[specifier, attributes]` tuple | `c1461821d` |
| M4 | Arity-based backward-compat is shim-side only | `ec63e769f` |
| M5 | Drop JSON modules; virtual sources cover content-typed loads | `5e2cea8fe` |
| M6 | Clone-then-freeze normalize | `c1461821d` |
| M7 | Throw on arity-1 only when `type` is non-`js` | `ec63e769f` |
| M8 | Drop parse-in-hook-vs-linker open question | `8685bf4cf` |
| M9 | Attributes do not pass through `resolveHook`; carry watch-point caveat | `8685bf4cf` |
| M10 | Preserve existing shapes; add `modulesWithAttributes` priming path | `8685bf4cf` |
| M11 | Expand compartment-mapper implications | `8685bf4cf` |

### Should-fix coverage (panel)

| # | Item | Addressing SHA |
|---|------|----------------|
| S1 | Test plan catalogue | `8685bf4cf` |
| S2 | Exact TypeError text for arity throw cases | `ec63e769f` |
| S3 | Worked "before" memo key in bytes-level example | `c1461821d` |
| S4 | One-sentence `hook.length` intro | `ec63e769f` |
| S5 | One-sentence `@endo/compartment-mapper` archive concept intro | `8685bf4cf` |
| S6 | References citation form split; `## Prompt` heading; serial-comma fixes | `5e2cea8fe`, `3a52f698b` |
| S7 | `designs/README.md` row Updated bumped to 2026-05-15 | `375a3af65` |

### CI

All four design-only checks green on `375a3af65`:

- `build` pass (24s)
- `lint` pass (1m6s)
- `browser-tests` pass (2m46s)
- `test` pass (3m30s)

### Replies posted

Eleven inline thread replies posted against the maintainer's
`CHANGES_REQUESTED` review (per-action authorization forwarded by the
liaison). One top-level summary comment posted with the full SHA mapping
(per-action authorization forwarded by the liaison).

### Next stage owed

`judge` re-dispatch for verification. The PR remains in DRAFT; if the
judge re-runs the panel against `375a3af65` and surfaces no further
in-scope must-fix items, the judge un-drafts the PR per the jury-fixer
loop termination in `garden/skills/pr-creation-flow/SKILL.md`.

Self-improvement: nothing this time. The judge's dispatch prompt
carried the full eleven-item must-fix list with line numbers and item
summaries, which let me proceed straight to the document substance
without rebuilding the list from `gh api`. The `review-feedback-followup-commits`
discipline of one-concern-per-commit was a clean fit for a multi-item
design revision (each commit is independently revertable). The
`pr-review-thread-replies` skill's `/replies` endpoint and SHA-citation
form both worked as written; no field updates.
