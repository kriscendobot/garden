Job complete. Final state verified: base `master` (current tip `adae30a9`), head `fe0c40a053`, MERGEABLE, inbox empty.

---

## Completion report

**Job:** refresh + shepherd `endojs/endo-but-for-bots` PR #719 (URL/URLSearchParams vetted shim). Maintainer directive: pin base to current upstream master, make unrelated changes vanish, shepherd the result.

**What I did**

1. **Refresh / pin to master.** The branch was already 0-behind master, so I rebuilt it cleanly: cherry-picked the **6 feature commits** onto the current `master` tip (`adae30a9`), dropping the 8 unrelated commits. `HEAD~6 == origin/master` exactly.
2. **Made unrelated changes vanish.** Net diff went from 20 files (incl. workflows + text-encoder churn) to **12 files, `+721/-3`, all SES URL-shim**. Dropped:
   - `.github/workflows/*` — the `actions/setup-node` pin bump (9 files).
   - all `packages/cbor/**` packaging, `@endo/eventual-send` devDep, and the two `yarn.lock` regenerations.
   - the standalone Prettier reformat of `text-encoder-decoder.test.js` (kept only the one-line `url-shim-missing → url-missing` rename reference, which belongs to this PR).
3. **Fixed a real feature defect.** The `urlBlobMethods → urlBlobTaming` rename had left two dangling doc anchors (`#urlblobmethods-options`) in `docs/lockdown.md` and `packages/ses/docs/guide.md`; repointed both to `#urlblobtaming-options`, folded into the rename commit.
4. **Pushed** `--force-with-lease` to the PR head (`47257a3f8f → fe0c40a053`). Base ref stays `master` (this is an endojs-org branch PR against master, not a frozen-base fork PR).

**Verification (real execution)**
- SES URL suite green locally — `url.test.js`, `url-blob-remove.test.js`, `url-missing.test.js`, `text-encoder-decoder.test.js`: **37 tests pass**.
- CI on `fe0c40a053`: **`cover`, `test-xs`, `test262` ×2, `browser-tests`, `build`, `check-action-pins`, `test-hermes`, `test-ocapn-python`, `viable-release` all pass.**

**Shepherd outcome — `next: none` (residual red is inherited from base).** Three checks are red, each reproduced on `master` itself independent of this branch:
- `test` (all matrices): `packages/cbor` — `Cannot find package '@endo/eventual-send'`.
- `lint`: Prettier on `packages/ses/test/text-encoder-decoder.test.js` (pre-existing master formatting).
- `zizmor`: `actions/setup-node` hash-pin comment mismatch (the `v6` tag moved) — identical warnings on master's own runs.

Each had a fix commit on the prior branch, but those *are* the "unrelated changes" I was told to remove, so I dropped them rather than re-apply. This is the genuine tension between "unrelated changes vanish" and "shepherd to green": the residual red cannot be cleared without re-introducing the removed changes. Clearing it belongs on `master` or a separate hygiene PR.

**Outward artifact:** summary comment posted (standing authorization for endojs/endo-but-for-bots) — https://github.com/endojs/endo-but-for-bots/pull/719#issuecomment-5042498761 — carrying the head SHA, the drop list, verification status, and the decision flag for the maintainer.

**Follow-up for the maintainer:** decide whether to (a) accept the inherited red on this PR, (b) fix `packages/cbor` uniformity + `@endo/eventual-send` devDep + the setup-node pin on master, or (c) authorize re-adding those minimal fixes here.
