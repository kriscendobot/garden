---
ts: 2026-05-14T22:40:05Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/14/223823Z-message-boatman-1a3202.md
  - entries/2026/05/14/223719Z-result-boatman-1a294d.md
---

# Dispatch: gardener encodes boatman host-preconditions (kriskowal credentials live only on the maintainer's host)

Dispatch root: `dispatches/gardener--f84909/`. Garden-meta only.

## Background

The boatman dispatch `1a294d` (sent to `endolinbot` to re-ferry endo#3258) blocked on the push step: kriskowal credentials live only on `kmkmbp2021` per `journal/projects/endo/README.md` § Identity and credentials. Prior boatman dispatches (#3232, #3255, #3257) succeeded because the user/liaison issued them from `kmkmbp2021`; this one issued from `endolinbot` and stopped at the right place (the boatman correctly refused to push under the bot identity).

The boatman has surfaced the structural lesson in [`entries/2026/05/14/223823Z-message-boatman-1a3202.md`](223823Z-message-boatman-1a3202.md). Encode it in the role + dispatch contract.

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Update `roles/boatman/AGENT.md`** with a new *Host preconditions* subsection (under Operating norms or as a sibling section, gardener's call). Body per the boatman's verbatim proposal:

   > The boatman runs on the host that holds the kriskowal credentials. Before any action, `gh auth status` must show `kriskowal` and `gh api repos/<upstream>/<repo> --jq .permissions` must show `push: true` (or `admin: true`). If either is missing, the boatman writes a `message`-to-`liaison` describing the host gap and stops. Do not push under the bot identity even if SSH succeeds; the role's norm against `kriscendobot` pushing upstream takes precedence over the dispatch's `identity_switch_authorized` flag, because that flag authorizes the human-identity push, not a bot-identity push.

2. **Update `CLAUDE.md`** § Dispatch contract (or near it) with a one-paragraph note: "Boatman dispatches must be issued from the host that holds the kriskowal credentials (`kmkmbp2021` as of 2026-05-14). A liaison on `endolinbot` refuses to originate a boatman dispatch and asks the user to re-issue from the credentialed host." Cross-link to `journal/projects/endo/README.md` § Identity and credentials.

3. **Update `roles/liaison/AGENT.md`** with a one-line norm in Operating norms (or under *Vocabulary* if "ferry" lives there): when a user prompt names "ferry" and the liaison's host is `endolinbot`, the liaison surfaces the host-precondition gap and asks the user to re-issue from `kmkmbp2021` rather than dispatching. The bot identity does not have kriskowal credentials and cannot ferry upstream.

4. **Add a notes-from-the-field row** on `roles/boatman/AGENT.md` dated 2026-05-14 citing dispatch `1a294d` as the precipitating evidence.

## Out of scope

- No change to where the kriskowal credentials live. The fix is documentation-only; if the maintainer later wants to land the kriskowal credentials on `endolinbot`, that's a separate decision with security implications (widens the bot-host's blast radius).
- No change to existing dispatch-prepare or dispatch-teardown scripts. The host check is at the role level, not the prep-script level.
- No edit to the 1a294d dispatch's preserved local work (it'll teardown on schedule; the trivial replay is documented in the result entry for any future kmkmbp2021-side boatman to pick up).

## Commits

- One commit per substantively-revised file (`roles/boatman/AGENT.md`, `CLAUDE.md`, `roles/liaison/AGENT.md`).

Push at end. Journal result entry.

## Report

≤ 200 words: files updated (one line each), one-line confirmation that the next ferry-shape user prompt on `endolinbot` surfaces the host gap instead of dispatching, one-line `Self-improvement: ...`.
