## Completion report: endojs/endo-but-for-bots#1583, fix panel findings

I fixed the panel findings on PR #1583 and pushed one commit, `a08c4505c0`, to the head branch `design/hardened-text-codecs-shim-supersession`. The change is documentation only, in two files. On the new head the pre-push gates passed all 12 stages and CI shows 7 checks passing, 24 skipped and none failing.

**What changed**

- **Main finding: upstream fix vs. `llm` (skeptic 1).** I checked the claim directly:
  - Commit `679d9afaa4` (endojs/endo#3376) is on endojs/endo `master`, but `git merge-base --is-ancestor` shows it is not part of `llm` at `9a14ddf660`.
  - `cauterize-property.js` on `llm` has no `null` tolerance.
  - § Status now says the fix has not yet reached `llm`. On `llm`, the codec permits still make `lockdown()` throw on the affected Chromium versions until the next upstream merge. That sync is now a listed remaining item.
- **Chromium version list (skeptic 3, archivist 1).** It now cites where the list came from: the measurements in closed #1349 (shape on 120, 126, 127, 133, 136 and 137; absent on 138–140; nothing before 120 tested). It also quotes the #3376 commit message ("V8 through at least 133") and notes that the shape appears on Web IDL functions in general.
- **How the PRs relate (skeptic 4, critic 3, decomplector 1, novice 2, ergonomist 2).** A three-part list now replaces the prose:
  - **Superseded:** the codec-specific encapsulation in #1349 and endojs/endo#3377.
  - **Still wanted, no owner:** the XS smoke coverage. The doc says outright that no open PR carries it.
  - **Owned elsewhere:** the XS lockdown-Compartment repair, owned by open draft #1425. The XS smoke follow-up must land after or together with #1425.
- **Phase 3 audit snapshot (skeptic 2).** I re-ran it at `9a14ddf660`: 22 matching lines in 13 files, all Node-host code.
- **Wording and status cells.** The doc header and the README row now both read `**Implemented** (Phases 1-2); XS smoke test unmerged`.
  - The README note says "Phases 1-2" instead of "core", and drops the term "frozen-null-pill".
  - There is now a short explanation of why a frozen `caller`/`arguments` property breaks `lockdown()` and what `cauterizeProperty` does.
  - Ambiguous antecedents are fixed.
  - Test plan item 6 is now specification only (the history moved to § Status) and spells out the once-per-realm reasoning.
  - The bare `#1349` references are qualified.
- **Design Decisions (critic 2).** I re-read them; none assumes the encapsulation, so I left them unchanged.
- **PR description and reply.** I updated the PR description to state the not-yet-on-`llm` status, with fully qualified references. I posted a reply going through each finding: https://github.com/endojs/endo-but-for-bots/pull/1583#issuecomment-6526611630

**Verification notes**

- The typist auto-fix in the gates also rewrote two older lines of `designs/README.md` that this PR doesn't touch (an ellipsis and a curly apostrophe). I reverted those so the diff stays in scope.
- The gh wrapper refused my first PR comment because it used bare numbers that GitHub would link to the wrong repo. I qualified every reference and reposted.

**Follow-ups**

- Nobody owns the XS smoke-test work yet. It needs a builder job or PR that takes only the XS assertions from #1349 and depends on #1425. I did not post one.
- Once the next upstream merge brings endojs/endo#3376 into `llm`, the line saying it has not reached `llm` will need updating.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `82de63bdb4f65cbff15c83f6177274b5274789b5`; this job presented `a08c4505c09e66f6f7df31ac5df392b4be5db9d5`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1583-fix-panel-findings-20261030.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2191374 cached reads)
- Output: 13195 tokens
- Cost: $1.4350547999999999
- Wall-clock: 1066s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
