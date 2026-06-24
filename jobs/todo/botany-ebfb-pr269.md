# Botany: assess and dispose of endo-but-for-bots dependabot PR #269

Repo: `endojs/endo-but-for-bots` (a bot-owned fork; the bot holds merge authority).
PR: #269 (authored by `dependabot[bot]`).

Wear the **botanist** role per `garden/roles/botanist/AGENT.md` (updated 2026-06-24,
carries autonomous accept/close/defer authority for dependabot PRs on bot-owned repos).
Read `garden/roles/COMMON.md` then that role file first; load skills on demand.

## Authorization (explicit, per `roles/COMMON.md` external-repo etiquette)

This repo is bot-owned and this job authorizes, for PR #269 specifically:
- **comment** — post the structured verdict as a single PR comment.
- **merge (conduct)** — on a MERGE-NOW verdict, conduct the PR onto the repo's main
  branch reusing the conductor's standing merge discipline. Do NOT name a merge
  method; let the conductor norm / repo default decide.
- **close** — on a REJECT verdict, `gh pr close 269` with the verdict comment attached.
- **schedule-defer** — on an EMBARGO verdict, record the maturity date in the
  endo-but-for-bots dependabotany ledger and ensure the daily `dependabotany-recheck`
  schedule exists per the role's Autonomous disposition section.

## Task

Run the botanist workflow end to end on PR #269:
1. Pre-flight the diff (lockfile + manifest only).
2. Read the full lockfile transitive set; enumerate every moved version, flag any
   newly-introduced package and any version published in the last 24h.
3. Install with preinstall scripts disabled.
4. Read the upstream source for the headline and every transitively changed package.
5. Check each moved version against GHSA / `npm audit` / OSV.
6. **Shepherd CI to green** (reuse `roles/shepherd/AGENT.md`); classify each failure
   flake vs. real; cross-check, do not trust, the existing rollup.
7. Maturity/compromise assessment (7-day embargo for non-CVE upgrades).
8. Render **MERGE-NOW / EMBARGO-YYYY-MM-DD / REJECT**, gated on the full criteria
   (green CI alone is never sufficient).
9. **Execute** the disposition autonomously (conduct / close / schedule-defer).
10. Post the verdict comment and update the dependabotany ledger.

Report the verdict, the executed disposition, and (if embargoed) the maturity date.
