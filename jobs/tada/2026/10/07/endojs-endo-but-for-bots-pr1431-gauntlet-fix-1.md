# Gauntlet FIX round 1: endojs/endo-but-for-bots PR #1431

I applied the panel-1 must-fix items to `designs/hardened-text-codecs-shim.md` and pushed them to the PR head. CI is green: `ci-wait-merge.sh` returned rc 0, with all 28 checks terminal and none failed.

**What I did**
- Read the latest panel review (5449402740). Skeptic, decomplector, copyeditor, pedant and novice asked for changes; critic and ergonomist left comments; orthographer and thesaurus approved.
- Read the implementation PR #1349 (`tame-text-codecs.js`, the `lockdown.js` and `src-xs/compartment.js` hooks, and its test) so the design describes what was actually built.
- Pushed one follow-up commit with `safe-push-pr-head.sh` in advance mode: `45c49139f2 → 324dc3dc42`.

**What changed in the design**
- **Must-fix (skeptic):** Test item 7 now says how "unreachable" is checked. It is a transitive walk over every permitted intrinsic and compartment global (string and symbol keys, `value`/`get`/`set`, and each `[[Prototype]]` link), not a single `.constructor` check. The design also states that the walk cannot see host closures, and that the host constructor's own `prototype` link points one way only.
- **New test items:**
  - Item 8 applies the taming twice (the SES-for-XS order) and checks the second pass changes nothing.
  - Item 9 covers subclassing, constructors captured before lockdown (`instanceof` both ways, identity broken), and instances created before lockdown.
- **Decomplector:**
  - `URL` and `URLSearchParams` are named as other affected WebIDL constructors, deferred to follow-up work under the general rule.
  - A new paragraph explains why the design replaces the global binding instead of returning through `addIntrinsics`: XS calls `getGlobalIntrinsics` when the module loads, and universal names are read from the global.
- **Critic and skeptic should-fixes:**
  - Compatibility considerations gained four bullets: constructor identity changes, the shared prototype's `constructor` is repointed, the replacement is a different function object (`toString` / `[native code]` detection), and Node `util` aliases.
  - The rejection of tolerating the descriptor now also covers the narrower allowlist version.
  - The WeakSet that makes the taming idempotent is described.
  - The unmeasured Chromium versions are stated as an extrapolation.
  - The retirement trigger is "oldest supported Chromium ≥ 138".
- **Copyeditor, pedant, novice, ergonomist:**
  - Status cell is now just `Revised`.
  - Added a short primer on the permits, a numbered list for the failure chain, a bulleted remedy with a code sketch, and the `Reflect.construct` grammar fix.
  - No em-dashes remain in the new text, and Prettier passes.

**Follow-ups**
- The PR #1349 test checks reachability only through `.constructor`. It does not yet do the transitive walk the design now requires for item 7, nor items 8 and 9. Its code comments also still say "before roughly Chrome 127". That PR's own review should bring it in line with the design.
- #1349's diff also removes `tameUrlConstructor` from `lockdown.js`. That may be a base-drift artifact; it is worth checking when #1349 is reviewed.
- I left one should-fix alone: the mixed title-case and sentence-case headings were already in the file before this PR.
- Panel round 2 has not run; the driver re-posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1050561 cached reads)
- Output: 11007 tokens
- Cost: $0.9965002000000001
- Wall-clock: 933s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
