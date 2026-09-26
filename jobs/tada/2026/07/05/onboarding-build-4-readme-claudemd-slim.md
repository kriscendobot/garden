Phase 4 landed on `origin/main2` as **949cd1c8e**. Inbox is clear.

## Completion report

**Job:** onboarding phase 4/4 — slim `README.md` and `CLAUDE.md` to the residues, implementing `designs/streamlined-onboarding.md` §§ 4/4.1/4.2/6. Ran last, after phases 2–3 landed the `context/` tree and tutorial wiring, so no procedure was ever homeless.

**What changed** (3 files, +109 / −304):

- **`README.md` § 1 (Getting started):** cut from ~110 lines to the ~29-line golden-path residue — pitch → the three steps (clone → `./garden` → say `help`) → the human-only residue paragraph (Docker; Claude subscription or API key; a bot GitHub account) → the `./garden sh` / `./garden reset` escape-hatch lines → one sentence on naming instances (`echo <name> > .garden`). Kept **§ Key vocabulary, § 2 Control surfaces, § 3 How it works** intact (conceptual orientation, per the Q6 recommendation). Moved the § 3 plan/schedule command block to a prose pointer into `context/operations/schedules.md`.
- **`CLAUDE.md`:** replaced the § Job-system operational detail with pointers into `context/` — Starting-the-garden steps 1–8 → a three-line pointer (unique identity is sacred; say *help* / *start the garden*; command detail in `context/`); Leader/follower → the two standing behaviors only (watch the marker on every host; singletons leader-only); Deliberate deploy → two lines; Racing a schedule → one-line verb mapping; § Host environment identity-resolution/rename → `context/first-run/identity.md`. **Kept verbatim** (per the caution not to weaken any constraint): § Monitoring safety constraint, § Container guard, § Orchestrator vocabulary, § How work reaches workers, the inventories, and the bot-identity git-config / gh-wrapper pinning.
- **`roles/liaison/AGENT.md`:** shrank the stand-up/stand-down and deploy-on-upgrade **procedural** passages to routes into `context/operations/{starting,scaling,leader-follower,deploy}.md` and `context/first-run/identity.md`, keeping the role-norm **contracts** (singleton rules, watch-the-marker, ask-before-acting, handoff ordering).

**Verification:** grepped every removed command (`enable-linger`, `install-units.sh`, `set-gardeners.sh`, `set-main-host.sh`, `set-garden-repo.sh`, `maintainer-watch.sh`, `deploy-garden.sh`, `set-schedule.sh`, `drain-fleet.sh`, `maintainer-reply/archive`, `drain`) — each has a `context/` home. No dangling cross-references to gutted sections remain (`Starting the garden, step N`, `README § Getting started`); the `#the-ferry-...` anchor still resolves.

**Follow-ups:** none. This completes the streamlined-onboarding migration (phases 1–4 all landed). The design doc's own row (`§ Bringing up local systemd services…`) still describes the old CLAUDE.md title, which is correct as a historical migration record.
