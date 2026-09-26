Inbox is empty (only a benign transient warning). The job is complete.

## Completion report

**Job:** onboarding-build-2-context-tree — Build phase 2/4: author the `context/` tree.

**Commit:** `1d69ac754`, pushed to `main2` (`8fdbd11e0..1d69ac754`).

**What I did**

Authored the new top-level `context/` tree on `main2` — the garden's on-demand operations manual for agents — implementing exactly the shape in `designs/streamlined-onboarding.md` § 3.2, under the `skills/context-library/SKILL.md` discipline (exit-criterion abstracts, directory READMEs as routing contracts, many small files, cross-link rather than duplicate). Content migrated from `README.md` (§ 4.1) and `CLAUDE.md §§ Job system / Host environment` (§ 4.2) per the migration map; **sources left intact** (phase 4 trims them).

**Files created (12):**
- `context/README.md` — routing index (what the tree is, read on demand by the liaison, two children)
- `context/first-run/README.md` — the tutorial track: ordered conversational stage list + the § 2.3 interaction norms
- `context/first-run/identity.md` — GARDEN shard identity; `.garden` as the one knob; `GARDEN=…` sugar; uniqueness; rename/parallel-pool
- `context/first-run/auth.md` — the three credentials; probes, liaison halves, human clicks; conservative non-bypass variant
- `context/first-run/first-job.md` — posting a first job; board states; core verbs (routes to vocabulary)
- `context/operations/README.md` — day-2 routing by symptom/intent
- `context/operations/starting.md` — bring-up at command level (linger, install/enable units, set-gardeners, set-main-host, the three Monitors + singleton rules, optional armings)
- `context/operations/leader-follower.md` — marker semantics, follower stand-up, drain→stand-down→re-point handoff, no auto failover
- `context/operations/scaling.md` — sizing the pool, set-gardeners per host, drain on/off
- `context/operations/deploy.md` — deliberate deploy: upgrade-ready signal, deploy-garden.sh, the root checkout
- `context/operations/schedules.md` — recurring/one-shot schedules (routes to skills/schedule)
- `context/operations/health.md` — failed units, restore (routes to skills/restore), reaper/deadmail/poison one paragraph each

**File modified (1):**
- `skills/context-library/SKILL.md` — amended the scope line to declare it canonical for `context/` on `main2` as a second canonical tree (same discipline, different branch), not a fork of the discipline.

**Verification**

Tree shape matches § 3.2 exactly (top README + 2 directory READMEs + 9 leaves). All within-tree relative links resolve to real files (checked programmatically); all cross-tree repo-root references (skills, designs, roles, docs, README, CLAUDE) resolve. Cross-refs follow the § 3.1 rule: relative within `context/`, repo-root paths across trees.

**Follow-ups (already scoped as later phases, not for this job)**

- Phase 3: vocabulary + tutorial wiring (CLAUDE.md `help` row, virgin-instance preflight probe, `roles/liaison/AGENT.md` § Help).
- Phase 4: slim `README.md` and `CLAUDE.md` down to the § 4 residues, now that `context/` holds the single home.
