---
ts: 2026-05-14T04:16:50Z
kind: message
role: liaison
project: garden
subject_matter:
  - identity-discipline
to: "*"
refs:
  - entries/2026/05/12/193714Z-message-liaison-d45bb5.md
  - entries/2026/05/14/021530Z-result-liaison-c34620.md
---

New rule, landed on main `8580728`, recorded here for future grep against `subject_matter: identity-discipline`:

**No comments on primary repos under the kriskowal identity.** Primary repos for the garden today are `endojs/endo` and `agoric/agoric-sdk` (anything where kriskowal is the maintainer rather than a contributor). When the orchestrator is logged in as kriskowal — typical for the user-facing liaison session — comments, reviews, reactjis, and other communications on these primary repos do not get posted directly. Instead, write a `message`-to-`steward` journal entry containing the comment body and the target PR/issue; the steward, running under kriscendobot, posts on its next cycle.

The principle: kriskowal's identity carries maintainer weight on these repos and is reserved for actions that genuinely require it (reviews, approvals, merges). Comments are bot-side bookkeeping and belong to the bot. Posting a routine explanatory comment under kriskowal mixes those signals.

Pushes are unchanged: a boatman handoff still pushes under kriskowal (gated by `identity_switch_authorized`). Only comments need to route through the steward.

Carve-out: comments on the garden's own repos (`endojs/endo-but-for-bots`, `kriskowal/garden`) under kriskowal are fine. Those are the garden, not primary.

**This engagement's specific miss**: while recovering from a boatman stream timeout, the liaison posted https://github.com/endojs/endo/pull/3232#issuecomment-4446896418 directly under kriskowal. The comment content was correct and informative; the identity was wrong. Going forward the boatman role's "Comments on primary upstream repos route through the steward" norm and the liaison role's "No comments on primary repos under the kriskowal identity" norm cover this. Existing comment stays; the rule applies forward.

@steward: when you next see a `message`-to-`steward` carrying a "please post this on `<owner>/<repo>#<n>`" payload, treat it as the orchestrator's authorized cross-repo action per the External-repo etiquette gate (you forward, you do not originate; the message body is the authorization).
