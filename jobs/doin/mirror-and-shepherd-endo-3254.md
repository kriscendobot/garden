# Mirror endojs/endo#3254 onto endo-but-for-bots, record the mapping, and shepherd to green

Maintainer directive: mirror https://github.com/endojs/endo/pull/3254 and shepherd it.
Wear the **boatman/mirror** role for the mirror, then **shepherd** (`roles/boatman/AGENT.md`,
`roles/shepherd/AGENT.md`). This is the cross-fork mirror pattern: copy an upstream endo PR
onto `endojs/endo-but-for-bots`, where the bot has direct push, and drive its CI to green.

## The upstream PR (confirmed)

- **endojs/endo#3254** — "chore: harden browser-test installation" by `naugtur`, OPEN.
- Base `master`; head branch `naugtur/browser-test-config` (on endojs/endo, not a fork);
  **3 commits**. No existing mirror recorded.

## 1. Create the mirror on endo-but-for-bots

- Mirror onto **`endojs/endo-but-for-bots`** base **`master`** (the bot fork's master tracks
  `endojs/endo@master` — sync bot-master to current upstream master first if it has drifted,
  per the standing "rebase on master implies sync-bot-master-to-upstream first" discipline).
- Fetch endo#3254's 3 commits (`naugtur/browser-test-config`), put them on a mirror branch
  (e.g. `mirror/3254-browser-test-config`) on endo-but-for-bots, and **open a mirror PR**
  against `master`. Title/body should make clear it mirrors endojs/endo#3254 (link it).
  Resolve any conflicts against the current master.
- **Bot identity** (`kriscendobot`) — this is the bot's own fork; **no identity switch**
  (the boatman's identity-switch is for the upstream-ferry direction, not for mirroring
  onto our fork). Use the kriscendobot token explicitly.

## 2. Record the mirror mapping on the journal (reinforcement)

Record the mapping **upstream `endojs/endo#3254` ↔ our mirror `endojs/endo-but-for-bots#<M>`**
in the journal so the (in-flight) `garden-mirror-closer` service can later close this mirror
when #3254 closes upstream. Write it under `journal/pr-mirrors/` (coordinate with the schema
being established by the `build-mirror-closer-service` job; record at least
`upstream: endojs/endo#3254`, `mirror: endojs/endo-but-for-bots#<M>`, `created_at`, and how
it was created). This makes #3254 a real live mapping (and a good end-to-end check for the
mirror-closer once it lands).

## 3. Shepherd the mirror to green

Drive the mirror PR's CI to green (`skills/pr-ci-watch`, `skills/ci-failure-classification-loop`):
re-run known operational flakes, classify real failures, and address what is in scope. If a
failure is out of scope / fixer-fixable, escalate per the standing shepherd→fixer auto-chain
rather than stopping.

## 4. Communicate on the PR

Per the standing norm: post a **top-level summary comment** on the mirror PR — what it mirrors
(endo#3254), the mirror branch/head SHA, and the CI/shepherd status — in addition to any
inline replies.

## Definition of done

A mirror PR of endojs/endo#3254 open on endojs/endo-but-for-bots (base master, bot identity),
the upstream↔mirror mapping recorded on the journal, CI shepherded to green (or the real
blocker classified and escalated), and a top-level summary comment posted. Report the mirror
PR number, head SHA, mapping location, and CI status. If the mirror cannot be created cleanly
(e.g. master drift/conflicts), report the precise obstacle rather than forcing it.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 8
  claimed_at: 2026-06-25T17:02:41Z
