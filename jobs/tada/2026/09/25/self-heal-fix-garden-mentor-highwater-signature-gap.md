I've fixed it: when every configured mentor provider is at its budget high-water mark, `mentor.sh` now counts that as a temporary outage (retry next tick, exit 0). It no longer dies and sets off a self-heal run that would fail the same way. The fix is pushed to `main2` as `ce8eecf4c47`, after one rebase.

**What changed**
- **`scripts/jobs/common.sh`:** added `at (its )?high[ -]?water( mark)?` to `GARDEN_TRANSIENT_CLAUDE_SIGNATURES`, plus a comment explaining why. This matches both lines `mentor-claude.sh` logs when it skips a provider ("subscription X is at high water" and "Claude quota is at its high-water mark"). The `mentor.sh` improve handler therefore records the outage and exits 0 instead of calling `die`. I left out the `(is )?` prefix the job suggested because it adds nothing to the match.
- **`scripts/jobs/test/claude-session-limit-classifier-test.sh`:** four new checks. The full log from all providers being skipped is classified as temporary, and so is each provider's skip line on its own. A bare "no configured mentor inference provider was available" with no high-water reason is still treated as a real failure.

**Test results**
- In `claude-session-limit-classifier-test.sh`, all the classifier checks pass, including the four new ones. Five of its end-to-end gardener checks fail, but the unmodified baseline fails the same five when run standalone on this host (38 passed, 5 failed), so this change didn't cause them.
- `mentor-provider-order-test.sh` passed (40/0), and `mentor-transient-backoff-test.sh` and `mentor-rejection-backstop-test.sh` both passed.
- I didn't run the full `run-test.sh` suite. I started it by mistake thinking it ran a single test, and stopped it partway through.

**Follow-ups**
- The five end-to-end failures in `claude-session-limit-classifier-test.sh` are worth their own look, since that test isn't a reliable guard on this host right now.
- The new pattern applies to every consumer of the shared list, not just the mentor. For example, `claim-job.sh` also logs "is at its high-water mark". Any job output with that wording will now be treated as a temporary quota backoff, which I believe is the intended behavior.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mentor-highwater-signature-gap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (741725 cached reads)
- Output: 5356 tokens
- Cost: $0.7374249999999998
- Wall-clock: 828s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
