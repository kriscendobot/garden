---
ts: 2026-05-20T03:01:15Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/20/024907Z-dispatch-liaison-39160e.md
---

Ferried six follow-up commits from `endojs/endo-but-for-bots#109` onto `endojs/endo#3256` as a fast-forward append on top of `b1cf4aff`. No force-push.

Upstream head after push: `e691e86d8fc7f64d23854a1e3f3fddb29af3b1be`. Remote response: `b1cf4affd..e691e86d8` (no `+`).

Six new commit SHAs (in apply order, oldest first):

1. `639a292054c34b8b8ba0438372753189e14ffc82` test(syrup-frame): note makePipe refactor opportunity for makeArrayWriter
2. `870c3befe40fbbad6e8fe6f800f3195b8bdb26b8` test(syrup-frame): drop ASCII section banner
3. `6cd3f6b32f50f669b4d1d76efcde6d10ae84d801` chore(syrup-frame): drop the unreleased placeholder CHANGELOG.md
4. `0ce0d61f58896b7f8c98782c51347a7fa6c9a95a` fix(ocapn): invert tcp-test-only default to syrup framing
5. `885e377c4c82a42a22b67f0d17b23b8226aac4b7` docs(syrup-frame): cite 2025-12-09 OCapN plenary on TCP-for-testing framing
6. `e691e86d8fc7f64d23854a1e3f3fddb29af3b1be` refactor(ocapn): drop async indirection in syrup-framing socket writer

Attribution: `git log b1cf4aff..HEAD --pretty=fuller` shows six commits, all author and committer `Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` returns empty on every commit; the cautionary lesson from the #73 ferry's surprise Claude `Co-Authored-By` does not recur here. The `(#109)` suffix is stripped from every subject.

Body rewrites:
- Commits 1, 2, 3 dropped the trailing `cbor-frame`/`PR #288` parallel-disposition sentence and the "Per kriskowal review on PR #109." line (fork-only refs to `endojs/endo-but-for-bots`).
- Commit 4 body retained the `ocapn/ocapn#104` external reference but translated `'syrup'` → `'syrups'` to match the upstream's plural framing identifier.
- Commit 5 body preserved verbatim (no fork refs; `ocapn/ocapn#104` is the external OCapN repo).
- Commit 6 body translated `makeSyrupWritingSocketOperations`/`makeSyrupWriter`/`makeSyrupReader`/`netlayer-tcp-syrup.test.js` → plural-form identifiers to match the upstream namespace.

Conflicts and resolutions during cherry-pick (the bot side authored against singular `'syrup'`; upstream's prior ferry renamed everything to plural `'syrups'`):
- Commit 3 (drop CHANGELOG.md): modify/delete conflict on `packages/syrup-frame/CHANGELOG.md`. Resolved by `git rm`, matching the bot's intent.
- Commit 4 (invert default): content conflict on `packages/ocapn/src/netlayers/tcp-test-only.js` (singular vs plural throughout JSDoc, default value, comment). Resolved by applying the bot's reordering and JSDoc rewrite in plural form, leaving `framing = 'syrups'` as the new default. Also: the bot edited `.changeset/ocapn-tcp-syrup-framing.md` (singular), which upstream had renamed to `.changeset/ocapn-tcp-syrups-framing.md` (plural). Applied the equivalent prose edit to the plural-named file and deleted the singular file that the cherry-pick had resurrected. The Python-suite test-runner comment was also translated singular → plural.
- Commit 6 (drop async indirection): conflicts on the same file (singular import, singular function name, singular `syrupWriter`/`syrupsWriter` body variable). Resolved by applying the bot's synchronous rewrite of `makeSyrupsWritingSocketOperations`, dropping the `makeSyrupsWriter` import, and keeping the new `textEncoder` constant. `harden` import retained (still used elsewhere in the file).

Source-side cross-link comment on `endojs/endo-but-for-bots#109`, posted under `kriskowal`: https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4494104506. The comment names the new upstream head, the six new SHAs, and the fast-forward shape.

kumavis-approval persistence: `gh pr view 3256 -R endojs/endo --json reviewDecision,reviews` after the push returns `reviewDecision: APPROVED` with the existing `kumavis` `APPROVED` review (id `PRR_kwDODR4qQ87_hIym`, submitted 2026-05-14, state `APPROVED`, commit `ed80869d4fe2b325a13e8bf2639f0422f3fae57c`) preserved. No force-push, no branch protection, no dismissal trigger; the approval carried across the append as expected.

Out-of-scope items per dispatch (untouched): PR #3256 title and body; comments on the upstream PR; the pre-existing `ahead 4 / behind 3` against master; PR #109 itself.

Self-improvement: a ferry whose source branch has been rebased under a rename (singular → plural in this case) needs the boatman to translate identifier-renames inside conflict resolutions and in commit bodies, not only in code; record this in a future `pr-handoff` skill once the second instance appears.
