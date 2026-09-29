I ran panel round 1 on endojs/endo-but-for-bots#1381, and the verdict is **must-fix**. `panel.sh` exited 0.

**Setup.**
- I used an isolated checkout of `endojs/endo-but-for-bots@design/hardened-text-codecs-shim-status-reconciliation` at head `e26b2dec6b`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the pinned base SHA `7ff30afbce`, which is the frozen `llm-7ff30af`.
- The PR is a design-docs status update: it marks the hardened-text-codecs shim as implemented in two files, `designs/README.md` and `designs/hardened-text-codecs-shim.md`.

**Seat verdicts.**
- **Approve:** critic, decomplector, ergonomist, orthographer, thesaurus.
- **Comment:** skeptic, novice.
- **Request changes:** copyeditor, pedant.

**Must-fix items:**
- The `designs/README.md` totals line uses a Unicode arrow `→`; it should be `->`.
- The copyeditor flagged the `…` in `.toString('utf…')` and the unclear "Before it".

**Should-fix items:**
- The body still says XS lacks the codecs (Design Decision 3 and § Sampling and degradation). That contradicts the new Status section, which cites endojs/endo-but-for-bots#1349 finding that current `xst` defines both codecs.
- The Phase 3 audit count should be 16 call sites, not 17; one of the matched lines is a comment.
- The novice seat noted three reading problems: `llm` and M2 are never explained, "sampling" is used before it is defined, and the Status section refers to test-plan items by number before that list appears.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1381#pullrequestreview-5357542246
- It went up as a **COMMENT**, not a request-changes review. GitHub refuses request-changes on a PR the bot opened itself. The review's header states the verdict is must-fix, and the stage marker below carries it for the gauntlet driver.
- Bare `#N` references are rewritten as fully qualified links (endojs/endo#3322, #3340, #2813, #3245, #3302; endojs/endo-but-for-bots#1349), because the `gh` wrapper refused the first attempt without them.

I made no garden commits.

**Follow-ups:**
- The fix stage gets the items above.
- The decomplector seat reported a likely false positive in the ownership-map check before the panel: it flagged "3 architectural layers" (engine, supervisor, lifecycle), but none of those terms appear in this diff. The layer detection in `ownership-map-signal.sh` may deserve a look.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1381-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (842473 cached reads)
- Output: 5059 tokens
- Cost: $0.7206746000000002
- Wall-clock: 213s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
