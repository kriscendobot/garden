<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-04T16:55:24Z -->

---
role: builder
model: opus
---

# Build (phase 2/4): author the `context/` tree

**GARDEN self-development.** Per-job worktree off `origin/main2`; push **directly to `origin/main2`** (no PR). Implement from **`designs/streamlined-onboarding.md`** § 3, § 3.1, § 3.2, and § 4 (the migration map is your source content). Author under the **`skills/context-library/SKILL.md`** discipline (abstracts-first, directory READMEs as routing contracts, many small files, cross-link rather than duplicate).

> **Worktree caution (host endolinbot2):** if your `gardener-wt-*` git admin entry is swept mid-job, commit/push from a standalone scratch clone.

## Deliverable: `context/` — a new top-level tree on `main2`, nine leaf pages

Create exactly the shape in § 3.2:

```
context/README.md                 routing index (what this tree is; read on demand by the liaison; two children)
context/first-run/README.md       the tutorial track: ordered conversational stage list + interaction norms (§ 2.3)
context/first-run/identity.md     the GARDEN shard identity; .garden as the one naming knob; GARDEN=… sugar; uniqueness; rename/parallel-pool
context/first-run/auth.md         the three credentials (claude login/API key, bot ssh, bot gh); probes; liaison halves; human clicks; conservative non-bypass variant
context/first-run/first-job.md    posting a first job; board states; core verbs (route to vocabulary)
context/operations/README.md      day-2 routing (pick by symptom/intent)
context/operations/starting.md    "Starting the garden" at command level: linger, install-units, enable-services, set-gardeners, set-main-host, the three Monitors + singleton rules, optional armings (issue inbox, bulletin PAT→docs/bulletin/SETUP.md). Agent-facing detail the liaison runs — NOT a human checklist.
context/operations/leader-follower.md  marker semantics, follower stand-up, drain→stand-down→re-point handoff, no auto failover (route to designs/multibot-leader-follower.md for rationale)
context/operations/scaling.md     sizing the pool, set-gardeners per host, drain on/off
context/operations/deploy.md      deliberate deploy: upgrade-ready signal, deploy-garden.sh, what the root checkout is
context/operations/schedules.md   recurring/one-shot schedules (route to skills/schedule)
context/operations/health.md      failed units, restore (route to skills/restore), reaper/deadmail/poison one paragraph each
```

Each leaf opens with an **abstract that is an exit criterion**, ~one screen. Honor the § 3.1 boundary table: `context/` holds operator procedure, routes to skills/designs rather than duplicating them; cross-refs within `context/` are relative, across trees repo-root paths.

**Content source:** migrate the substance named in § 4.1 (README) and § 4.2 (CLAUDE.md § Job system / § Host environment) **into `context/` now** — this phase copies content here while the sources still carry it; phase 4 trims the sources. Do not delete from README/CLAUDE.md in this phase.

**Also:** amend **`skills/context-library/SKILL.md`**'s scope line so it declares itself canonical for `context/` (main2) as a second canonical tree (same discipline, different branch) — do not fork the discipline.

## Definition of done

The nine-leaf `context/` tree + two directory READMEs + top README exist per § 3.2, each authored to the context-library discipline with exit-criterion abstracts and correct cross-links; migrated content is present (sources untouched); the context-library scope line covers `context/`. Push to main2; report the commit sha and the file list.

---
claim:
  host: endolinbot2
  gardener: 1
  claimed_at: 2026-07-04T16:55:29Z
