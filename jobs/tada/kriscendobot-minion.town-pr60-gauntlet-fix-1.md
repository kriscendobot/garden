CI is green. All panel round-1 must-fix items applied.

Applied the panel's round-1 must-fix items to `designs/remote-guest-endo-cli.md` (PR #60), pushed as a review-feedback follow-up commit, and CI came back green.

**What changed** (one commit, `2100a3c`):
- **Count fix** (critic/copyeditor/pedant/novice): §2 lead-in "Two smaller deployment gaps" → "Three" to match its three-item list.
- **Novice comprehension**: added a paragraph defining top-host vs guest, the guest facet and its four powers, and a sentence explaining Endo's `E(...)` eventual-send.
- **Pet-name collision policy** (critic): §3.2 now states acceptance is *rejected*, not silently overwritten, when `localPetName` already denotes an unrelated value.
- **Decomplection tradeoff** (decomplector): §4 explicitly owns that `localPetName` doubles as revocation key and binding name, with the re-mint-invalidates-in-flight-copy consequence spelled out.
- **Upstream go/no-go** (skeptic): new checkpoint paragraph in §3 stating §§4–8 don't proceed if the guest-owned `invite` primitive lands differently or is declined, with the poller named as fallback of last resort.
- **Sibling-design boundary** (skeptic): noted the onboarding design is unmerged, the link may not resolve on `main`, and the account/guest boundary isn't yet enforced.
- **Named diagnostic test** (skeptic): §8 item 2 now requires the CLI test to assert the transport-unavailable reporting behavior from §5.
- **Ergonomist naming**: tool renamed `guest_invite_remote` → `guest_invite`; `expiresAt` retyped `string` → `number` (epoch-ms); attachment field `edge` → `edgeName`; named the required `guest_send` description rewrite.
- **Copyeditor**: reworded the tangled "over" clause in gap item 3.
- Plus the two cheap comment-only asks: broker negative-space sentence and a post-acceptance disconnect note.

All text is ASCII (no em-dashes / non-typist code points). No follow-ups; the driver will re-post panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr60-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 51 tokens (1844362 cached reads)
- Output: 19138 tokens
- Cost: $2.0428990000000002
- Wall-clock: 327s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
