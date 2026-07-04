---
role: designer
model: fable
---

# Design: streamline the getting-started path (README → ./garden → "help")

**This is GARDEN self-development, not fork work.** Your per-job worktree is already off `origin/main2`; author the design there and push **directly to `origin/main2`** (garden convention: no PR against our own repo — see CLAUDE.md § Conventions). Deliverable is a single design file at `designs/streamlined-onboarding.md`. Do **not** open a PR. This design will spawn separate `build` jobs after the maintainer reviews it; do not implement anything now.

## The goal

Collapse the new-user onboarding to the **fewest manual commands possible**, pushing every step Claude can do on the user's behalf out of the README and into interactive liaison behavior backed by an on-demand, agent-oriented `context/` library. The maintainer's framing:

> Lead with the fewest manual commands on the part of the new user. They should be instructed to (1) create a clone on a system supporting Docker, (2) run the `garden` script to (build and) enter the container, which should `exec claude` in **auto mode** directly, and (3) be instructed to just say **"help"**. The liaison, triggered on the "help" verb, enters an interactive tutorial for the first interactions with the garden, and provides information about garden operation from ancillary documents in `main2`, read in on demand, under a **`context/` directory** with agent-oriented cross-linked context fragments much like the journal's library. **The README.md should not cover *any* detail that Claude can readily and easily do on behalf of the user.**

## What to design

1. **The golden path (the whole README, essentially).** Three steps and no more on the human's part:
   - clone on a Docker-capable host,
   - `./garden` — builds the image if needed and enters the container,
   - entering the container drops the user **straight into Claude Code running in "auto mode"** (not a shell), where they type `help`.
   Specify exactly how "auto mode" is realized (flags / launch mode) and how the container-enter step execs `claude` as an interactive foreground process while the container still runs systemd as PID 1 for the user units. Preserve a debugging escape hatch (a way to still get a plain shell).

2. **The `help` verb → interactive onboarding tutorial.** Define how the liaison recognizes `help` (a first-class vocabulary trigger, like the branch-op verbs) and runs a guided, interactive first-run tutorial: what it walks a brand-new user through (bring-up of the fleet, unique `GARDEN` identity, leader/follower, scaling, arming inboxes, posting a first job), asking before acting, and **offering to run the operational steps itself** rather than printing them for the user to copy. Reconcile the trigger with the § Container guard session-preflight already at the top of CLAUDE.md.

3. **The `context/` library (new tree in `main2`).** An agent-oriented, cross-linked, hierarchical context tree the liaison reads **on demand** to answer operation questions and drive the tutorial — modeled on the journal's library and authored under the existing **`skills/context-library/SKILL.md`** discipline (abstracts-first, descend-only-when-justified, cross-link rather than duplicate). Specify: its index/entry file, its initial fragments, and the boundary against the three neighboring trees so nothing is duplicated:
   - `context/` (new, `main2`) — how to operate this garden instance, for the liaison to read on demand;
   - `references/` (`main2`) — imported roles/skills shelves;
   - `designs/` (`main2`) — design docs like this one;
   - the journal library (`journal2`) — per-instance transcript/library.

4. **The migration map.** Enumerate concretely what moves out of `README.md` and out of `CLAUDE.md § Job system` (the bring-up steps 1–8, leader/follower designation, deploy-on-upgrade, issue-inbox arming, gardener scaling, schedules) into (a) liaison-driven interactive actions and (b) `context/` fragments — and what small residue stays in the README. The test for the README: **if Claude can readily do it for the user, it does not belong in the README.**

## Anchors to read

- Current `README.md` and `CLAUDE.md` (esp. § Job system bring-up, § Leader and follower hosts, § Deliberate deploy, § Container guard).
- The `garden` entry script and the `Dockerfile` (how the container is built/entered; `ANTHROPIC_API_KEY` forwarding; systemd-as-PID-1).
- `roles/liaison/AGENT.md` (vocabulary, posting norms, the Monitor patterns, stand-up/stand-down).
- `skills/context-library/SKILL.md` (the authoring discipline the new `context/` tree must follow) and `journal/library/` (the structural model).

## Open questions to surface (do not silently decide)

- **First-run auth with fewest commands.** A freshly-cloned instance has no `ANTHROPIC_API_KEY` and no logged-in Claude session; `./garden` forwards the key only if it is set. How does the golden path reach a working `claude` in the container with the fewest human steps, and where does auth sit in the three-step story?
- **Auto-mode blast radius.** Launching Claude Code in auto/bypass-permissions mode for a brand-new user — what is the blast radius, and is it acceptable for the interactive liaison (user present) given the gardeners already run headless? What is the safe default, and what should require an explicit opt-in?
- **`exec claude` placement.** Container default `CMD`, versus the `garden` enter wrapper running it — interaction with systemd PID 1 and with `docker exec` re-entry.
- **`help` trigger mechanics.** Literal-string honoring in `roles/liaison/AGENT.md` versus a CLAUDE.md preflight instruction; coexistence with the container-guard preflight.
- **`context/` vs journal library.** Confirm the boundary (shipped-with-code in `main2` vs per-instance in `journal2`) and that operational detail lives in exactly one place, cross-linked from the others.

## Definition of done

`designs/streamlined-onboarding.md` exists on `main2` (pushed directly, no PR), following the project's design conventions, with: the three-step golden path fully specified; the `help`-verb tutorial flow; the `context/` tree shape (index + initial fragments) authored under the context-library discipline; a concrete migration map out of README/CLAUDE.md; and the open questions above made explicit. The report names the design slug and the pushed commit.
