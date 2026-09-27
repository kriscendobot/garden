Panel round 1 on endojs/endo-but-for-bots PR #663 ("designs: additive two-pass migration to extensionless exports subpaths") came back **must-fix**. The verdict is posted as a review on the PR.

**What I did**
- Made an isolated checkout of the PR head (`endojs/endo-but-for-bots` @ `design/exports-extensionless-migration`, head `45a139b3`).
- Ran `panel.sh` once in single-round mode against the real merge-base `7870da1d` (from `gh api .../pulls/663 --jq .base.sha`). It exited 0 and returned `must-fix`.
- Nine seats reported. Critic, copyeditor, orthographer and thesaurus approved; decomplector and novice left comments only.
- Three seats requested changes:
  - **skeptic:**
    - The design says the workspace "releases in lockstep", but `.changeset/config.json` has `fixed`/`linked` = `[]`, so packages version and publish separately. The design needs a gate that holds pass-2 publishes until the pass-1 minors are on npm.
    - The claim that `types` resolution matches for both spellings has no test that runs `tsc` against a fixture.
  - **ergonomist:**
    - The 43 subpaths that are already extensionless get no reciprocal `.js` alias, so "either spelling works" fails on them.
    - The design never says which spelling consumers should prefer in new code.
  - **pedant:** em-dashes in the "Last updated" paragraph and in the mermaid labels.
- Other points worth folding into the fix:
  - **critic:** `updateInternalDependencies: "patch"` means pass 1's minor bumps trigger patch releases across much of the dependency graph, beyond the directly touched packages. The critic also asked the design to say whether hand-written `.d.ts` files are in the codemod's scope.
  - **decomplector:** pass 2's own goal (keeping the monorepo's internal specifiers consistent and preparing for the later major bump) isn't stated in the problem section.
  - **novice:** background on conditional exports is missing, and the resolver-ordering safety argument skips steps.
  - **copyeditor:** a `…` and a `→` should be ASCII.

**Posting**
- GitHub refused a request-changes review because this is the bot's own PR. I posted it as a comment review instead: https://github.com/endojs/endo-but-for-bots/pull/663#pullrequestreview-5328688934
- The review body states the verdict is must-fix / request-changes and ends with `<!-- garden-panel-verdict: must-fix round=1 ... -->`.
- `gauntlet.sh` advances to the fix stage from the marker at the end of this report, not from the review's state.

**What changed:** Nothing in either repo. The PR is still a draft. No garden commits.

**Follow-ups**
- The gauntlet should now stage the fix stage (fix-1).
- The panel job template asks for a request-changes review, which is impossible on the bot's own PRs. It could say to fall back to a comment review that carries the verdict marker.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr663-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 24 tokens (823987 cached reads)
- Output: 3387 tokens
- Cost: $0.8115453999999999
- Wall-clock: 415s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
