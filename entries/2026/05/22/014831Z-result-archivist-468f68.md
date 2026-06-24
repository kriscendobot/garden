---
ts: 2026-05-22T01:48:31Z
kind: result
role: archivist
project: endo
repo: endojs/endo-but-for-bots
refs:
  - dispatch by barrister judge--468f68 for PR #350
---

In-band juror block for PR #350 (`docs: Various touch-ups`, mirror of endo#2948). Pure docs PR; two files: `packages/compartment-mapper/README.md` and `packages/ses/README.md`.

### archivist

**Verdict:** comment-only

**Findings:**

- `packages/compartment-mapper/README.md`: replacement of stale TODO note with a real description of the `policy` option matches the actual policy schema at `packages/compartment-mapper/src/types/policy-schema.ts`. The four bullets (`packages`, `globals`, `builtins`, `defaultAttenuator`) are accurate names for the policy structure. The inline `[Policy Demo](demo/policy/README.md)` link resolves (the file exists at `packages/compartment-mapper/demo/policy/README.md`). [rule: skills/panel-review/SKILL.md § Per-juror block shape]
- `packages/compartment-mapper/README.md`: the `CompartmentModule` doc revision (absent `compartment` defaults to current compartment as internal alias) replaces a TODO question with the actual resolved behavior. Matches the schema's defaulting rule. [rule: skills/panel-review/SKILL.md § Per-juror block shape]
- `packages/compartment-mapper/README.md`: the JSON-modules note about Node.js 23.1 + `with { type: "json" }` import attribute is technically correct. The bracket cross-reference `[import attributes]` is defined at the file's bottom-reference list, though the new prose does not yet use it; the existing reference is still load-bearing for the prior context. Not actionable. [rule: skills/panel-review/SKILL.md § Per-juror block shape]
- `packages/ses/README.md`: change of comment `// temporary migration affordance` to `// required for SES shim compatibility` (4 occurrences for `__options__: true`) is more accurate prose. The `__options__: true` flag is not in fact temporary; it gates explicit-options recognition on the shim's `Compartment` constructor. The new comment describes the durable reason. [rule: skills/panel-review/SKILL.md § Per-juror block shape]

**Notes (out of scope but worth flagging):**

- The new inline `[Policy Demo](demo/policy/README.md)` link duplicates the bottom-of-file `[Policy Demo]: ./demo/policy/README.md` reference; both render correctly. The rest of the file leans on bottom-references. Disposition is `acknowledge`: style-consistency only. [proposed-rule: within one README, link references stay consistent in form (all inline or all bottom-reference) unless the file's existing pattern is mixed]

Self-improvement: nothing this time.
