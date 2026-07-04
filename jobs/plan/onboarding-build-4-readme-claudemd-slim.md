---
gate: orchestrated
orchestrated_by: onboarding-implementation
priority: normal
posted_by: producer
posted_at: 2026-07-04T07:00:24Z
---

---
role: builder
model: opus
---

# Build (phase 4/4): slim README.md and CLAUDE.md to the residues

**GARDEN self-development.** Per-job worktree off `origin/main2`; push **directly to `origin/main2`** (no PR). **Runs LAST** — only after phases 2 and 3 land, so no window exists where a procedure has no home. Implement from **`designs/streamlined-onboarding.md`** § 4, § 4.1, § 4.2, and § 6 phase 4. The test throughout: **if Claude can readily do it for the user, it leaves the README.**

> **Worktree caution (host endolinbot2):** if your `gardener-wt-*` git admin entry is swept mid-job, commit/push from a standalone scratch clone.

## `README.md` (§ 4.1)

Cut § 1 (Getting started) to the ~15-line golden-path residue: pitch → the three steps (clone → `./garden` → say `help`) → residue paragraph (Docker; a Claude subscription or API key; a bot GitHub account) → the `./garden sh` / `./garden reset` escape-hatch lines → one sentence on naming instances (`echo <name> > .garden`). **Keep** § Key vocabulary, § 2 Control surfaces, § 3 How it works (conceptual orientation — Q6 recommendation), moving only the command snippets inside § 3 (plan/schedule verbs) to `context/operations/schedules.md` with a link back. Every migrated procedure must already live in `context/` (phase 2).

## `CLAUDE.md` (§ 4.2)

Remove the operational command detail now homed in `context/`:
- § Bringing up local systemd services (steps 1–8) → keep a **three-line pointer** (unique identity is sacred; say *help* / *start the garden* and the liaison performs the rest; command detail in `context/`).
- § Leader and follower hosts → keep only the two standing behaviors (watch the marker on every host; singletons are leader-only); route the rest to `context/operations/leader-follower.md`.
- § Deliberate deploy → keep two lines; route to `context/operations/deploy.md`.
- Gardener scaling, § Racing a schedule change → route to `context/operations/{scaling,schedules}.md` (keep the one-line schedule verb mapping).
- § Host environment → keep the two-sentence `GARDEN` identity definition; route the rest to `context/first-run/identity.md`.
- **KEEP VERBATIM** (standing policy, not operational detail): § Monitoring safety constraint and all its safety text, § Container guard, § Orchestrator vocabulary, § How work reaches workers, and the inventories. Do not weaken any safety constraint.

Also shrink the longer procedural passages in `roles/liaison/AGENT.md` to routes into `context/operations/` (keep its role-norm contracts).

## Definition of done

README is pitch → three steps → residue → surfaces → how-it-works (§ 1 ≈ 15 lines); CLAUDE.md § Job-system operational detail is replaced by pointers into `context/` with all safety constraints and the dispatch contract kept verbatim; no procedure is orphaned (grep the removed procedures to confirm each has a `context/` home). Push to main2; report the commit sha.
