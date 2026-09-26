Empty inbox. The job is complete.

## Completion report

**Job:** `design-groom-role` — formally land the **groom** role for the garden's own repo.

**What I did**

1. **Authored `roles/groom/AGENT.md`** (landed bare on `main2`) — a directly-postable role for roadmap upkeep on a consuming project's `designs/README.md`: verify/flip status rows against real merged/open-PR state, re-fit velocity against measured cadence, reproject milestones/timeline, prune-and-archive complete milestones into `ARCHIVE.md`, maintain the dependency graph. It encodes the conventions I confirmed verbatim against the live endo ledger: the **M1→M11 dependency-numbering invariant** (don't renumber unilaterally — surface landing-order conflicts), the **ARCHIVE.md append-don't-prepend split**, the **Strategic Early Items carve-out** (`endo-reminder`/`endo-fetch`), the full-vs-targeted-pass distinction, and the **fork-PR-not-journal-snapshot lane** that the 2026-07-02 `groom-refine-endo-roadmap` pass got wrong. Skills are referenced by path to existing v2 skills (`schedule`, `github-activity-poll`/`review-queue-poll`/`pr-ci-watch`, the three dependency-graph skills, `mermaid-validation`, `frozen-base-branch`, `library-lookup`, `job-board`, `message-bus`).

2. **Decided role-vs-basename → directly-postable role** (added `groom` to CLAUDE.md § Current inventory), justified in the design doc: it carries load-bearing operating norms no existing role owns, the lane-mismatch is exactly the failure a brief prevents, it's recurring/schedulable, and a full pass is designer-tier judgment work ($12/Opus/6-way fan-out per `groom-endo-designs-readme`).

3. **Skills decision → fold + reuse, don't mint.** The four v1 skills never existed as files; rather than mint speculative stubs I folded `velocity-recalibration`/`roadmap-projection` into the brief and mapped dependency-graph/open-questions onto existing v2 skills — matching how the successful ad-hoc passes actually ran. Left as an open question for the maintainer to overrule.

4. **Corrected the stale manifest** — the `groom` + four-skill rows in `designs/v1-migration-manifest.md` no longer imply a reference-shelf file exists; they point to the new role/design.

5. **Design doc + open-questions PR carve-out.** `designs/groom-role.md` (landed bare) carries a genuine `## Open questions` section (mint-vs-fold the velocity/projection skills; whether to pin `groom` in the fleet per-role model policy; project-only vs garden-own scope). Per the designer norm I took the open-questions-PR carve-out: **draft PR kriscendobot/garden#84** against a frozen base (`groom-role-f4e6106430`), diff = `designs/groom-role.md` alone, marked `<!-- garden-design-open-questions -->` so the completion machinery stages no design panel.

**What changed:** `roles/groom/AGENT.md` (new), `designs/groom-role.md` (new), `designs/v1-migration-manifest.md`, `CLAUDE.md`. All on `main2` (commits `f4e6106430`, `f3be014d3d`).

**Follow-ups** (all in the PR + design doc, awaiting maintainer): confirm skill mint-vs-fold; confirm/decline the `role_default_model`/`role_tier_floor`/`role_default_effort` + `model-selection` pin at designer tier; confirm scope boundary vs the garden's own planning machinery.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-groom-role.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 66 tokens (2335556 cached reads)
- Output: 27318 tokens
- Cost: $2.4009455
- Wall-clock: 448s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
