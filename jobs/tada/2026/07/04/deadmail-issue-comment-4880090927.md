Inbox empty. Work complete.

## Completion report

**Job:** dead-lettered pickup of a maintainer comment on kriskowal/garden#22 — *"Please capture the relevant scripts in the garden repo."*

**Context.** Issue #22 is the ymax0 v320 XS value-stack-overflow postmortem. A prior follow-up on the thread flagged that `skills/agoric-chain-snapshot/SKILL.md` referenced three upgrade-vector repro drivers that "live in build worktrees but are not yet committed under `repro/`." The maintainer's comment asked to capture them. Those drivers (`repro-upgrade-driver.mjs`, `repro-control-upgrade-driver.mjs`, `cc-upgrade-driver2.mjs`, plus the ad-hoc `surface.mjs` probe) were unrecoverable: never committed, absent from git history, and gone from this host (this pickup ran on `endolinbot2`, a bot host with no agoric-sdk tree; no reachable peer holds them).

**What I did (landed on `main2`, `cb04f2fda`):**
- Reconstructed the three referenced drivers faithfully from the SKILL.md methodology, in the same inquisitor idiom as the already-committed `repro-createvat-driver.mjs` / `repro-cc-direct-driver.mjs`, and committed them under `skills/agoric-chain-snapshot/repro/`. All three are `node --check`-clean.
- Repointed the dangling SKILL references (which said "in the build worktree" / "the `ymax0-inquisitor-build` worktree") at the committed copies, and annotated the ephemeral `/tmp/xs6/surface.mjs` probe (not preserved; `cc-upgrade-driver2.mjs` is its durable in-overlay equivalent).
- Documented the new drivers and their provenance in `repro/README.md`.
- Replied on the issue thread ([comment 4880462085](https://github.com/kriskowal/garden/issues/22#issuecomment-4880462085)); did **not** close the issue.

**Honesty note (carried into the code and the issue comment).** These three are reconstructions from documented methodology, **not** the verbatim tested originals, and were **not** re-run here (no snapshot, no built agoric-sdk). Each file header and the README say so and flag the spots to reconcile against a live tree (exact `pushQueueRecord` signature, the `ymax0Kit` consume-space name).

**Follow-ups.** If the verbatim originals still exist in the `kriscendobot` host's build worktrees, the maintainer can point me at them to swap the reconstructions for the real files. The `scripts/agoric/fetch-*.sh` captures and the other three `repro/` drivers were already committed.
