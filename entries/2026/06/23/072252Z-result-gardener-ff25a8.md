---
ts: 2026-06-23T07:22:52Z
kind: result
role: gardener
project: garden
---

Encoded the no-`function`-keyword house style across the garden's role and juror context, per kriskowal's directive on `endojs/endo-but-for-bots#474` (2026-06-23T06:25:14Z): *"Dispatch a gardener to reinforce this house style going forward."*

The upstream house-style document (`docs/house-style/function-keyword.md` on the bot fork, linked from AGENTS.md) is the canonical source of truth and exception catalogue. The garden's job is to make future builder, fixer, and cleaner dispatches honor the rule without explicit instruction, and to give the panel a citation surface for findings.

## Files changed

- **`skills/no-function-keyword/SKILL.md`** (new). Canonical skill. Names the rule, the four hardened-JavaScript hazards (`[[Construct]]` and `[[Call]]` both present, `prototype` property, `freeze`-vs-`harden` non-equivalence, declaration hoisting), the scope (endo-family package sources), and the per-role application discipline. The exception catalogue is delegated to the upstream doc rather than duplicated; the seven categories are summarized in passing only.
- **`roles/builder/AGENT.md`**. Skill listed under Skills; one-line operating norm in the skill citation. Default to arrow / concise-method syntax; reach for `function` only inside the seven legitimate-exception categories with an inline reason comment.
- **`roles/fixer/AGENT.md`**. Skill listed under Skills with the directive framing for retire-function-keyword review asks ("a review comment asking to retire `function` from the touched file is a directive, not a discussion").
- **`roles/cleaner/AGENT.md`**. Skill listed under Skills; new test code follows the same rule with an inline-reason exception for fixtures that specifically exercise `function`-keyword behavior.
- **`roles/jurors/purist/AGENT.md`**. Skill listed under Skills; inquiry axis added to the primary surface. The four hazards align directly with the purist's lens (the seat's existing inquiry axes already cover `[[Construct]]`, frozen-prototype property hygiene, side-channel closure, and family-consistency). Provenance line cites PR #474 and #468.
- **`roles/jurors/warden/AGENT.md`**. Skill listed under Skills as a secondary overlap with the purist. The warden's slice is the `freeze`-vs-`harden` boundary consequence specifically; the purist owns the introduction itself. The seat already reads for harden discipline at the SES boundary, so the overlap is one short sentence in operating norms.
- **`CLAUDE.md`** Current inventory. New skill listed.

## Landing-site rationale

The directive's candidate sites were `roles/COMMON.md`, builder, fixer, cleaner, stylist, purist, and a dedicated skill.

- **`roles/COMMON.md`** was rejected as a landing site. COMMON's Style section is scoped to prose-style rules (em-dash, relative-paths, no-latin-shorthand). The function-keyword rule applies to code authoring, not prose. Landing it in COMMON would either dilute the prose-only framing or force a structural reshape of the section that the maintainer did not ask for.
- **`roles/jurors/stylist/AGENT.md`** was rejected. The stylist's remit was deliberately narrowed in the 2026-05-14 twelve-seat redesign to *naming only* ("Diff hygiene, commit splitting, and changeset content moved to the packager... The stylist's narrower remit is naming only."). The function-keyword rule is syntax shape, not naming. Adding it would re-expand the seat's remit against the maintainer's prior framing.
- **A new dedicated skill** was the right primitive. The maintainer's framing ("reinforce this house style going forward") asks for the rule to be enduring and citable. A standalone skill gives jurors a `[rule: skills/no-function-keyword/SKILL.md]` citation per the cite-or-propose discipline in `skills/panel-review/SKILL.md`, gives builders / fixers / cleaners a one-link reference, and gives future role authors a hook to extend. The skill delegates the exception catalogue to the upstream doc so the catalogue evolves in one place.
- **Builder, fixer, cleaner, purist, warden** were all natural landing sites for their respective roles. Purist as primary panel seat (its four-axis lens IS the four hazards' frame); warden as secondary overlap (the SES-boundary consequence of the `prototype`-property-and-`freeze` interaction). The other source-author roles (weaver, shepherd, conductor) do not author new functions and were intentionally left untouched.

## Considered and deferred

- **A deterministic probe under `skills/pre-push-gates/probes/`** would be a natural next step (the same way `no-non-ascii-in-source.sh` works). A regex-level probe could catch `^export function `, `^function `, and `^const foo = function (` introductions in `packages/<pkg>/src/` and `lib/` paths. The seven exception categories make a fully deterministic probe nontrivial (constructor emulation, sloppy-mode `this`, TypeScript assertion functions, module-init forward references each look indistinguishable from a default `function` declaration at the regex layer); the probe would need either a per-file opt-out marker comment or a permissive default that under-catches. I left this for a future gardener dispatch with explicit maintainer guidance on the false-positive tolerance; the role and juror landing is the right starting point.
- **A separate sweep against the bot fork's existing code** (the ~45 SES `tame*` / `enable*` / permits-intrinsics sites, the captp / ocapn module-init forward references, and the `cjs-module-analyzer` port) was outside the dispatch's scope. PR #474's body already enumerates these three categories as deferred follow-ups for erights's guidance.

## Sweep findings

- The five files I touched all already use arrow / method syntax in their own internal examples. No internal drift to correct.
- The garden's CLAUDE.md inventory line was the only structural drift point; updated.
- Author frontmatter on each touched file updated.

## Commit and push

Commit: `cf8dba5b gardener: encode no-function-keyword house style across roles and jurors`. Pushed to `kriskowal/garden:main` (was at `bb30ef6f`, now at `cf8dba5b`). Per `CLAUDE.md` § Conventions, no PR opened against the garden's own repo.

Self-improvement: skills/no-function-keyword/SKILL.md, roles/builder/AGENT.md, roles/fixer/AGENT.md, roles/cleaner/AGENT.md, roles/jurors/purist/AGENT.md, roles/jurors/warden/AGENT.md, CLAUDE.md; codified the upstream house style as a new skill plus role / juror landings so future dispatches honor the rule without explicit instruction.
