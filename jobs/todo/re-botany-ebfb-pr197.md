# Re-botany endo-but-for-bots #197: terminal MERGE-NOW / REJECT verdict

Repo: `endojs/endo-but-for-bots`, PR **#197**. Wear the **botanist** role
(`roles/botanist/AGENT.md`, the 2026-06-24 revision carrying autonomous
accept/close/defer authority for dependabot PRs on bot-owned repos).

## Context (do not re-derive the full assay)

#197's dependency substance was already vetted clean and mature by the prior
botany pass (electron 42, no GHSA/OSV advisory). The PR was then rebased onto
current `llm` and force-pushed; new head **4d13a7cdc**. The rebase was mechanical
(only `yarn.lock` conflicted), the ESM migration (preload->ESM, CJS-shim drop)
was preserved intact, and the lockfile was regenerated against the new base.

**The one substantive change the rebase introduced:** the regenerated lockfile
moved electron from the originally-vetted **42.0.1** to **42.5.0** (the PR pins
`^42.0.1`; the caret resolves to the newest 42.x). This is the moved set the
re-botany must re-vet.

## Task (cheap re-confirmation, gated on CI green)

1. Wait for / confirm CI is green on the rebased head (the `shepherd-ebfb-pr197`
   job drives it). Green CI alone is never sufficient for MERGE-NOW.
2. Re-enumerate the lockfile's moved set; confirm electron resolved to 42.5.0 and
   flag anything else the regeneration pulled. Check that no entry was published
   in the last 24h.
3. Re-run GHSA / `npm audit` / OSV against electron 42.5.0 and the final moved
   transitive set.
4. Maturity/compromise assessment (7-day embargo for non-CVE upgrades; 42.5.0's
   publication age applies).
5. Render the terminal **MERGE-NOW / EMBARGO-YYYY-MM-DD / REJECT** verdict and
   **execute** the disposition autonomously.

## Authorization (per `roles/COMMON.md` external-repo etiquette)

This bot-owned repo authorizes, for #197 specifically:
- **comment** — post the structured verdict as a single PR comment.
- **merge (conduct)** — on MERGE-NOW, conduct onto the repo's base branch reusing
  the conductor's standing merge discipline. Do NOT name a merge method.
- **close** — on REJECT, `gh pr close 197` with the verdict comment attached.
- **schedule-defer** — on EMBARGO, record the maturity date in the
  endo-but-for-bots dependabotany ledger and ensure the daily
  `dependabotany-recheck` schedule exists.

## Definition of done

Terminal verdict rendered against the rebased head's final moved set, disposition
executed autonomously, verdict comment posted, dependabotany ledger updated.
