---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1392
panel_kind: code
provider: anthropic
base_ref: build/sturdyref-ses-accommodation-a10a201
pr_body_hash: d3bb134a4702341440349e8db97a62725384fb51e1828c3a52585163c5222e3e
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: b404d4452d74627e20307b64671d6a1cf43da3b7
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 2ba7df2a5bed
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — endojs/endo-but-for-bots #1392 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `b404d445`

seat verdicts (34): archivist=must-fix assessor=comment benchmarker=pass breaker=must-fix changeset-auditor=must-fix corner-prober=comment coverage-auditor=pass curator=must-fix decomplector=must-fix duality-auditor=comment engine-realist=must-fix fast-checker=comment gateway=comment integrator=comment locksmith=must-fix migrator=comment orthographer=pass packager=comment procurer=comment prover=comment pruner=must-fix purist=must-fix reexport-auditor=pass releaser=comment saboteur=must-fix scribe=comment spec-keeper=must-fix stylist=must-fix surfacer=comment thesaurus=comment transplanter=pass typist=comment warden=pass wire-watcher=comment
must-fix items (20):
- archivist: **should-fix:** `packages/marshal/src/rankOrder.js:244`. The comment says "Identical operands are equal before their ...
- archivist: **comment-only:** `.changeset/pass-style-parcel.md:17`. "comparing a value with itself and checking a singleton do no...
- archivist: **comment-only:** `.changeset/pass-style-parcel.md:21`. "`CopyRecordInterface` now excludes records with a `PASS_STYL...
- archivist: The `"parcel cannot be marshalled"`, `"cannot be used as a collection passable"`, and `"cannot be rank-ordered"` stri...
- archivist: `getRankCover` (`packages/patterns/src/patterns/patternMatchers.js`) does reject `parcel`, as the changeset says.
- archivist: The `Pattern` and `Matcher` changes in `packages/patterns/src/types.ts` match the changeset's "no Error or Parcel at ...
- archivist: The pass-style README's "`PassByRef` excludes it" matches `types.d.ts`.
- archivist: The `new Parcel(location, openHook)` signature in the README table matches `packages/parcel/src/parcel-shim.js:57`.
- archivist: The added comment lines contain no banner rules.
- breaker: **should-fix — the rank-order invariant "a Parcel nested in either cannot escape rank ordering" is false.**
- breaker: `compareRank(harden([1, p]), harden([2, p]))` returns `-1`, because the `copyArray` loop returns at the first non-zer...
- breaker: `compareRank(harden({ a: p }), harden({ b: p }))` returns non-zero, because the `recordNames` comparison decides first.
- breaker: `compareRank(harden([p]), 'x')` returns a number, because `leftStyle !== rightStyle` compares only the style indices.
- breaker: Reject any container that holds a Parcel before ranking it. One option is a `deeplyContainsParcel` precheck in `outer...
- breaker: Or narrow the claim in the comment and the changeset to "only when the comparison reaches the identical Parcel", and ...
- breaker: **comment-only — performance cost of the nested identical-value path.**
- breaker: **comment-only, mitigated — the brand-check gate in `packages/pass-style/src/parcel.js`.**
- breaker: The `checking` flag correctly rejects a reentrant `isParcel` call.
- breaker: A global installed before the shim can still bless its own objects inside its own compartment. The comment documents ...
- breaker: **Sibling family, consistent (no action needed).** Every pass-style `switch` either adds a `'parcel'` arm or rejects ...
