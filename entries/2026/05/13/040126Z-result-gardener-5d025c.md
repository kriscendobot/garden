---
ts: 2026-05-13T04:01:26Z
kind: result
role: gardener
project: garden
subject_matter:
  - pr-formation
  - dependency-tracking
  - topological-sort
to: liaison
refs:
  - entries/2026/05/13/035459Z-dispatch-liaison-6f1a2e.md
  - entries/2026/05/13/035237Z-message-steward-dc1809.md
  - entries/2026/05/13/034937Z-result-steward-b9d3d5.md
---

# Gardener engagement: three #128-derived asks landed in one design pass

Dispatched by liaison to land kriskowal's #128 directive ("capture in skills of relevant roles") plus the steward's two follow-on asks (topological sort, journal-side dependency tracking) as one coherent design.

## Files written

Garden (`main`):

- `garden/skills/pr-formation/SKILL.md`: new. Template-section structure, no checklists, no file callouts, behavior over diff. Title carries the same discipline.
- `garden/skills/pr-dependency-graph/SKILL.md`: new. Parse `journal/pr-deps/*.md` into an adjacency list with `blockers_of`, `blockees_of`, `walk_blockers`, `detect_cycles` helpers.
- `garden/skills/pr-dependency-topo-sort/SKILL.md`: new. Stable Kahn topo sort over a bin against the graph, `(repo, number)` tie-break, explicit cycle handling.
- `garden/roles/journalist/AGENT.md`: within-bin ordering rule rewritten to use the topo sort; cycle handling rule added; dep-file-for-absent-PR rule added; cites both new skills in the Skills list.
- `garden/roles/fixer/AGENT.md`: cite `pr-formation` in Skills.
- `garden/roles/boatman/AGENT.md`: cite `pr-formation` in Skills.
- `garden/CLAUDE.md`: inventory updated with all three new skills.

Journal:

- `journal/pr-deps/README.md`: new. Schema, lifecycle, who-writes-vs-who-reads, hand-maintained index.
- `journal/pr-deps/endojs--endo-but-for-bots--128.md`: seed entry declaring `blocked_by: #160 (exo-zip/exo-unzip name pick)`, matching the steward's inline annotation in `journal/README.md`.

## Commits

`main` (pushed `1160a24..01e19b7`):

- `822cd73` pr-formation skill.
- `5c482a6` pr-dependency-graph + pr-dependency-topo-sort skills.
- `3e8e325` journalist topo-sort rule + skill cites.
- `01e19b7` inventory + fixer/boatman cites.

`journal` (`034b946`, push pending at the moment this entry is being written):

- `034b946` pr-deps registry README + seed.
- `<this entry>` result-gardener.

## Design choices

### pr-formation as a standalone skill, not additions to existing skills

The PR-formation discipline applies to fixer, boatman, and (when adopted) builder + weaver. Inlining into `pre-pr-checklist` was tempting since that skill already covers the template fetch, but the *content of the sections* is a different concern than *how to fetch the template*. Keeping them separate makes each skill smaller and gives the cite a precise target. The skills cross-reference each other.

### Dep-file lifecycle: survive past merge, retire only when context is no longer instructive

The maintainer's directive is about the *journalist* needing to know dependencies, but dependencies are durable facts about the project's history. A dep file for a merged PR documents historical context cheaply; deleting it loses information for "did A ever depend on B?" forensics. The README's lifecycle rules favor keeping files: PR merged keeps the file, PR closed-without-merge keeps the file by default, deletion is the unusual case (close was a misclick + dependency was speculative).

The journalist's read side handles the merged-PR case by skipping rows whose PR is not in the canonical set; the file itself stays.

### Cycle handling: surface, never silently render

A cycle in the declared dependency graph is a registry contradiction, not a sort bug. The topo-sort skill returns a structured failure (`{ordered: <prefix>, cycle_members: [...]}`); the journalist renders the affected bin as a literal placeholder line (`(none rendered: PR dependency cycle on <ids>; see message)`) and writes a `message` journal entry to `liaison` naming the cycle members. The maintainer (or an authorized role) resolves by editing one of the contradicting entries.

Rendering in either direction silently would hide the contradiction and produce a misleading bulletin. The chosen behavior is loud-and-broken over silent-and-wrong.

### Reciprocity is encouraged but not enforced

The canonical edge in the registry is the `blocked_by` side; `blocks` is a searchability convenience. This lets the maintainer or a writing role declare a one-sided edge without ceremony, while still letting a future reader of `B` find "what does B block?" by reading `B`'s own file when the convenience was filled in.

The parser de-duplicates edges from both sides and prefers the `blocked_by` side's `reason` on conflict.

### `(repo, number)` tie-break, not first-come

The pre-existing within-bin order rules (review-queue's three-tier, *PR backlog*'s first-come) explicitly do *not* survive the new topo-sort rule. The `(repo, number)` tie-break is deterministic, decoupled from input order, and easy to reason about. Two journalist runs with identical inputs produce byte-identical orderings, which preserves the idempotent-rewrites rule.

## Messages routed to liaison

None routed as separate `message` entries. This `result` entry is `to: liaison` and the design choices above are inline rather than fragmented.

## Self-improvement

One observation worth flagging: writing three interlocking skills + a registry README + role updates as one dispatch worked, but it produced a longer-than-usual gardener engagement. If the asks were truly independent, separate dispatches would have been cheaper to think about. The asks here genuinely interlock (the journalist rule cites both skills; the topo-sort skill names the registry; the registry README names the skills), so one engagement was the right call. Threshold of evidence for a rule: one instance is not yet load-bearing. Will note if a second multi-ask gardener dispatch encounters the same interlock pattern.

Self-improvement: nothing for the gardener role file directly.
