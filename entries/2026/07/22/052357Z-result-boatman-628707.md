---
ts: 2026-07-22T05:23:57Z
kind: result
role: boatman
project: endo
repo: endojs/endo
worktree: dispatches/boatman--3e5c85/project
refs:
  - entries/2026/07/22/051844Z-dispatch-boatman-3e5c85.md
---

Re-ferried `endojs/endo-but-for-bots#259` (source branch `feat/hardened-text-codecs-shim`, head `42eb1b61a`) to `endojs/endo#3322` (branch `kriskowal-hardened-text-codecs-shim`).

**Shape used: Shape 2 (recompute-from-master, force-push).** The prior upstream head `2587b0f8c` was not an ancestor of the source's new shape: the source had rebased onto a new frozen base and added a revert of the "tolerate undeletable arguments/caller" fix plus a new "drop redundant globalThis global directive" fix, so a fast-forward append (Shape 3) was structurally impossible.

**Commit collapse.** The source's fix commit (`0b7ab7590`) and its revert (`fa2c5d023`) net to an identical tree (`3eba7b354...` both sides), confirmed by direct tree-hash comparison before deciding. Collapsed the 5-commit source series to 3 commits (feat / test / drop-redundant-globalThis), dropping the fix+revert pair. Verified the net diff of the 3-commit recompute against current master matches the net diff of the full 5-commit source series against its base byte-for-byte (diff of diffs, ignoring blob index lines which differ only due to unrelated upstream master drift) — identical.

**Per-commit attribution and trailers**, `origin/master..HEAD` (base `50b73686c`):

| commit | subject | author | committer | trailers |
|---|---|---|---|---|
| `eeefaa010` | feat(ses): permit TextEncoder and TextDecoder as universal intrinsics | Kris Kowal \<kriskowal@kriskowal.com\> | Kris Kowal \<kriskowal@kriskowal.com\> | none |
| `0174f4e61` | test(ses): cover ignoreBOM, @@toStringTag, constructor reverse-link, [[Proto]] | Kris Kowal \<kriskowal@kriskowal.com\> | Kris Kowal \<kriskowal@kriskowal.com\> | none |
| `7d434b939` | fix(ses): drop redundant globalThis global directive | Kris Kowal \<kriskowal@kriskowal.com\> | Kris Kowal \<kriskowal@kriskowal.com\> | none |

No fork-side `(#N)` subject suffixes on any of the three (source subjects were already clean). No `Co-Authored-By` or generator trailers on any source commit body, so nothing to strip.

**Push.** `git push --force-with-lease=kriskowal-hardened-text-codecs-shim:2587b0f8cb19497368d513d30f67e791898a1ac1 origin HEAD:kriskowal-hardened-text-codecs-shim` succeeded: `2587b0f8c...7d434b939 HEAD -> kriskowal-hardened-text-codecs-shim (forced update)`.

**Upstream branch head after push:** `7d434b9393776694ba8b4af3033a5761d8a5598f`.

**Post-push approval state:** `reviewDecision: APPROVED`, unchanged by the force-push. Four reviews on record, all still anchored to the old commit oid `2587b0f8c` (gibson042 APPROVED; kriskowal, erights, kriskowal COMMENTED) — `endojs/endo`'s branch protection does not have `dismiss_stale_reviews` set for this branch, so the approval persisted through the force-push rather than being dismissed.

**CI status at report time:** fresh run just kicked off post-push; `build` and `zizmor` pass, everything else (`browser-tests`, `cover`, `lint`, `test` matrix, `test-hermes`, `test262` matrix, `test-xs`, `test-ocapn-python`, `viable-release`) still `pending`. Not waited out; that is the shepherd's job per the standing scope boundary.

**Garden-side cross-link comment:** edited comment id `4977431934` on `endojs/endo-but-for-bots#259` in place, body now `Mirror of https://github.com/endojs/endo/pull/3322 (head 7d434b939).` No comment posted on the upstream PR (2026-05-29 directive).

**Title/body:** left unchanged per dispatch instruction, with one flag for the orchestrator: the existing PR body's "Testing Considerations" section contains a paragraph describing "A third commit [that] fixes a Chromium-only lockdown failure" (the tolerate-undeletable-arguments/caller fix). That commit is no longer part of the series — it was collapsed out with its revert during this recompute, per the dispatch's explicit shape diagnosis. The paragraph is now inaccurate: it promises a fix that is not present in the diff. The dispatch prompt scoped only the *title* question ("it did not [become materially misleading] — it's still the same feature") and did not ask about the body; per `pr-handoff` § Scope boundary ("when in doubt, leave... and surface the question"), I left the body as-is rather than editing outside my authorized scope, but this paragraph should be removed or corrected on a follow-up pass. Title itself (`feat(ses): permit TextEncoder and TextDecoder as universal intrinsics`) remains accurate.

Self-improvement: nothing this time. The tree-hash-diff net-invariant check (compare `diff --no-color | grep -v '^index '` between source range and recomputed range) worked cleanly as a byte-for-byte verification technique for a commit-collapsing re-ferry; this is already the discipline the dispatch prompt asked for, not a new lesson.
