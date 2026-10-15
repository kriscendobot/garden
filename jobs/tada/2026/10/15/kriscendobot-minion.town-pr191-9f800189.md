I revised the design on kriscendobot/minion.town#191 to take in kriskowal's directive ([comment 6201208707](https://github.com/kriscendobot/minion.town/pull/191#issuecomment-6201208707)). The preflight's exit 2 came only from our own "On it" ack comment. No commit or reply had dealt with the directive, so I did the work.

**Changes to `designs/root-canary-reader-identity.md`** (commit 90db939, pushed to `design/root-canary-reader-identity`):
- **Formula-identifier accounts:** the design now records that accounts are keyed by a guest formula identifier, and that OAuth identities (the root's included) are associations.
- **Why a Cognito `sub` is paired with a guest identifier** (kriskowal didn't remember the reason), new §3. The existing designs give two reasons:
  - An MCP client presents only a bearer token, so the server needs `sub` → guest to know which guest the session drives (`mcp-endo-guest.md`).
  - Recovering the key on a new device (`invitation-only-guest-onboarding.md` §5).
- **OCapN canary first**, new §6:
  - Capture each guest's formula identifier into a host-local file on `endolin-garden1`.
  - Use the Endo CLI to pass messages and capabilities between several guests, one of them operated by a Claude session.
  - #186 (the MCP mint) becomes the second step.
- **Re-authenticating a Claude guest**, new §7: covers kriskowal's dedicated email address idea. Whoever can read that mailbox can sign in as that Claude account, so its credential stays on the host like the other secrets. Until the mailbox exists, a lapsed login queues and messages the maintainer.
- **What the code shows**, §8: the pivot is only partly implemented.
  - `src/auth/accounts.ts` has `bondGuest` and `recoverGuest`, but the store is still keyed by `iss+sub`.
  - The root's Claude powers are gated in `src/endo/claude/wiring.ts` on Cognito `sub`s (`ENDO_CLAUDE_ROOT_SUBJECTS`). An OCapN session as the root therefore can't reach the root-only checks yet.
- **Open questions**, §9: the two answered ones are marked resolved. Two new questions lead the list:
  1. Should root powers be gated on the root's formula identifier instead of a `sub`?
  2. Should the garden provision the dedicated email address, and should it tie to a separate Claude account?

I also rewrote the PR description and replied to kriskowal on the PR ([comment 6202857337](https://github.com/kriscendobot/minion.town/pull/191#issuecomment-6202857337)).

**Not done:**
- Nothing was built or provisioned; this is a design PR and it is still a draft.
- I haven't checked that the Endo CLI steps in `remote-guest-endo-cli.md` §7 work end to end today. The design makes a hand run of them the first build step.
- The earlier gauntlet run halted because the PR targets a floating base. It needs "pin the merge base #191" before review can run again. I didn't change that.

**Follow-ups:**
- Once kriskowal answers question 1, post a build job for the OCapN canary.
- Shrink #186 as §10 of the design describes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr191-9f800189.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (814983 cached reads)
- Output: 12365 tokens
- Cost: $0.9456566
- Wall-clock: 169s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
