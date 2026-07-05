Done. Inbox is empty.

## Completion report

**Job:** onboarding-build-3-vocab-tutorial-wiring (builder, phase 3/4 of streamlined onboarding)

**Commit pushed to `main2`:** `dc65c56e1375e48c63524d485f78fb0a1b8bb3ae`

**What I did** — implemented per `designs/streamlined-onboarding.md` §§ 2, 2.1, 2.3, 6 phase 3:

**CLAUDE.md**
- Added three **vocabulary rows** — `help` / `help <topic>` / `start the garden` — each marked **liaison-session only, never watcher-recognized**, and noted the distinction from the CLI built-in `/help`. They route to the liaison § Help and the `context/` pages.
- Reworked the **session preflight** into an explicit **guard-then-probe** two-step: (1) `check-in-container.sh` guard first (with the rationale that a host-side *help* must draw the guard warning, not a tutorial), (2) a cheap virgin-instance probe (`ls ~/.config/systemd/user/` for `garden-*` units) that greets an unset-up instance with the *help* / *start the garden* invitation. Reconciled with — did not duplicate or reorder — the existing § Container guard.
- **Retitled the bring-up concept to "Starting the garden"**: renamed the `### Bringing up local systemd services` heading, added a reframe callout pointing at `context/operations/starting.md` and `context/first-run/identity.md` (noting the command-detail cut is phase 4), and updated the three named cross-references (§ Host environment, the leader-marker passage, the deploy-on-upgrade passage).

**roles/liaison/AGENT.md**
- Added a **§ Help** section defining the three forms, anchored on the on-demand tutorial track in `context/first-run/README.md` (read just-in-time, no separate script), with the **ask-before-acting interaction contract** (§ 2.3) and the *start the garden* jump into `context/operations/starting.md`.
- Kept the existing stand-up/stand-down and Monitor **contracts** intact; routed their command-level how-to into `context/operations/`.

**Verification:** all referenced `context/` pages (phase 2 output) confirmed present; rebase-CAS push to `main2` landed clean on first try; inbox drained empty.

**Follow-ups:** none new — phase 4 (README/CLAUDE.md slimming) is the next serial child and will cut the still-inline "Starting the garden" steps 1–8 down to the pointer this phase left in place.
