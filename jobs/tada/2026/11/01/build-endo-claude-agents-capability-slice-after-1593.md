I opened draft PR **endojs/endo-but-for-bots#1626**. It makes inference-backed children, including the Claude CLI and Agent SDK makers, actually run on a real daemon. Before this, none could.

**What was left to build.** Design steps 1–6 already have PRs (#1560–#1564), but on two separate branches off #1560:
- daemon wiring and the maker adapters (#1561 → #1562);
- the turn ledger and reply collapse (#1563 → #1564).

Nothing had run the two halves together. When I merged them and ran them on a real daemon, three defects showed up:
1. **The inference maker failed on a daemon** with `No corresponding formula for (an object)`. It stored a temporary inference grant in the driver's directory, and the daemon can only store things it can name. The maker now stores itself (the deployer's durable maker) under `inference-source`, and each runner asks it for its own child's grant through a new `childInference(agent)` method. This adds no new power, because `installDriver` already gives the same thing. I noted this in the design file.
2. **The turn ledger's `run()` couldn't read a real mailbox.** The daemon hands back a stream reader, not an iterator, so the `next()` call threw. It now uses `iterateReader`. The test fake now returns the same kind of reader, so #1563's crash tests exercise the real protocol.
3. **A new runner exited straight away.** It starts before the coordinator commits the child, so its first "is the child active?" check said no. It now waits for the child to become active, and a runner revived while the child is being removed never opens the mailbox.

**What the PR adds on top:** the inference runner now records every turn in the ledger. It answers only complete messages, puts the child's instructions in front of each prompt (the old runner ignored them), and dismisses a message only after its reply is recorded as sent. The ledger gained three options that default to the old behaviour: `guest` is optional, an `accepts` filter, and an `afterPublished` hook.

**Tests:**
- A new real-daemon test creates a child through the factory and mails it. It checks the reply and the ledger records, restarts the daemon, and shows the answered turn is neither re-run nor re-sent.
- New unit tests cover replaying a recorded result, waiting for activation, and the removal case. Removing the activation wait makes both activation tests fail.
- Everything I ran passes: all 53 `@endo/exo-agent-factory` tests including the daemon tests, `@endo/claude` (181), the relevant Fae suites (63) and the Lal maker tests (2). Lint is clean in all four packages, the repo-root type check reports no errors, and the pre-push gates pass.

**Why it isn't based on `llm`:** that would repeat all five open stack PRs in its diff. Instead it sits on a frozen branch, `build/exo-agent-factory-stack-merge-790f436`: #1562 and #1564 joined by one merge commit. The only conflict was in the package README, and I kept both sections. The PR body says this.

**Follow-ups:**
- The parked job `build-endo-child-agent-factory-slice-2` asks for work that #1561–#1564 and now #1626 already cover. It should be dropped, not promoted.
- The plan record `plan/designs/endo-but-for-bots/endo-claude-agents-capability.md` still lists only #1560. #1626 should be added to it.
- Not done here: crash tests inside a real daemon (the in-memory crash tests cover those points), and a live Claude turn, which needs credentials.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-agents-capability-slice-after-1593.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 186 tokens (11562613 cached reads)
- Output: 53527 tokens
- Cost: $4.708510600000001
- Wall-clock: 849s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
