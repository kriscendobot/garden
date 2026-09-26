Design job complete — `designs/streamlined-onboarding.md` is on `main2` at commit `40f4d35`.

# Completion report: design-streamlined-onboarding

**Deliverable:** `designs/streamlined-onboarding.md` (slug `streamlined-onboarding`), pushed directly to `origin/main2` as commit `40f4d35d8cb09747e7c35316893ce6b5a17264bd` (no PR, per garden convention), plus a Proposed row in `designs/README.md`'s index.

**What the design specifies:**
- **The golden path** — clone → `./garden` → say `help`. The launcher auto-builds the image, seeds `.claude/settings.json` at container creation exactly the way it already seeds `.garden` (host-side write into the bind-mount root, closing the SessionStart-hook gap recorded in CLAUDE.md § Container guard), and execs `claude --dangerously-skip-permissions` as the interactive foreground process via `docker exec` while `CMD` stays systemd as PID 1. `./garden shell` is the plain-bash escape hatch. Auth adds zero numbered steps: Claude login happens inside step 2 (the tool prompts), bot GitHub auth becomes a tutorial stage.
- **The `help` verb** — first-class liaison-session vocabulary (never watcher-recognized), wired as a CLAUDE.md vocabulary row plus a virgin-instance greeting in the session preflight (guard first, probe second) and a § Help section in the liaison brief. The eight-stage ask-before-acting tutorial's script *is* `context/first-run/` — no separate script to drift.
- **The `context/` tree** — `context/{README,first-run/×8,operations/×6}` on `main2` under the context-library discipline (whose scope line gets amended to cover it), with an explicit boundary table against `designs/`, `references/`, `roles/`/`skills/`, and the per-instance journal library: shipped operational detail lives in exactly one place.
- **The migration map** — section-by-section dispositions for README (§ 1 shrinks to ~15 lines; §§ 2–3 stay as conceptual orientation) and CLAUDE.md § Job system (bring-up steps 1–8, leader/follower mechanics, deploy, arming, scaling, schedules move out; safety constraints and dispatch contract stay), plus four phased build jobs (serial 2→3→4, phase 1 parallel).
- **Open questions** surfaced with recommendations, not silently decided: auto-mode default (recommend bypass, matching the fleet's existing headless posture — explicit sign-off requested), auth ordering, exec placement, help mechanics, tree boundary, README depth.

**Deviations/incidents:** my per-job worktree's git admin entry under `/home/kris/.git/worktrees/` was swept twice mid-job; I recreated it once, then committed and pushed from a standalone scratch clone instead. Evidence points at the `garden-journal-worktree-keeper` repair path (its log shows a dangling `fatal: not a git repository: /home/kris/garden2/.git/worktrees/journal` every tick, and its self-heal runs `git -C $GARDEN_ROOT worktree prune`).

## Follow-ups

- The maintainer should review `designs/streamlined-onboarding.md` and answer its § 5 open questions (especially Q2, the auto-mode default — a security-flavored decision); the four § 6 build jobs are gated on that review and should be posted as an orchestration afterward.
- Investigate on host endolinbot2: `garden-journal-worktree-keeper` logs a dangling gitdir reference to `/home/kris/garden2/.git/worktrees/journal` every tick, and per-job `gardener-wt-*` worktree admin entries under `/home/kris/.git/worktrees/` are being pruned out from under live gardeners — this will corrupt any job that tries to commit from its assigned worktree on this host.
