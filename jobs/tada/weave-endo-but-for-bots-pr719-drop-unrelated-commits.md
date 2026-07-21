The weave is complete and verified. Final state confirmed: PR #719 is now a clean 3-commit ses-only diff; all ses-relevant CI checks pass; the three red checks are pre-existing master breakages inherited via the PR merge.

**Weave complete — PR #719 (`feat/hardened-url-vetted-shim`) rewritten to a clean ses-only diff.**

**What I did**
- Fetched an isolated project worktree keyed to this job base and inspected the 6-commit branch. The three commits to drop (`fix(cbor): complete workspace metadata and test setup`, `fix(ci): correct setup-node pin annotations`, `fix(cbor): type canonical fixture cases`) were all at the tip, above the three ses commits (`feat`/`test`/`docs`), and touch strictly disjoint files (cbor package + `.github/workflows` vs. `packages/ses` + docs). So this was a clean tip-chop, not a conflict-prone rebase.
- `git reset --hard` to the docs commit (`66204ddbb`), then `git push --force-with-lease` to the PR head branch (`f11aacfa4 → 66204ddbb`, forced update accepted).

**What changed**
- PR #719 now contains exactly three commits: `feat(ses): permit URL and URLSearchParams…`, `test(ses): pin URL.prototype.constructor taming…`, `docs(ses): document URL lockdown taming (#719)`. PR is `MERGEABLE`.
- The ses URL-shim work is fully green: `cover`, `test-xs`, `test262` (22.x+24.x), `browser-tests`, `test-hermes`, `test-ocapn-python`, `build`, `check-action-pins`, `viable-release` all pass. The url-shim taming runs correctly in CI logs.

**Merge-readiness caveat (important)** — CI did *not* re-converge fully green, but **not because of this weave**. Three checks are red, and all three are **pre-existing master breakages** inherited through the `pull_request` merge, unrelated to the ses shim:
- `zizmor` — action pin-comment mismatches (`249970729cb0`); master's own zizmor audit has been red since the `feat(cbor)` commit. The dropped `fix(ci)` commit never touched this pin, so it wasn't masking it.
- `lint` — prettier issue in `packages/ses/test/text-encoder-decoder.test.js`, a file introduced by master's latest commit (`536f82d18`), not part of this PR.
- `test` — `packages/cbor` fails with `Cannot find package '@endo/eventual-send'`; master's own `CI` run is red on this. This is what the dropped `fix(cbor)` commits had been patching on the branch.

Master's own HEAD `CI` and `Workflow security audit` runs are both `failure`, confirming these are master-level, not regressions here. The unbundling the maintainer asked for is exactly right — but a fully-green merge needs those cbor-metadata, cbor-fixture-typing, ses-test-prettier, and zizmor-pin fixes landed as their **own PRs against master** (the dropped commits are good starting points for the cbor/ci ones). This PR is a clean ses-only diff ready to merge once master's baseline is green (or via admin merge, since it inherits master's red, not its own).

**Follow-ups suggested**
- Separate PR(s) to fix master's red baseline: cbor workspace metadata/deps (`@endo/eventual-send`), cbor fixture typing, `text-encoder-decoder.test.js` prettier formatting, and the zizmor pin-comment annotations.
