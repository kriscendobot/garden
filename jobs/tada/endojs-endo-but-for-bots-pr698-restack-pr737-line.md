Done. Empty inbox, work complete.

## Completion report — weave PR #698 onto restacked #541

**Verified predecessor landed.** `build/sturdyrefs-endor-syscall-retention` (the #541 branch, #698's base) was force-updated `fab626e84a → 379cc83774` and now descends from `build/sturdyref-pass-style-ocapn-single` — the arbitrated #774→#737 line. Base was unchanged (already named that branch); only #698's own branch needed rebasing.

**Rebase.** In an isolated project worktree keyed by this job's base, ran `git rebase --onto origin/build/sturdyrefs-endor-syscall-retention fab626e84a build/sturdyref-bridge-1-bytes-wire-read`. The old base was exactly the old merge-base, so this carried only #698's two own commits. Text rebase was conflict-free (`range-diff` = identical).

**Arbitration resolution.** A latent semantic drift surfaced at test time: #698's added codec test referenced accessor `getSturdyRefDetails`, which the arbitrated base renamed to `getSturdyRefLocator` (already used by the sibling sturdyRef tests, returns `{location, secret}`). Folded that one-symbol fix into the originating `fix(ocapn):` commit via autosquash — no other resolution needed (camelCase `'sturdyRef'` discriminator, lowercase OCapN vocab, `@endo/sturdyref` home, prefix `l` all consistent).

**Tests (ses-ava / ava-endo-lockdown), all green:**
- `passable.test.js` — **85 passed** (the new bytes-preserving non-ASCII byte-secret round-trip + the load-bearing confinement sweep over own-props and full prototype chain)
- `sturdyref.test.js` 7 · `descriptors.test.js` 13 · `components.test.js` 2 · `subtypes.test.js` 20 · `operations.test.js` 52 · `passable-fuzz.test.js` 1

**Pushed** `--force-with-lease` → new head `6a03f5a396`; confirmed ancestor-clean on the moved base and PR still OPEN/DRAFT. Commented the new head + test evidence on #698. Kept DRAFT.

**Env note (for peers):** `/tmp` is `noexec` here, which is the root cause of the "permission denied: ses-ava / prebuild-install / node-gyp" failures during `yarn test`/install under the pnpm linker. Ran ava via `node <store>/ava-virtual-.../entrypoints/cli.js` with a shim placed **under home** (not `/tmp`). No `main2` garden changes (project-only job).

**Follow-ups:** none blocking. #698 stays DRAFT per its bridge-cut-1 status; the next cut in the bridge stack can rebase onto `6a03f5a396`.
