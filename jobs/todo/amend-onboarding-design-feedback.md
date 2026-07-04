---
role: designer
model: fable
---

# Design amend: fold maintainer feedback into `designs/streamlined-onboarding.md`

**GARDEN self-development.** Your per-job worktree is off `origin/main2`. **Amend the EXISTING design file** `designs/streamlined-onboarding.md` (do not create a new design) and push **directly to `origin/main2`** (no PR, garden convention). First read the current design in full so the amendments stay coherent with its structure, its `context/` tree, its migration map, and its § 5 open questions and § 6 build jobs.

> **Worktree caution (this host):** commits from a per-job `gardener-wt-*` worktree have been swept mid-job by the keeper's prune path on endolinbot2. If your assigned worktree's git admin entry vanishes, commit and push from a standalone scratch clone (as the prior run of this design did). A fix is already in flight (`fix-journal-worktree-keeper-stale-registration`).

The maintainer reviewed the design and gave this direction. Fold each point into the design doc (and update the affected § 5 open questions and § 6 build jobs to match):

## 1. Rename "bringing up the fleet" → "Starting the garden", and deemphasize the commands

Wherever the design (and its migrated `context/` fragments and the CLAUDE.md § Job system migration) refers to *bringing up the fleet* / bring-up steps, retitle the concept **"Starting the garden"**. Deemphasize the individual commands: the streamlined story is that a new user **enters the Claude CLI and asks Claude to start the garden**, and the **liaison performs the bring-up steps** (install/enable units, set the worker count, designate leader, arm inboxes, etc.). The individual commands belong in `context/operations/` as agent-facing detail the liaison executes on demand — **not** as a human checklist anyone is expected to run by hand. The first-run tutorial's "start the garden" stage should be conversational ("say: start the garden"), the liaison doing the work and asking before consequential steps.

## 2. `./garden` requires no environment variables; make the `.garden`-file the preferred identity path

Bare `./garden` must fully work with **satisfactory defaults and zero required environment variables**. Identity override has two forms; present the **`.garden`-file form as the streamlined, preferred** one and the env-var form as a convenience:

- **Preferred (streamlined):** `echo petunias > .garden` then `./garden`. The launcher reads `.garden` for the shard identity and builds/names the container from it.
- **Convenience (belt-and-suspenders):** `GARDEN=petunias ./garden` — sets the container `--hostname` **and** writes the `.garden` file so the container is built/named from that identity. The maintainer explicitly calls this belt-and-suspenders: keep it working, but document the `.garden`-file write as the simpler default and the env var as sugar over it.

Reflect this in the golden-path prose and the `garden`-script design so the "fewest commands" story leads with bare `./garden`, mentions `echo name > .garden` as the one-liner to name an instance, and treats `GARDEN=… ./garden` as equivalent convenience.

## 3. `./garden` enters claude directly; `./garden sh` is the debug shell

Confirm and specify the launcher/Dockerfile changes so that:
- **bare `./garden`** builds if needed, enters the container, and **execs `claude` directly in auto mode** — no extra step, no shell in between.
- **`./garden sh`** enters an interactive **shell** for debugging. **Rename the escape hatch from `./garden shell` to `./garden sh`** throughout the design (golden path, § 6 build jobs, any context fragment).

This requires actual changes to **both the `Dockerfile` and the `./garden` script**; make sure the § 6 build jobs name those two files explicitly and describe the `sh` subcommand.

## 4. Auto-mode default (§ 5 Q2) — resolved toward bypass

The maintainer's direction that bare `./garden` "enters claude directly in auto mode" and that the user should "just say help" **confirms the design's recommended default**: launch Claude Code in auto / `--dangerously-skip-permissions` mode, matching the fleet's existing headless posture. Mark § 5 Q2 **Resolved: auto-mode is the default** (the interactive liaison still asks before consequential garden operations per the tutorial design). If any residual safety nuance remains, keep it as a one-line note rather than an open question.

## Definition of done

`designs/streamlined-onboarding.md` on `main2` reflects all four points, coherently integrated (not appended as a changelog): the "Starting the garden" reframe with commands deemphasized; the no-env-vars default with the `.garden`-file preferred over `GARDEN=… ./garden`; `./garden` → direct claude and `./garden sh` → debug shell (with the Dockerfile+garden-script § 6 build jobs updated); and § 5 Q2 resolved. Report the pushed commit sha.
