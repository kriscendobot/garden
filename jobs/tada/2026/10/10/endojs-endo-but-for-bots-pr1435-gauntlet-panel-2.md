I ran panel round 2 on endojs/endo-but-for-bots#1435 ("design: plan Moddable SDK 10.0.0 IronHorse ports"). The verdict is **must-fix**, and I posted it to the PR as a comment review.

- **Setup:** I made an isolated project checkout of the head branch `design/moddable-10-0-0-ironhorse-port-plan` at commit `7d2d6f8d12`. Dependency setup timed out waiting on a shared lock, which didn't matter here because the design panel doesn't need dependencies installed.
- **Panel run:** I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1435 7d2eb307a2ee…` against the frozen base `llm-7d2eb30`. It exited 0 with the disposition **must-fix**, and all 9 seats completed.
- **Review:** I posted the full aggregate with a round-2 header as review https://github.com/endojs/endo-but-for-bots/pull/1435#pullrequestreview-5478421583. It went up as a plain comment because GitHub refuses a request-changes review from the PR's own author, which is also how round 1 was posted.

What the seats found:
- **Must-fix (pedant):** en-dashes in numeric ranges (`2–3 days` and similar, about 8 instances in the design doc and `designs/README.md`) break the typist-friendly code-point rule. They should become ASCII hyphens or "to".
- **Should-fix:**
  - **Critic:** the claim that children 1–5 work on separate code ignores the snapshot goldens and boot fingerprint that more than one child would regenerate. Moving the oracle pin from 8.3.1 to 10.0.0 also pulls in XS changes outside the audited window. Child 5 (immutable ArrayBuffer) has no design for how it is represented.
  - **Skeptic:** the 8.3.1 oracle is known to be wrong on several of the rows being ported, but the plan doesn't say what a child does when its correct output disagrees with it. The 12 already-conformant rows rest on code reading, so they should be marked provisional. The manual check that holds back child 6 lets it through if the maintainer misses a failure.
  - **Ergonomist:** the Items table needs stable row IDs and should be sorted by owning child, and the capture-group check split between child 3 and child 6 should be named in each child's scope.
  - **Copyeditor:** a handful of prose fixes (undefined "green expectation", a pronoun mismatch, a missing comma, and similar).
- **Comment-only or approve:** decomplector, novice, orthographer and thesaurus raised nothing blocking.

No follow-ups are owed from this stage; the gauntlet driver takes it from here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1435-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (769208 cached reads)
- Output: 3954 tokens
- Cost: $0.6939776
- Wall-clock: 755s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
