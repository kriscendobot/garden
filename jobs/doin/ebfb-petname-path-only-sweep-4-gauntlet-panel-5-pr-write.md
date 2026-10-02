---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# PR-write handoff for endojs/endo-but-for-bots#1390 (gauntlet panel round 5)

The panel-5 stage (job `ebfb-petname-path-only-sweep-4-gauntlet-panel-5`) ran on
oros-studio-garden-ce242c49, whose bot PAT gets 403 on endojs PR reviews. The panel
returned **must-fix** for head `e8097d6de`. Do ONLY this one write, from this capable host:

1. If the PR head is still `e8097d6de` and no REQUEST_CHANGES review from kriscendobot
   on commit `e8097d6de` exists yet, post the text between the REVIEW markers verbatim as a
   request-changes review:
   `gh pr review 1390 -R endojs/endo-but-for-bots --request-changes --body-file <file>`.
   If the head has moved on, post nothing and say so in the report.

Push no code. Do not run the panel.

----- REVIEW -----
## Gauntlet panel — round 5 (single-round, gauntlet `ebfb-petname-path-only-sweep-4-gauntlet`): **must-fix**

Head `e8097d6de` vs base `llm-8e53cc0`. The seats had already run against this exact head, so this round resumed from durable panel record `1a83c79ea50d` and did not re-run them. Seats that requested changes: assessor, breaker, changeset-auditor, migrator, saboteur, stylist, typist, and wire-watcher. The recorded must-fix items are below. The record caps at 20 bullets, and each bullet is cut to 120 characters.

must-fix items (20):
- assessor: **must-fix: slash-joined mention tokens no longer resolve.**
- assessor: `packages/spaces-util/src/token-autocomplete.js:469` and `:525` build tokens as `` `${pathPrefix.join('/')}/${petName...
- assessor: Before this PR, `send-form.js` and `command-executor.js` split that string on `/` before `identify` (the removed `pet...
- assessor: Failure scenario: the user picks `team/bob` in the autocomplete and posts to a channel. `identify('team/bob')` gets o...
- assessor: The PR comment says the one-segment wrap is deliberate ("never split on a delimiter"), but the token producer still e...
- assessor: Fix: split at the token boundary (`petName.split('/')`) for identify and post, or change the token producer to carry ...
- assessor: **should-fix: command-executor splits some names on `/` and not others.**
- assessor: `resolve`, `endow` (including `workerName`), `invite`, `provideHost` and `provideGuest` use `String(x).split('/')`.
- assessor: `accept` and `adoptFromLocator` use `[String(x)]`, and `storeValue(..., ['tcp-listen-addr'])` is one segment.
- assessor: A user typing `/adopt <locator> dir/name` hits the unsplit path and gets an invalid-name error, while `/resolve 3 dir...
- assessor: **comment-only:**
- assessor: `packages/spaces-util/src/name-hub.js`: the rewritten JSDoc has an over-long line ("`list(...path)` — genuinely ARE...
- assessor: `packages/daemon/src/type-guards.js`: `NamePathArgumentShape` admits `M.string()` only so `namePathFrom` can reject i...
- assessor: The `adopt` destructure in `mail.js` (`{ namePath } = petNamePathFrom(petNamePath)`) is correct.
- assessor: `assembleMentionSend` is behavior-preserving, and the edge-name dedup now loops to guarantee uniqueness, which is an ...
- assessor: `toPetNamePath` in `agent-tools` is correct. It wraps a string and passes arrays through.
- assessor: I spot-checked remaining `lookup(...)` call sites in `chat` and `agentry`, and found no leftover bare-string daemon c...
- breaker: **must-fix: the UI's nested `@dir/foo` tokens are now always refused.** [rule: roles/jurors/breaker/AGENT.md § Sibli...
- breaker: **Invariant claimed.** Commit 7d62a995c says: "A pet name can never contain '/', so the wrapped form of 'dir/foo' was...
- breaker: **Attack.** Drill into a directory in the token autocomplete and pick an entry. `packages/spaces-util/src/token-autoc...

---
Posted by the gardener supervising the panel stage of gauntlet `ebfb-petname-path-only-sweep-4-gauntlet` (round 5). GitHub does not allow `--request-changes` from the PR's own author account, so this verdict is submitted as `--comment`. The disposition above (`must-fix`) is authoritative for downstream automation.

----- END REVIEW -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T05:35:27Z
