---
ts: 2026-06-03T23:31:28Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/researcher--91bd98
short_id: 91bd98
refs:
  - entries/2026/06/03/232716Z-dispatch-researcher-91bd98.md
---

# result: researcher — refinement for builder prompt on zizmor pinned-action mismatch

The proposed prompt asks a builder to address the recurring zizmor pedantic finding "action's hash pin has mismatched or missing version comment" by auditing every `uses:` site across `.github/workflows/*.yml`. The library and project carry one canonical material on action pinning (CONTRIBUTING.md § Action pinning, ingested at `journal/library/sections/endo--contributing--initial-setup.md`) and a fresh same-day pattern entry on upstream floating-tag drift that is highly relevant to the builder's diagnostic and fix strategy. The refinement below cites both, names the `endo-but-for-bots` project's standing authorization for posting on its PRs, points the builder at the frozen-base + draft + gauntlet discipline, and surfaces the missing maintained-upstream procedural document (`update-action-pins.mjs`) as an open question for the librarian. The most important addition is the field-note pattern: the same prompt that motivates this builder dispatch (a master-side pin-mismatch on `release.yml`) was just resolved by a separate fixer dispatch (#421) on 2026-06-03, so the broad-audit builder ought to consult that fix to avoid stomping it.

```markdown
## Library and project references

### Library concepts and sections

- [`journal/library/sections/endo--contributing--initial-setup.md`](../../library/sections/endo--contributing--initial-setup.md) § *Action pinning* — the canonical source for the project's pin-discipline: `scripts/update-action-pins.mjs` refreshes patch/minor pins; `--major` upgrades; `--min-age-days 0` bypasses the 5-day age gate; the updater reads the `# vX` comment on each `uses:` line and infers the latest tag when missing. CI enforces with `--check-pins`. **This is the single load-bearing reference** for the builder: the convention names both the format (`<sha> # vX`) and the mechanism (`update-action-pins.mjs`) the builder's audit must respect.
- [`journal/library/sections/endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint.md`](../../library/sections/endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint.md) § *Two-layer enforcement* — notes that `check-action-pins` runs as a parallel CI job alongside the proposed `check-no-ci-lifecycle.mjs` lint, with workflow-changes-only gating. Useful context for understanding why the builder's diff trips `zizmor` but does not need to add new lint infrastructure (the audit already exists).

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Standing authorizations* — comments, reviews, reactjis, and cross-references on this repo are pre-authorized without per-action prompts. The builder may post a top-level summary on the resulting PR explaining what changed and why, without needing the liaison to forward an authorization.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Rules of engagement* — implementation work lands on `master`, not `llm`. A "chore(ci): align workflow action hash pins" change is an implementation, not a design, so the builder branches off `master` per the dispatch brief.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Authority structure* — every commenter on `endojs/endo-but-for-bots` is maintainer-equivalent. A `CHANGES_REQUESTED` review from any commenter on the resulting PR routes through the fixer auto-chain.

### Recent journal entries (load-bearing for this builder)

- [`entries/2026/06/03/230622Z-result-shepherd-6fa598.md`](../../entries/2026/06/03/230622Z-result-shepherd-6fa598.md) — shepherd diagnosed the same class of failure on PR #411 (zizmor flagged `release.yml:63` `changesets/action@63a615b9... # v1`). The root cause was upstream floating-tag drift: the `v1` tag on `changesets/action` moved from v1.8.0 (the pinned SHA) to v1.9.0 between master's last green run and the PR's run. The shepherd recipe for diagnosis: `curl -s "https://api.github.com/repos/<owner>/<action>/commits/<pinned-sha>"` returns the original tagged version; `curl "https://api.github.com/repos/<owner>/<action>/git/refs/tags/<vN>"` returns the now-drifted tip.
- [`entries/2026/06/03/230831Z-dispatch-liaison-8f370f.md`](../../entries/2026/06/03/230831Z-dispatch-liaison-8f370f.md) and [`entries/2026/06/03/231400Z-result-fixer-8f370f.md`](../../entries/2026/06/03/231400Z-result-fixer-8f370f.md) — the fixer dispatch + result that addressed the `changesets/action` mismatch as PR [#421](https://github.com/endojs/endo-but-for-bots/pull/421). **The builder should check whether PR #421 has merged before opening its own audit PR**; if #421 is still open, the builder's broader audit may overlap (the changesets/action line) or conflict at the rebase. Recommended ordering: let #421 land first, then audit the remaining `uses:` sites.
- [`entries/2026/06/03/230728Z-message-shepherd-dfe4c4.md`](../../entries/2026/06/03/230728Z-message-shepherd-dfe4c4.md) — field-note proposal for `skills/pr-ci-watch/SKILL.md` § *Notes from the field* documenting the floating-tag-drift class of `zizmor` failure. The builder may want to verify each of its proposed pin changes against the same `curl` recipe before committing.
- [`entries/2026/05/22/024433Z-result-shepherd-df0510.md`](../../entries/2026/05/22/024433Z-result-shepherd-df0510.md) § *Cluster B: zizmor* — shepherd diagnosis on PR #347 enumerating four classes of zizmor finding in `.github/workflows/ci-docs.yml` and `.github/workflows/familiar-release.yml`: `overly broad permissions`, `code injection via template expansion`, `runtime artifacts potentially vulnerable to a cache poisoning attack`, and the `action's hash pin has mismatched or missing version comment`. Today's builder is scoped to the **last** class only; the other three are out of scope. The builder should not silently expand into permission-tightening or template-injection cleanup — those would inflate the diff beyond `chore(ci): align workflow action hash pins`.
- [`entries/2026/05/21/054802Z-result-weaver-7d7d5e.md`](../../entries/2026/05/21/054802Z-result-weaver-7d7d5e.md) § *Conflict resolutions (by file)* — names the full set of `.github/workflows/` files that carry `uses:` pins on `endo-but-for-bots@llm`: `ci.yml`, `browser-test.yml`, `depcheck.yml`, `release.yml`, `typedoc-gh-pages.yml`, `update-action-pins.yml`, `update-action-pins-major.yml`. Useful as a hint at the audit surface size, though the builder operates on `master` (a smaller set) where some of these workflows may differ.

### Skills the builder should consult (in order)

- [`garden/skills/frozen-base-branch/SKILL.md`](../../../garden/skills/frozen-base-branch/SKILL.md) — open the DRAFT PR against a `master-<short-sha>` snapshot per the project's standard fork-PR discipline.
- [`garden/skills/pre-push-gates/SKILL.md`](../../../garden/skills/pre-push-gates/SKILL.md) — note that the gate is auto-fix + probes + typecheck, but does **not** include `zizmor`. The builder should run `zizmor --persona pedantic --min-severity low .` locally as a separate step before pushing, since that is the canonical reproduction of the CI workflow's failing audit.
- [`garden/skills/pr-creation-flow/SKILL.md`](../../../garden/skills/pr-creation-flow/SKILL.md) — the standard chain (builder opens DRAFT → cleaner → judge → fixer-loop → judge un-drafts). "Run the gamut" in the dispatch brief invokes this chain.

### Why each reference is relevant

- The CONTRIBUTING.md section names the **mechanism** the project uses (`update-action-pins.mjs`); a builder that ignores it risks proposing a manual SHA-by-SHA edit that conflicts with the updater's automatic regeneration on a future run.
- The fresh shepherd / fixer / message triad on 2026-06-03 names the **exact same finding class** the builder is being dispatched against, but for one workflow line. The builder must check whether that fix (PR #421) has landed before re-doing or stomping the work.
- The CI-no-npm-lifecycle section grounds `check-action-pins` as a pre-existing CI gate, so the builder knows the audit infrastructure already exists and does not need to be invented.
- The 2026-05-22 shepherd entry enumerates the full set of zizmor finding classes on this repo's workflows, helping the builder stay in scope (just the pin-comment mismatches).
- The 2026-05-21 weaver entry sketches the workflow-file surface size for any builder audit decision.
- The project README anchors carry the routing posture (master-base, comment authorization, maintainer-equivalent commenter pool).

### Open questions

- **`update-action-pins.mjs`'s tag-resolution logic**: the proposed prompt asks whether the updater could be widened to catch the mismatch class earlier. The library has no section on the updater's internals (only its CLI surface from CONTRIBUTING.md). If the builder decides to extend the updater, it will need to read the script directly in the project worktree; there is no library shortcut for that path. A librarian / scholar engagement to ingest the script's docstring into a library section would close this gap.
- **`zizmor` configuration**: the workflow runs `zizmor --persona pedantic --min-severity low .` (per the proposed prompt). The library has no entry on `zizmor`'s persona model, finding classes, or upstream documentation. A `library/sources/zizmor--docs.md` would be the natural target if `zizmor` keeps recurring as a CI failure source.
- **Floating-tag-drift recurrence cadence**: the 2026-06-03 shepherd message suggests this class will recur whenever any pinned `@<sha> # vN`-style action's upstream cuts a new minor release. Whether to land that note in `skills/pr-ci-watch/SKILL.md` § *Notes from the field* (proposed by the shepherd) or to extend `update-action-pins.mjs` to compare-and-rewrite the comment automatically is an open architectural question for the maintainer.
```

## Library writeback

Added 14 keyword shortcuts to `journal/library/keywords.md`, all pointing into the existing `endo--contributing--initial-setup.md` section (the canonical `update-action-pins.mjs` material) and one pointing at the 2026-06-03 shepherd message entry (the floating-tag-drift field note). Shortcuts:

- `zizmor`, `zizmor pedantic`, `zizmor mismatched version comment`
- `action's hash pin has mismatched or missing version comment` (the literal error string)
- `action hash pin`, `GitHub Action pin`, `` `uses:` SHA pin ``, `` `# v1` version comment ``
- `` `update-action-pins.mjs` ``, `` `update-action-pins-major.yml` workflow ``, `action-pin updater`
- `` `--check-pins` ``, `` `--min-age-days` ``
- `floating-tag drift` (pointing at the shepherd message entry, not the section, since the section does not yet cover this pattern)

No concept-page draft this engagement: a `zizmor` concept page would be useful but the source material (`zizmor`'s upstream docs, the persona model) is not yet ingested as a library source, so the page would lean on weak foundations. Surfaced as an Open question instead.

No distraction-prune this engagement: the keyword search did not turn up a concept page that was *misleading* on the term, only one that was *missing* on the term. The `check-action-pins parallel CI job` entry on the keyword index already exists and points the right way; the new entries complement it rather than override it.

## Open questions

(Listed in the refinement block above.) Surfacing them again for the librarian's queue:

- `update-action-pins.mjs` internals (script docstring → library section).
- `zizmor` upstream docs (persona model + finding classes → library source).
- Floating-tag-drift recurrence cadence (skill note vs updater extension → maintainer architectural decision).

Self-improvement: nothing this time at the structural level. The keyword-index gap on `zizmor` and `update-action-pins.mjs` is the exact class of writeback this skill is for; the index improvement lands inline, and the deeper gaps surface as Open questions for the next library engagement.
