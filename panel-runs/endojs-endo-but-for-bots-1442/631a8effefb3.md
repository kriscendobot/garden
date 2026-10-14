---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1442
panel_kind: code
base_ref: origin/master-356d6e7
pr_body_hash: e5e7e586309dd78b5514c7914a101b4e77b7e7470c0e2ad97158488b2726c513
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: eec274bad823147d61a04facc964f8e198eaac49
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 631a8effefb3
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — endojs/endo-but-for-bots #1442 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `eec274ba`

seat verdicts (33): archivist=must-fix assessor=pass benchmarker=pass breaker=must-fix changeset-auditor=must-fix corner-prober=comment coverage-auditor=comment curator=comment duality-auditor=comment engine-realist=must-fix fast-checker=comment gateway=comment integrator=comment locksmith=pass migrator=must-fix orthographer=pass packager=must-fix procurer=pass prover=must-fix pruner=comment purist=comment reexport-auditor=pass releaser=pass saboteur=pass scribe=comment spec-keeper=comment stylist=must-fix surfacer=pass thesaurus=pass transplanter=comment typist=comment warden=pass wire-watcher=pass
must-fix items (20):
- archivist: **should-fix: an unverifiable engine claim is stated as fact in three places.** The claim is that Chromium's V8 "thro...
- archivist: **should-fix: `cauterizeProperty`'s JSDoc describes only the `.prototype` tolerance.** The block at `packages/ses/src...
- archivist: **comment-only: "matches" overstates the precedent.** `.changeset/frozen-null-pills.md:4-5` says the new tolerance "m...
- archivist: `scripts/git-clean-arguments.mjs` header: `.yarn/*` is ignored with `.yarn/install-state.gz` not excepted, and `node_...
- archivist: `pack-all.mjs` step 1 and step 6 comments match the shared argument array.
- archivist: `_prepare-with-frozen-null-pills.js` header matches the `pillShape` selection logic and the three descriptor shapes.
- archivist: `frozen-null-pill-warnings.test.js` `compareLogs` JSDoc matches its in-order, gaps-allowed behavior.
- archivist: No SES README or docs section documents the existing `prototype` tolerance, so there is no README gap specific to thi...
- breaker: **must-fix: the tolerance also accepts V8's live sloppy-function `arguments`/`caller`, so lockdown now passes when it...
- breaker: `f.arguments` returns the active mapped `arguments` object.
- breaker: `f.caller` returns the calling sloppy function.
- breaker: `function f(cb){return cb()}`: reading `f.arguments` from a strict callback returns the live 2-element arguments object.
- breaker: `g` calling `f`: `f.caller === g` is `true`.
- breaker: Base `origin/master-356d6e7`: lockdown throws `failed to delete intrinsics.Array.isArray.arguments`.
- breaker: This PR: lockdown succeeds. It prints "Tolerating undeletable … `arguments === null`" and "… `caller === null`", ...
- breaker: require the function to be native, checked through the captured `Function.prototype.toString` (`[native code]`);
- breaker: feature-detect the WebView quirk once on a known Web IDL function and tolerate only when it is present;
- breaker: reject functions that also carry an own `prototype`. Sloppy functions always do, but Web IDL constructors may too, so...
- breaker: **should-fix: the negative tests miss the one shape that matters.** `_prepare-with-frozen-null-pills.js` plants pills...
- breaker: **comment-only: the changeset overstates the guarantee.** `.changeset/frozen-null-pills.md` says "Any other value, or...
