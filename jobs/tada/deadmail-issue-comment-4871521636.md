All work landed on `main2` (`0bac3d4e5`), the reply is posted on issue #22, and my inbox is drained. Here is my completion report.

---

## Completion report

**Job:** dead-lettered comment on kriskowal/garden#22 — "integrate these discoveries more deeply: subsume the new scripts into associated skills, reach them from relevant roles and sub-roles (debugging is a dimension of the fixer, keyed on the project), and roll up XS/slog debugging by role and sub-role (XS envelope spans agoric-sdk and endor in endojs)."

**What I did** (landed on `main2` at `0bac3d4e5`, pushed clean on attempt 1):

- **Two new reusable, role-neutral debugging skills** distilling the #9 discoveries:
  - `skills/xs-debugging/SKILL.md` — the cross-project XS engine envelope: value-stack *width-not-depth* overflow diagnosis, symbolicating a native crash into JS frames, and the targeted `flatMap`→loop rewrite versus the coarse taller-`stackCount` lever (with its snapshot-compat analysis and lockstep-cutover determinism constraint). Explicitly scoped to span **both agoric-sdk** (swingset xsnap worker) **and endojs** (endo XS builds + `xs2rust-endor`), which is the broader envelope the maintainer named.
  - `skills/slog-debugging/SKILL.md` — the swingset slog / flight-recorder reading procedure (preserve `flight-recorder.bin` before teardown, grep the `Stack meter exceeded`/`#error`/exit-12 record, anchor to the failing delivery).
- **A project-keyed sub-role mechanism** (new garden concept the directive described):
  - `roles/fixer/subroles/README.md` — the sub-role selection contract: additive, keyed on the job's repo, grouped by *dimension* (first dimension: debugging), never overrides a base norm.
  - `roles/fixer/subroles/agoric-sdk.md` and `roles/fixer/subroles/endojs.md` — route to the three skills, carrying the #9 project gotchas and the etiquette boundaries.
- **Wire-up:** debugging-dimension section added to `roles/fixer/AGENT.md`; sub-role convention documented in `roles/README.md`; the two skills added to the `CLAUDE.md` inventory; `skills/agoric-chain-snapshot/` cross-linked bidirectionally as the reproduction lever (the `scripts/agoric/*.sh` capture scripts and `repro/` drivers remain subsumed there).
- **Replied on the issue thread** (did not close it): https://github.com/kriskowal/garden/issues/22#issuecomment-4871999586

**Verified:** all 9 cross-links resolve on disk; em-dash and Latin-shorthand style sweeps clean on every new/edited file; push to `origin/main2` confirmed (`d71677bd2..0bac3d4e5`).

**Follow-ups surfaced to the maintainer in the reply (not done here):**
1. If the debugging dimension should be a first-class dimension of *other* roles (builder/investigator), that is a small `subroles/` wire-up on the same pattern — offered, awaiting the word.
2. `agoric-chain-snapshot` references three repro drivers still living only in build worktrees (`repro-upgrade-driver.mjs`, `repro-control-upgrade-driver.mjs`, `cc-upgrade-driver2.mjs`); worth committing under `repro/` so they survive worktree wipes.

**Self-improvement:** introduced the project-keyed sub-role pattern (`roles/<role>/subroles/<key>.md`) and documented it in `roles/README.md` so future roles can adopt it; no separate liaison message needed since I landed it directly on `main2`.
