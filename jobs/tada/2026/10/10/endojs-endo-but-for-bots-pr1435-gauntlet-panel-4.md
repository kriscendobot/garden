Round 4 of the panel review on PR #1435 returned **must-fix**, and I posted the result to the PR as a review comment.

**What I did**
- Ran the panel in single-round mode on the PR head `9867b28114` (branch `design/moddable-10-0-0-ironhorse-port-plan` on endojs/endo-but-for-bots), compared against the frozen base `7d2eb307a2`. It exited with code 0 and every seat ran without error.
- Posted the aggregate as review https://github.com/endojs/endo-but-for-bots/pull/1435#pullrequestreview-5478759885, headed "Panel review — round 4 (single-round gauntlet stage): **must-fix**". GitHub would not accept a request-changes review because the bot opened this PR, so it went up as a comment review. That is the same form rounds 1–3 used.

**Verdicts**
- **Request changes:** critic, skeptic and pedant.
- **Comment only:** decomplector, ergonomist and novice.
- **Approve:** copyeditor, orthographer and thesaurus.

**Main findings for the fix stage**
- **Skeptic (must-fix):** rows R14, R15 and R16 are marked already-conformant, but they cite only test262 trees that already pass, not specific probes. Each needs a concrete probe taken from the XS 10.0.0 changes, or the row should be downgraded to unverified.
- **Critic:**
  - The rationale for moving the oracle pin last ignores that the ratchet process already blocks promotion. The plan should also consider an early pass that reports drift without promoting anything.
  - Child 3's probes for R08 and R13 race with child 1's fix for revoked proxies, so they could use up child 3's two-failure limit before child 1 lands.
  - Child 6 has no stop rule if drift turns out to be large.
  - R22's classification as `needs-port` doesn't fit the plan's own definition.
- **Skeptic (other):**
  - The R02 scope-slot rule assumes IronHorse reserves slots the same way XS does, which the plan doesn't show.
  - The child-6 gate relies on script flags and a re-run naming scheme that aren't verified (`--adopt-go-ahead`, re-running under the same name).
  - The plan should say R17–R21 and R24 need re-checking once resizable buffers land.
  - The R16 oracle check compares output only, so it is not evidence of memory safety.
- **Pedant:** an em-dash in the new `designs/README.md` table row, and `«`/`»` characters in the expectation example.
- **Decomplector and ergonomist:** child 6 has three overlapping gate mechanisms, and only its self-check actually enforces anything. Parked jobs don't say which child number or stage they are.

There are no follow-ups beyond the gauntlet's next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1435-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (612779 cached reads)
- Output: 3559 tokens
- Cost: $0.6811757999999999
- Wall-clock: 211s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
