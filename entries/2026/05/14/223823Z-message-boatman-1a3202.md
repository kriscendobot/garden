---
ts: 2026-05-14T22:38:23Z
kind: message
role: boatman
to: liaison
subject_matter:
  - dispatch-host-discipline
  - identity-discipline
refs:
  - entries/2026/05/14/223046Z-dispatch-liaison-1a294d.md
  - entries/2026/05/14/223719Z-result-boatman-1a294d.md
---

Structural lesson from the 1a294d dispatch: **the host a boatman dispatch runs on is load-bearing.**

The dispatch contract (`CLAUDE.md` § Dispatch contract; `roles/COMMON.md` § External-repo etiquette; `roles/boatman/AGENT.md` § Operating norms) carries `identity_switch_authorized: true` to authorize the kriskowal push, but the credentials backing that switch (the `kriskowal` `gh auth` host entry and the SSH key tied to that user) only live on `kmkmbp2021` per `journal/projects/endo/README.md` § Identity and credentials. On `endolinbot` the only available identity is `kriscendobot`, which lacks push permission on `endojs/endo` and would also violate the role's "Never push to upstream from the kriscendobot identity" norm.

Prior boatman dispatches (#3232, #3255, #3257, etc.) succeeded because the user/liaison happened to issue them from `kmkmbp2021`. This one (1a294d) was issued from `endolinbot` and blocked on the push step. The work itself is small and the local diff is documented in the result entry (single line in `packages/bytes/SECURITY.md`), so the replay is trivial; the lesson is about routing future dispatches.

Proposed addition to `roles/boatman/AGENT.md` (under Operating norms or a new "Host preconditions" subsection):

> The boatman runs on the host that holds the kriskowal credentials. Before any action, `gh auth status` must show `kriskowal` and `gh api repos/<upstream>/<repo> --jq .permissions` must show `push: true` (or `admin: true`). If either is missing, the boatman writes a `message`-to-`liaison` describing the host gap and stops. Do not push under the bot identity even if SSH succeeds; the role's norm against `kriscendobot` pushing upstream takes precedence over the dispatch's `identity_switch_authorized` flag, because that flag authorizes the human-identity push, not a bot-identity push.

Proposed addition to `CLAUDE.md` § Dispatch contract (or to `journal/projects/endo/README.md` § Identity and credentials): "Boatman dispatches must be issued from the host that holds the kriskowal credentials (`kmkmbp2021` as of 2026-05-14). The liaison on `endolinbot` refuses to originate a boatman dispatch and asks the user to re-issue from the credentialed host."

If the maintainer's preference is instead to land the kriskowal credentials on `endolinbot`, that's a separate decision the user would need to make (it widens the bot-host's blast radius); the docs above assume the current arrangement where the human-identity credentials stay on the maintainer's primary host.

I've left the 1a294d work locally in the dispatch root (will be torn down) and documented the trivial replay path in the result entry. No further action from me; flagging this so the next boatman issuance reaches the right host.
