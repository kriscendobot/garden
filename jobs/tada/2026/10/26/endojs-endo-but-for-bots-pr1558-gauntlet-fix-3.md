# Fix round 3 for endojs/endo-but-for-bots PR #1558: done, CI green

**What I did.** I applied every finding from the latest panel review (5646400335). That covered the must-fix items from critic, skeptic, decomplector and ergonomist, plus the copyeditor and novice should-fix items. All changes are to `designs/endo-child-agent-factory.md`. The commit is `8e67003377`, pushed to `design/endo-child-agent-factory` with `safe-push-pr-head.sh`; it fast-forwarded from `4b21866de6`. Prettier passes.

**Changes:**
- **critic, creating the child's parts:** The design wrongly treated `provideGuest` and `makeUnconfined` as calls that safely reuse an existing value. I checked the daemon source: `provideGuest` returns whatever the name already holds, and `makeUnconfined` always makes a new value and then overwrites the name. Fae's `provisionFaeAgent` checks names first for this reason. The design now checks each name first, adopts only after confirming the value's type, and lists the three crash cases.
- **critic, installing endowments:** Added an `Endowed` phase. The first journal entry keeps the endowment values themselves. Each write is safe to repeat: an existing name with the same identifier counts as done, and a different one fails closed. A final directory listing confirms the child has exactly the endowments it should, before any driver exists.
- **skeptic and decomplector, turn publication:**
  - The design no longer claims a turn never calls `infer` twice. It now promises at-least-once inference, at most one recorded result per turn, and at-least-once publication.
  - It states plainly that a crash before the result is recorded can repeat provider usage and tool calls.
  - The turn key now travels in the existing `replyTo` field (`send`'s `replyToMessageNumber`) instead of the invented message metadata, so no wire change is needed.
  - Collapsing duplicate replies in the Fae and Lal views is now an explicit implementation step (step 6) with an end-to-end test.
- **decomplector, derived namespaces had no owner:** `attenuate(name, policy)` now names the derived namespace in the issuer's index. New `listDerived` and `revokeDerived` calls let the issuer reclaim everything below it: revocation blocks the derived facet, removes nested namespaces and children, and frees quota, and it survives crashes. Tests added.
- **decomplector, scope history:** A new "Scope decision" subsection quotes kriskowal's rejection on #1102 ("Please narrow the scope…") and the later maintainer brief that asked to reopen it. It says maintainer approval of this design is the confirmation, and implementation waits for it.
- **ergonomist and copyeditor:** The design now says a handle is an address, not a callable object, and shows the two-step store-then-send path in code. I split the hard-to-parse sentence.
- **novice:** The example now shows the UI looking up `notes` from its own pet store before passing it.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with 30 checks and 0 failed.

**Follow-up for the maintainer:** The decomplector asked for explicit confirmation before a #1102-style factory comes back. The design answers this by citing the maintainer brief named in the PR body, but only the maintainer can actually confirm, either by approving or by narrowing the scope again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1558-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2235741 cached reads)
- Output: 17802 tokens
- Cost: $1.5047162
- Wall-clock: 855s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
