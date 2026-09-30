## Gauntlet fix round 6: endojs/endo-but-for-bots#1357

I applied the panel-6 must-fix items as one follow-up commit and pushed it with `safe-push-pr-head.sh`, moving the head from `50917af1a4` to `1ff1c08e71`. CI is green: `ci-wait-merge.sh --no-merge` returned rc=0, with all 28 checks passing and none failing. The only file edited was `designs/endo-claude-inference-backends.md`.

**Must-fix items (from critic, decomplector and skeptic)**
- **Shared credential source (critic and decomplector):** § One backend instance per credential now says the unit that gets one admission slot is the `CredentialSource`, not the backend instance. When several backends are made over one credential, they share one `CredentialSource` and never get two sources over the same secret. Decision 9's containment-routing bullet says its sliced and unsliced root backends are made over that one shared source, so they compete for the same slot.
- **Gate 7:** it now also checks that a turn on the unsliced backend and a turn on the sliced backend, issued at the same time, are admitted one at a time.
- **Decision 5 (skeptic):** it now quotes the vendor docs showing that the billing caveat depends on the credential variable, not on `ANTHROPIC_BASE_URL`:
  - "Setting only that variable, without a gateway credential, doesn't replace the subscription."
  - The connect guide says `ANTHROPIC_AUTH_TOKEN` "takes precedence immediately."

  I took these from the live pages at code.claude.com. The decision also says outright that the probe's exact setup (a subscription token in that variable, default Anthropic URL, no gateway) is not covered by the docs either way, which is why gate 1 measures where the usage is billed.
- **Gate 3 (skeptic):** it gains a fifth failure shape. A turn is killed mid-stream, exits nonzero, or emits malformed stream-json, and each must come back as `unavailable`, never as `needs-auth` or a silent `ok`.

**Should-fix items also applied**
- `unavailable.reason` is renamed to `detail`, so `reason` only ever means the fixed list of admission refusal reasons.
- The admission reason `budget` is renamed to `budget-exhausted`, so all three reasons now have the same names as their result tags.
- "Unsliced" is explained where it first appears.
- "Two halves" is corrected to "three parts".
- The Updated metadata line is shortened, as the pruner suggested.

**Left alone on purpose (comment-only suggestions)**
- The pruner's suggestions to cut the "Revision of 2026-09-29" section and the PR-body template sections. That section records the maintainer's answers.
- The copyeditor's "runs" → "run" change. With an "any…, any…, and every…" subject, the singular verb is acceptable.
- The pedant's "API-key" hyphenation. Those uses are compound modifiers.
- The novice's suggestion to split Decision 9.
- The ergonomist's `(string & {})` typing note, which is meant for when the design is turned into a real `.ts` file.

I did not re-run the panel; the driver posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1163618 cached reads)
- Output: 8186 tokens
- Cost: $0.9886836000000001
- Wall-clock: 851s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
