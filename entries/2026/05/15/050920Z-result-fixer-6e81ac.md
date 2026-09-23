---
ts: 2026-05-15T05:09:20Z
kind: result
role: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--6e81ac
prs:
  - repo: endojs/endo-but-for-bots
    pr: 264
    role: target
refs:
  - entries/2026/05/15/044924Z-result-judge-da12e0.md
to: liaison
---

# Result: fixer addresses design-panel must-fix + should-fix on #264

PR: endojs/endo-but-for-bots#264, `design(compartment-mapper): import-attributes propagation proposal`, draft, branch `design/compartment-mapper-import-attributes` against `llm`. New head: `e79247c80`. Pushed six commits between the panel-verdict head (`a2f4d7f48`) and the new head.

## Commits (oldest first)

| SHA | Concern |
|---|---|
| `c3f8b3191` | Must-fix 1: today-shape claim for `FileModuleConfiguration` |
| `b4d94d6dd` | Must-fix 2: sibling-anchor citations repointed to PR #248's stable headings |
| `f541a8d45` | Must-fix 3: `Status: Draft` -> `Status: Proposed` (design + README + totals) |
| `c74c6b7c4` | Must-fix 4: README plan-content integration (milestone, table, graph, size, totals) |
| `f3e6a2e80` | Should-fix 1, 2, 3: SES arity rule paragraph; `moduleMapHook` interaction; policy-passthrough test |
| `e79247c80` | Should-fix 4, 5: Mermaid intro + `pkg->>mod` arrow; tense-slip and partition-table spacing fixes |

## Must-fix items addressed

1. **`resolvedImports` / `FileModuleConfiguration` today-shape claim.** Verified against `packages/compartment-mapper/src/types/compartment-map-schema.ts` lines 233-239: today's schema records `location`, `parser`, `sha512` and no per-import shape. `resolvedImports` is an in-memory and execution-side construct walked by `bundle-lite.js`, `parse-cjs.js`, `policy.js`. The design now frames the `imports` field as net-new on `FileModuleConfiguration`, and the archive-write-path sub-bullet points at the new `imports[specifier]` entry rather than a phantom `resolvedImports` field. Lead-in to `## Compartment-map JSON schema` also reframed. (`c3f8b3191`)
2. **Sibling-anchor citations.** PR #248 was fetched at head `375a3af6` (current after un-drafting). Three of four citations the panel flagged as dead actually resolve to live sections in the current sibling: `## Compartment-mapper implications`, `## Source dispatch`, `## Resolution and resolveHook`; the fourth (`Compartment construction`) needed lengthening to the sibling's actual `## Compartment construction: priming attribute-bearing modules` heading. All four citations now use Markdown anchor links with hash fragments verified against the sibling's current head. (`b4d94d6dd`)
3. **`Status: Draft` not in `designs/CLAUDE.md` § Status Values.** Changed to `Proposed` (sanctioned: "Design under discussion, not yet accepted") in both the design metadata table and the `designs/README.md` summary-table row. Totals line updated 9 -> 10 Proposed, 2 -> 1 Draft. (`f541a8d45`)
4. **`designs/README.md` plan-content integration.** All five sub-items landed: M1 milestone assignment; new row in the M1 milestone table; new `Module Substrate` subgraph in the dependency-graph Mermaid containing `ses-import-attributes` and `compartment-mapper-import-attributes` with an arrow between them; per-design size estimate (M-L, 1 week) in the Per-Design Estimates table after `endo-bytes`; milestone totals (M1 12 -> 13 remaining, 8-10 -> 9-11 weeks, plus-review-queue 10-12 -> 11-13 weeks; grand total 50 -> 51 designs; cumulative timeline columns shifted +1 week downstream). (`c74c6b7c4`)

## Should-fix items addressed

1. **SES arity rule stated once in `## Propagation overview`** as an "**SES arity rule.**" paragraph linked to the sibling's `## importHook signature`. Every later reference to "the arity rule" now has a fixed referent. (`f3e6a2e80`)
2. **Policy-attribute-passthrough invariant** added as a `## Test plan` entry, making the `## Open questions` § 5 assumption observable as a test. (`f3e6a2e80`)
3. **`moduleMapHook` + attribute-bearing-entry interaction** resolved in a three-case clarification paragraph (attribute-bearing import bypasses hook via `modulesWithAttributes`; hook return is specifier-keyed by contract; legacy attribute-free path unchanged). (`f3e6a2e80`)
4. **Mermaid diagram introduction + missing arrow.** Added a numbered five-bullet intro before the diagram naming each participant; added the missing `pkg->>mod: module source bytes` arrow. (`e79247c80`)
5. **Prose hygiene pass.** Tense slip fixed in `## Implications for callers of link.js` (`looked like` -> `looks like`); partition-table inner spacing fixed (`Unchanged.  Continues` -> `Unchanged. Continues`). The "varying 'behavior is preserved' phrasing" resolved when the carry-rule paragraph was trimmed under `f3e6a2e80`. References-bullet punctuation was already consistent (every bullet closes with `).`). (`e79247c80`)

## Top-level summary comment

Posted to PR #264 with addressing SHAs per the panel's "Aggregation" structure. Comment URL: <https://github.com/endojs/endo-but-for-bots/pull/264#issuecomment-4457035469>. The PR has no inline review comments (verified via `gh api .../comments`), so no per-thread replies were needed; the top-level summary is the only conversation artifact.

## CI status

**No checks ran on the new head.** Verified via `gh api repos/endojs/endo-but-for-bots/actions/runs?branch=design/compartment-mapper-import-attributes` (zero workflow runs) and via the commit's check-runs endpoint (zero). The prior head `a2f4d7f48` also had zero check-runs, so this is a pre-existing condition on PR #264, not a regression my pushes introduced.

Cross-check: sibling PR #248 (same `kriscendobot` author) ran the full 4-check matrix (build, lint, test, browser-tests) at head `375a3af6` with all green. The asymmetry between PR #264 (zero runs) and PR #248 (4 green) at the same author suggests one of: workflow-run authorization gated on draft state (PR #264 is draft, PR #248 was un-drafted before its CI fired), GitHub's first-time-contributor approval gating that #248 cleared but #264 has not, or the bot identity's workflow permissions on the project. None of these are inside the fixer's lane to resolve.

The dispatch prompt named "4 design-only checks" as the convergence target. Given that the same 4-check matrix runs on the sibling, the most likely explanation is that CI will fire when the PR is un-drafted (by the judge in the next-stage re-dispatch). Recommendation: re-dispatch the judge against the new head per `next-stage-owed`; when the judge un-drafts, CI should fire on the un-draft event, and if it doesn't, that's a maintainer-side concern.

## Next-stage-owed

Judge re-dispatch against `e79247c80` to re-run the design panel. Per `roles/judge/AGENT.md` and `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop, if the panel surfaces no further in-scope must-fix items, the judge un-drafts (`gh pr ready 264`). Out-of-scope items the panel flagged (`withAttributes` companion-field name, bundler-rejection test entry, CommonJS interop story) ride out of the loop and become candidate follow-ups, not blockers.

## Library look-ups

None; the task was self-contained against the design document, the schema file, and the sibling design. No new keywords or concept-page edits warranted.

Self-improvement: the panel-review skill could call out one verification step explicitly: when a panel finds that a sibling design's section anchors look dead, the fixer should re-fetch the sibling's current head before assuming a section-rename is needed, because the sibling may have evolved since the panel ran. In this dispatch three of four "dead" citations were actually live against the sibling's current head; only one needed renaming. The dispatch prompt's "PR #248 was un-drafted, so the design is now stable" line was the cue. Lesson candidate for `skills/panel-review/SKILL.md` § Sibling-anchor verification: "Before recommending an anchor rename, fetch the sibling repo at its current head; the panel may have run against an older sibling head whose anchors have since landed."
