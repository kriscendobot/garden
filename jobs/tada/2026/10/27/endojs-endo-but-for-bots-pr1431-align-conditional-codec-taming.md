I revised the design on endojs/endo-but-for-bots PR #1431 so that conditional replacement is now the chosen approach. I pushed it as commit `9076c29984` to the PR head `design/hardened-text-codecs-encapsulation` and updated the PR body to match. The PR is still a draft. The only check I ran was Prettier on the edited file, which passes. No messages arrived in the job inbox.

**What changed in `designs/hardened-text-codecs-shim.md`:**
- **Adopted remedy:** this is now "conditional encapsulation". A host codec constructor is replaced only when it has its own `arguments` property, which is the same test #1349's `tame-text-codecs.js` uses (`getOwnPropertyDescriptor(Host, 'arguments')`). The doc explains why no further check is needed: anything with that property is either a sloppy function or an affected browser-defined constructor, and SES must not admit either one. Unaffected constructors are sampled and frozen directly. I updated the summary at the top, the problem statement, the lockdown steps and the design decisions to match, and added decision 5, "Replace only where necessary", citing naugtur.
- **Rejected alternatives:** replacing every constructor regardless (the earlier draft) is now a rejected alternative, citing naugtur's review comment r4229750056. The reasons given:
  - it breaks constructor identity on Node, xst and Chromium 138+ when nothing there needs fixing;
  - it keeps running after the affected engines are gone;
  - the shared maker doesn't need it.
- **Trade-offs it accepts:** a new section records them:
  - **Identity depends on the engine.** `Host === TextDecoder` after `lockdown()` is false on affected engines and true elsewhere, and each codec is decided on its own.
  - **Tests must plant the affected shape.** No engine in CI ships it natively.
  - **Two code paths.** The taming now has a replaced path and a kept-as-is path.

  The compatibility notes now spell out the engine-dependent identity, and say the prototype's `constructor` is repointed only on the replaced path. The second-copy-of-SES note now says a later copy finds the first copy's replacement and leaves it alone.
- **Test plan:**
  - Item 7 now matches #1349's suites, which plant the shape rather than pinning Chrome 137 and deleting `URL`. The browser spec covers both paths, and the XS runner plants the shape on `TextEncoder` only.
  - Items 8 and 9 now plant the shape.
  - New item 10 checks that unaffected constructors are kept.
- **URL/`URLSearchParams` follow-up:**
  - `URLSearchParams` and `%InitialURL%` take the same test, so their identity also varies by engine and their tests plant the shape.
  - `SharedURL` stays an unconditional replacement, because it exists to drop `createObjectURL` on every engine.
  - The condition lives in each caller, so `encapsulateHostConstructor` carries no policy and serves both kinds of caller.
- **Retirement:** the replacement already stops running where it isn't needed; retiring it only means deleting the code and items 7–9 once SES's oldest supported Chromium is 138 or later.
- **Changeset and guide:** the doc now quotes #1349's `hardened-text-codecs-encapsulated` changeset ("such as Chromium before version 138") and its `packages/ses/docs/guide.md` stand-in note as they are.

**Follow-ups:**
- **#1349's changeset overstates the fix.** It says `lockdown()` now succeeds on affected hosts, but by this design's own analysis it still throws on Chromium before 138, on `URLSearchParams` and `%InitialURL%`, until the follow-up lands. The design now notes that the release notes should say endojs/endo#3369 stays open; #1349's changeset may need the same sentence.
- **#1349's error message may be misleading.** It still says "possibly by a second copy of SES". With the conditional rule, a second copy finds the first copy's replacement and leaves it alone, so it shouldn't trigger that error.
- **Possible overlap with #1425.** I left the doc's dependency on endojs/endo-but-for-bots#1425 alone. #1349's diff adds an `onShimStartCompartment` hook and edits `src-xs/lockdown-shim.js`, so it may already include #1425's change.
- **Review:** the revised draft still needs a design-panel pass.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-align-conditional-codec-taming.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1634728 cached reads)
- Output: 18307 tokens
- Cost: $1.4073336
- Wall-clock: 214s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
