Fix round 3 for endojs/endo-but-for-bots#1414 is pushed and CI is green: all 28 checks passed (`ci-wait-merge` rc 0).

**What I did**
- Read the round-3 panel review (5390039443) on head `c80950f0b5`. It had one must-fix, from the novice juror: three unrelated "pin" concepts (`@pins`, `pinDirectory` and the per-record `pin` token) were never told apart.
- Made one follow-up commit, `0688159b3c`, to `designs/daemon-guest-delegated-host-channel-confinement.md` and pushed it with `safe-push-pr-head.sh` as a fast-forward from `c80950f0b5`.

**What changed**
- **Must-fix:** `@pins` is now defined where it first appears (a guest's own durability directory). The Floot's Container Mounts section has a new paragraph explaining that `@pins`, the registrar-only `pinDirectory` and the random per-record `pin` token are different things.
- **Skeptic should-fixes:**
  - The survey was missing fae's `setup-with-tools.js`. It is now in the list of setup scripts and in the Provisioning Changes table.
  - The claim "no factory calls `provideHost`" was false as written. It now says "on a delegated host", and floot's `floot-factory-setup.js:311` `provideHost` (called on the operator's own host) is named and excluded.
- **Critic should-fixes:**
  - The design now gives the exact peer/bootstrap audit grep. I re-ran it on `90b4f72604`: the only call site is that floot one, and the other hit is prose in floot's agent prompt.
  - The floot survey row no longer suggests floot's controller-host operations (`provideHostPath`, `provideGit`, `provideMount`) are in scope.
- **Smaller items:**
  - Added a sentence that `has` and `list` still report refused `@`-special names; only resolving one is refused.
  - Reworded the ambiguous `llm` vs `llm-provider` sentence.
  - Added a lead-in to the Naming check paragraph.
  - Removed the `` `send`s `` construction.
  - Fixed title case on two headings and their cross-references.
- **Open Question 4:** it is now framed as a trust-boundary readability question and recommends renaming `host-agent` in phase 3. Two jurors (decomplector and ergonomist) asked for that.

**Not addressed (all should-fix or comment-only)**
- Decomplector: the design doesn't explain why a `memberId` can't be mistaken for a `FormulaIdentifier`, and how new `EndoHost` methods get classified.
- Ergonomist: naming the new `redactChannelMessage` to match the existing `makeMessageRedactor`.
- The vague phrase "content-locator guards" in the withheld-methods list.
- Pruner: trimming the boilerplate sections of the PR body.

**Follow-ups:** none. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (904292 cached reads)
- Output: 4186 tokens
- Cost: $0.8572600000000001
- Wall-clock: 884s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
