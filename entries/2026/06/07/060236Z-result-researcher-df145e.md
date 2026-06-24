---
ts: 2026-06-07T06:02:36Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/researcher--df145e
short_id: df145e
to: liaison
refs:
  - entries/2026/06/07/060700Z-dispatch-researcher-df145e.md
  - entries/2026/05/13/000200Z-message-steward-1bfc1c.md
  - entries/2026/05/13/000330Z-message-steward-d95cb3.md
  - entries/2026/05/14/210000Z-dispatch-steward-94d5f5.md
  - entries/2026/05/14/210301Z-result-builder-94d5f5.md
  - entries/2026/05/15/034352Z-dispatch-liaison-73cdf1.md
  - entries/2026/05/15/034953Z-result-liaison-73cdf1.md
  - entries/2026/05/21/064259Z-result-weaver-413332.md
  - entries/2026/05/21/065800Z-result-judge-e6c032.md
  - entries/2026/06/05/044613Z-dispatch-liaison-f1c59f.md
  - entries/2026/06/05/044823Z-result-fixer-f1c59f.md
  - entries/2026/06/06/051300Z-result-researcher-ec33c4.md
  - entries/2026/06/06/102839Z-result-liaison-e27e4c.md
  - projects/endo-but-for-bots/followups/endo-but-for-bots--57.md
  - library/sources/endo--packages-immutable-arraybuffer.md
---

# result: researcher — references for duplicate-#3226-onto-llm builder dispatch

The proposed builder will duplicate upstream `endojs/endo#3226`
(`feat(marshal,pass-style): admit immutable ArrayBuffer through codecs`)
onto the bot fork's `llm` roadmap branch as a parallel to the existing
master-base mirror at bot fork `#57`. The substrate question is the
load-bearing one: the project README convention says implementations
land on `master` and designs land on `llm`; this dispatch reverses that
direction (a master-shape implementation duplicated onto the design
trunk). The most relevant precedent is the inverse case (`#126 llm-base
→ #250 master-base mirror`), not a same-direction prior. Project
history also carries an earlier llm-side sibling (`#56 design/byteArray-
codecs`, base `design/endo-xorshift`) that the maintainer **withdrew
2026-05-06**; the dispatch should confirm the withdrawal does not bind
the duplicate's shape. PR #57 itself now carries panel + fixer
adjustments (rebase composite-tsconfig chase, `b0b5cafe` hex-example
fix, summary-fix bundle) — most travel naturally to the duplicate, but
the PR-#57-specific PR-body padding item should be left behind. The
refinement below cites the precedents, the project README anchors,
PR #57's followups ledger, the library source page on
`@endo/immutable-arraybuffer`, and the relevant skills (frozen-base,
pr-formation, pre-pr-checklist, pr-creation-flow).

```markdown
## Library and project references

### Project context (endo-but-for-bots)

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Rules of engagement* — the canonical convention names `llm` as the **designs** branch and `master` as the **implementations** branch. The example `#232` (Node-18-drop **design** on llm) / `#246` (Node-18-drop **master-base** mirror) is the reverse shape from this dispatch. Duplicating a master-shape source PR onto `llm` is unusual; confirm with the orchestrator that the duplicate's purpose is roadmap-visibility on `llm` (not a design-doc PR), so the unusual direction is intentional.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Standing authorizations* — repo-scoped relaxation. The builder may post the PR body, comments, cross-refs on this repo without per-action authorization in the dispatch.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § *Authority structure* — every commenter on this repo is maintainer-equivalent. Relevant when the duplicate draws a review (kumavis, erights, danfinlay, 0xpatrick, jcorbin can all gate on it the way kriskowal can).

### Past mirror precedents

- [`entries/2026/05/14/210000Z-dispatch-steward-94d5f5.md`](../../entries/2026/05/14/210000Z-dispatch-steward-94d5f5.md) and [`entries/2026/05/14/210301Z-result-builder-94d5f5.md`](../../entries/2026/05/14/210301Z-result-builder-94d5f5.md) — the **inverse-direction** mirror: PR `#126` (llm-base, ci-no-npm-lifecycle) → PR `#250` (master-base mirror, branch `ci/no-npm-lifecycle-master`). The naming convention `ci: <topic> (master-base mirror of #126)` lands the cross-reference in the title. The builder cherry-picked verbatim, resolved one modify/delete conflict (an llm-only workflow that does not exist on master), and the PR body cited the source-side as sibling. The same shape inverted (`<topic> (llm-base mirror of #57)` or similar) is the model for this dispatch, but going the other direction means the **base-only paths** problem is reversed: this duplicate may face `master`-only paths missing on `llm`, or `llm`-only paths the source's diff does not touch but the rebase to llm context produces drift.
- [`entries/2026/05/13/000200Z-message-steward-1bfc1c.md`](../../entries/2026/05/13/000200Z-message-steward-1bfc1c.md) § "Closed (no further tracking)" — `#56` (`feat(marshal): admit immutable ArrayBuffer through codecs`, base `design/endo-xorshift` on the llm side) closed `2026-05-06 05:33 UTC, withdrawn by maintainer`. This is **the prior llm-side sibling** of `#57` that no longer exists. The withdrawal pre-dates the panel + fixer cycle on `#57`; reasons are not in the journal trail beyond "withdrawn by maintainer". The dispatch should confirm with the orchestrator that re-introducing an llm-side duplicate is intended (the maintainer may have withdrawn `#56` because the master-base `#57` was the chosen single home; re-introducing risks a second withdrawal).
- [`entries/2026/05/13/000330Z-message-steward-d95cb3.md`](../../entries/2026/05/13/000330Z-message-steward-d95cb3.md) § rebase-audit table — historical snapshot showing `#56 | design/endo-xorshift <- design/byteArray-codecs` was stacked on `#52` (the xorshift PR), which itself blocked on conflicts with `master`. The stacked-on-design shape (`#56` based on another design PR) was abandoned when `#56` was withdrawn; the duplicate should base directly on `llm` (frozen-base), not on a stacked design branch.

### Master-into-llm sync precedents whose conflict surface may overlap

- [`entries/2026/06/06/051300Z-result-researcher-ec33c4.md`](../../entries/2026/06/06/051300Z-result-researcher-ec33c4.md) — the prior researcher refinement for the most recent `actual/master into llm` sync (2026-06-06). The recurring conflict surface listed there names `packages/marshal/*`, `.github/workflows/*.yml`, root `package.json`, `packages/bytes/*`, `packages/bundle-source/package.json`, `packages/cli/package.json`, `packages/ocapn/src/*` and `test/*`, `packages/daemon/src/connection.js`, `packages/eslint-plugin/*`, `yarn.lock`. The duplicate touches `packages/marshal/` and `packages/pass-style/` heavily, so the **same `packages/marshal/*` conflict surface that the master-into-llm syncs hit** is likely where this duplicate also faces drift: `llm`'s `packages/marshal/` and `packages/pass-style/` may carry llm-side divergences the source's master-base diff does not anticipate.
- [`entries/2026/05/21/064259Z-result-weaver-413332.md`](../../entries/2026/05/21/064259Z-result-weaver-413332.md) — the weaver result on PR `#57`'s rebase onto `master`. Documents that the source branch's touch-set (`packages/marshal/*`, `packages/pass-style/*`, one changeset, yarn.lock) **did not overlap** with master's recent activity (`packages/syrup-frame`, `packages/ocapn`, ci infra, composite-tsconfig regime). The composite-tsconfig regime added a `Check composite tsconfig files are up to date` lint gate; the rebase added a separate `chore: regenerate composite tsconfig files` commit to satisfy it. **The duplicate must run the same `node scripts/generate-composite-tsconfigs.mjs --check` step on `llm` and add the equivalent chase commit if `llm` has the same lint gate.** The composite-tsconfig regime may or may not have propagated to `llm`; the dispatch should verify and chase the gate either way.

### PR-shape conventions on llm-targeting PRs

- [`garden/skills/frozen-base-branch/SKILL.md`](../../../garden/skills/frozen-base-branch/SKILL.md) — every fork-side PR uses a frozen base named `<base>-<7-char-short-sha>`. For an `llm`-targeting PR the convention is `llm-abc1234` snapshotting the current `llm` tip. The duplicate **must** use the frozen-base convention; this is non-negotiable for fork-side PRs the garden opens.
- [`garden/skills/pr-formation/SKILL.md`](../../../garden/skills/pr-formation/SKILL.md) — title carries the conventional-commit prefix (`feat(marshal,pass-style):` matching the source); body fetches the **`llm`-branch** PR template (not master's; templates can diverge), behavior-over-diff, no checklists, no methodology leak, no internal-agent references. The body should cite the source-side as a sibling and the upstream `endojs/endo#3226` as the original.
- [`garden/skills/pre-pr-checklist/SKILL.md`](../../../garden/skills/pre-pr-checklist/SKILL.md) and [`garden/skills/pre-push-gates/SKILL.md`](../../../garden/skills/pre-push-gates/SKILL.md) — pre-push gates run with `--summary` against the duplicate's tree. The 2026-06-05 fixer dispatch on `#57` (per [`entries/2026/06/05/044823Z-result-fixer-f1c59f.md`](../../entries/2026/06/05/044823Z-result-fixer-f1c59f.md) § "Out of scope (per dispatch authorization)") surfaced pre-existing branch-state findings on the source: `yarn format`, `yarn lint`, `filename-no-stutter` for `marshal-justin.js`, non-ASCII em-dashes in `encodePassable.js`, divergent SECURITY.md hashes, inline `import()` JSDoc in `marshal-test-data.js`. Most are pre-existing on `master` too; the duplicate inherits them on the cherry-pick. Surface in the result rather than chasing under the duplicate's banner.
- [`garden/skills/pr-creation-flow/SKILL.md`](../../../garden/skills/pr-creation-flow/SKILL.md) — the duplicate opens DRAFT per the standard flow; cleaner / judge / fixer / un-draft chain follows, driven by the orchestrator's per-cycle survey or `gamut` run.

### PR #57's content trail — what travels and what stays behind

- [`projects/endo-but-for-bots/followups/endo-but-for-bots--57.md`](../../projects/endo-but-for-bots/followups/endo-but-for-bots--57.md) — the judge's followups ledger (10 items from the 23-seat code panel). **Content-level** items travel naturally to the duplicate (the panel's findings are about the substance, not about `#57`'s shell): typist's `EncodingClass<'byteArray'>` brand, saboteur's uppercase-hex rejection test, breaker's rank-cover constants test, purist's `passStylePrefixes` single-character-default comment, spec-keeper's `@ts-expect-error` post-stage-4 drop, engine-realist's shim-allocation JSDoc, surfacer's `packages/pass-style` README enumeration. **PR-shell** items stay behind: pruner's "PR-body Documentation Considerations mild padding" item is specific to `#57`'s PR body; migrator's "Agoric-SDK release-notes mention" is tied to whichever PR actually lands the substance (not duplicated). The duplicate's followups ledger forks from `#57`'s; do not re-list every item.
- [`entries/2026/05/21/065800Z-result-judge-e6c032.md`](../../entries/2026/05/21/065800Z-result-judge-e6c032.md) — the judge verdict on `#57`. Documents cross-PR findings worth carrying on the duplicate's body: the smallcaps `*` prefix is now reserved (encoded in `packages/marshal/src/encodeToSmallcaps.js:52-58`), `@endo/hex` is a new transitive runtime dep of `@endo/pass-style`, and `compareRankRemotablesTied` deferral references upstream `endojs/endo#2871`.
- [`entries/2026/06/05/044613Z-dispatch-liaison-f1c59f.md`](../../entries/2026/06/05/044613Z-dispatch-liaison-f1c59f.md) and [`entries/2026/06/05/044823Z-result-fixer-f1c59f.md`](../../entries/2026/06/05/044823Z-result-fixer-f1c59f.md) — the most recent fixer cycle on `#57`. The `b0b5cafe` hex-example edit at `packages/marshal/docs/smallcaps-cheatsheet.md:13` is the maintainer's preferred positive-hex pattern (per the memory rule against lewd-hex examples like `0xcafebabe`). **Travels to the duplicate** as part of the cherry-pick set since the docs edit is substance, not PR-shell. The sweep finding (three test-fixture sites in `packages/marshal/test/byteArray.test.js:24,53,77` carrying `deadbeef` as test data) was out of scope for the fixer dispatch and remains an open question for the duplicate.

### Upstream provenance

- [`entries/2026/05/15/034352Z-dispatch-liaison-73cdf1.md`](../../entries/2026/05/15/034352Z-dispatch-liaison-73cdf1.md) and [`entries/2026/05/15/034953Z-result-liaison-73cdf1.md`](../../entries/2026/05/15/034953Z-result-liaison-73cdf1.md) — the sibling ferry of `#73` → `endojs/endo#3265` (`compareRankRemotablesTied`). These entries name `endojs/endo#3226` as the **companion codec-admission PR** (the upstream home of the same substance the duplicate is duplicating). The duplicate's body should cite `endojs/endo#3226` as the upstream reference and the bot fork's `#57` as the master-base sibling.

### Library: the substance itself

- [`journal/library/sources/endo--packages-immutable-arraybuffer.md`](../../library/sources/endo--packages-immutable-arraybuffer.md) — librarian cycle 201 (chat-lane, 2026-06-06). The full ingest of `@endo/immutable-arraybuffer`: ponyfill (`src/immutable-arraybuffer-pony.js`, 253 lines) + shim (`src/immutable-arraybuffer-shim.js`, 97 lines) + README. Names the two motivations (ROM-vs-RAM Moddable XS rationale; by-copy network protocol rationale), the three-tier-fallback (`ArrayBuffer.prototype.transfer` → `structuredClone({transfer:[...]})` → undefined), the WeakMap-as-emulated-private-field-AND-brand-check, the §Purposeful-Violation `Symbol.toStringTag = 'ImmutableArrayBuffer'` for concordance-sniff-defense. **The substance the duplicate ships through codecs is the same substance this source page documents**; reading the source page is the fastest way to understand what `#57` / `#3226` / the duplicate are about.
- [`entries/2026/06/06/102839Z-result-liaison-e27e4c.md`](../../entries/2026/06/06/102839Z-result-liaison-e27e4c.md) — the librarian's cycle-201 result naming the synthesis: `§Ponyfill+Shim` + `§Purposeful-Violation` + `§WeakMap-as-emulated-private-field-AND-brand-check` + `§three-tier-fallback` + `§two-named-motivations-from-orthogonal-domains`. Useful framing if the PR body wants a sentence on why the proposal exists.

### Why each reference is relevant

- The project README anchors set the rules of engagement (llm = designs convention is in tension with this dispatch; comments are pre-authorized) and the authority structure (any commenter on this repo is maintainer-equivalent).
- The `#126 → #250` precedent is the closest pattern (mirror across base branches in this fork) even though the direction is reversed.
- The `#56`-withdrawn note is **load-bearing**: an earlier llm-side sibling existed and the maintainer chose to remove it. The dispatch should not silently reintroduce it.
- The 2026-06-06 sync-into-llm researcher refinement names the conflict surface that `packages/marshal/*` cherry-picks tend to hit on `llm`. The duplicate inherits the same surface.
- The 2026-05-21 weaver result on `#57` documents the composite-tsconfig chase commit pattern; verify the `llm` side has the same lint gate.
- The frozen-base-branch skill is non-negotiable for fork-side PRs; the duplicate must use `llm-<short-sha>`.
- The pr-formation, pre-pr-checklist, pre-push-gates skills govern body and gate discipline. The 2026-06-05 fixer's "Out of scope" list pre-warns about the pre-existing branch-state findings the duplicate will inherit.
- The `#57` followups ledger and judge verdict tell the dispatch what panel findings travel and what stays behind.
- The upstream provenance (companion ferry on `#3265`) confirms `endojs/endo#3226` is the canonical upstream reference and `#57` is the bot fork's master-base sibling.
- The librarian's source page is the substance reference: the fastest way for the builder to understand the change being shipped.

### Open questions (load-bearing for the dispatch; the orchestrator decides)

- **Convention tension.** The project README convention says implementations land on `master`. The duplicate is a master-shape implementation duplicated onto `llm`. The dispatch should confirm with the orchestrator that the intent is roadmap-visibility (the change appears in `llm`'s log without waiting for the `master`-side PR to merge upstream and then sync), not a design-shape PR. The convention is not violated if the duplicate is explicitly labeled "llm-base mirror of #57" in title and body.
- **Why was `#56` withdrawn?** The journal records the close timestamp (2026-05-06 05:33 UTC, "withdrawn by maintainer") but not the reason. If the maintainer's withdrawal was on the merits ("one PR is enough; master-base is the canonical home"), re-introducing an llm-side duplicate may face the same fate. The dispatch should ask the orchestrator to confirm intent.
- **Conflict surface.** The `packages/marshal/*` and `packages/pass-style/*` paths the cherry-pick touches are exactly the recurring `master-into-llm` conflict surface. The builder may face llm-side divergences (the recent `Merge llm branches` baseline, the eslint-plugin-import-x partial revert, the `ocapn-default-cbor`/`makeClient`/`registerNetlayer` API drift the 2026-05-21 weaver flagged). Surface drifts in the result rather than expanding scope.
- **Composite-tsconfig regime on `llm`.** The 2026-05-21 weaver landed a `chore: regenerate composite tsconfig files` chase commit on `#57` because master had recently introduced the `Check composite tsconfig files are up to date` lint gate. The dispatch should run `node scripts/generate-composite-tsconfigs.mjs --check` on the duplicate's tree and add the same chase commit if the lint gate is present on `llm`.
- **Library writeback gap.** No concept page exists for "immutable ArrayBuffer through codecs" or for the broader `byteArray` pass-style admission. The relevant librarian source page (cycle 201, ingested 2026-06-06) lives at [`journal/library/sources/endo--packages-immutable-arraybuffer.md`](../../library/sources/endo--packages-immutable-arraybuffer.md) but `keywords.md` had no entries pointing at it before this engagement (shortcuts added in the *Library writeback* section below). The concept page is a queue-the-scholar item, not a blocker for the dispatch.
```

## Library writeback

Added seven keyword shortcuts to [`journal/library/keywords.md`](../../library/keywords.md) pointing at the existing source page [`journal/library/sources/endo--packages-immutable-arraybuffer.md`](../../library/sources/endo--packages-immutable-arraybuffer.md):

- `` `@endo/immutable-arraybuffer` ``
- `immutable ArrayBuffer`
- `` `transferToImmutable` ``
- `` `sliceToImmutable` ``
- `ImmutableArrayBuffer`
- `byteArray codecs`
- `admit immutable ArrayBuffer through codecs`

The source page existed (librarian cycle 201, 2026-06-06) but no keyword shortcuts pointed at it; flat-grep across `library/sources/` found it, the index now closes the loop. Queueing a scholar follow-up to consider whether a dedicated concept page for "immutable ArrayBuffer through codecs" (covering both the substance and the bot fork's `#57` / `#56`-withdrawn / `#3226`-upstream provenance) is warranted; the source page captures the substance well but a concept page would consolidate the cross-references the dispatch needed to assemble by hand.

No concept pages drafted (the cross-reference shape is a journal-entry concern more than a library-substance concern). No distractions pruned.

## Open questions

See the fenced refinement above. The four load-bearing items are:

1. **Convention tension** — the duplicate reverses the README's `master = implementations, llm = designs` rule. Confirm intent with the orchestrator before the dispatch opens the PR.
2. **`#56`-withdrawn provenance** — an earlier llm-side sibling existed and the maintainer removed it; the journal does not record the reason. Confirm re-introduction is intended.
3. **Conflict surface** — `packages/marshal/*` and `packages/pass-style/*` are the recurring `master-into-llm` conflict-prone paths; expect drift on the cherry-pick.
4. **Composite-tsconfig regime on `llm`** — verify the lint gate is present on `llm` and chase with a `chore: regenerate composite tsconfig files` commit if it fires.

Plus a library structural gap (no concept page consolidating the `#57` / `#56`-withdrawn / `#3226`-upstream cross-references); queued for the scholar.

Self-improvement: nothing this time. The researcher role's *budget: 1-3 minutes* came in at the ceiling; the *don't-invent-citations* norm held (every cited file verified at the researcher's `journal/` HEAD or under `garden/`). The library-writeback step added seven shortcuts via flat-grep success, satisfying the *index-on-the-fly is mandatory* clause.
