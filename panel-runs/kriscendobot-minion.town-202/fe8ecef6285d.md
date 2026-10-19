---
kind: panel-run
repo: kriscendobot/minion.town
pr: 202
panel_kind: code
provider: anthropic
base_ref: a61dc66667cc545d1c7d5f2a488264dbd9c64db8
pr_body_hash: 2899ee01240ec178278b8a9db1d8cb30822d267ca02b0d6afa09bab24c1cffae
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: fedda269832b41aa9119a1cab1ed05fc5d4e23ad
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: fe8ecef6285d
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — kriscendobot/minion.town #202 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `fedda269`

seat verdicts (34): archivist=comment assessor=must-fix benchmarker=comment breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=must-fix curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=must-fix scribe=must-fix spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=comment typist=comment warden=pass wire-watcher=must-fix
must-fix items (20):
- assessor: **must-fix: a hung `accept` wedges the whole power.**
- assessor: **Where:** `src/endo/gateway/new-clip.ts`, `acceptInvitation`, non-inventory branch: `exclusive(async () => E(agent)....
- assessor: **Problem:** `accept` can wait on a remote or offline correspondent. While it waits, the single `tail` promise queue ...
- assessor: **Failure scenario:** a user accepts an invitation from a peer who is offline. The page's 10s `CALL_TIMEOUT_MS` fires...
- assessor: **Inconsistency:** the inventory branch deliberately runs `accept` outside the lock. This branch should hold the lock...
- assessor: [rule: designs/chat-clip.md § 3 (every checked-then-acted path runs in `exclusive`)] [proposed-rule: never await net...
- assessor: **should-fix: a successful send can be reported as "Not sent".**
- assessor: **Where:** `clips/new-clip/main.js`, `submit`.
- assessor: **Problem:** `await call('sendMessage', ...)` and the follow-up `await refresh()` share one `try`. Once the send succ...
- assessor: **Fix:** put `refresh()` in its own `try`, or route its failure through `load`'s peer-scoped handling.
- assessor: [rule: skills/panel-review/SKILL.md (error paths must land where intended)]
- assessor: **should-fix: `submit` ignores the generation after its awaits.**
- assessor: **Where:** `clips/new-clip/main.js`, `submit`.
- assessor: **Problem:** it writes `state.replyTo` and the DOM elements after the await without checking `isCurrent(generation)`....
- assessor: **should-fix: `introduce` does not check that `inventory` exists.**
- assessor: **Where:** `src/endo/gateway/new-clip.ts`, `introduce`, and `chatAppAt`, which only checks the app path.
- assessor: **Problem:** `E(space).has(...slot)` is called directly on a slot whose parent may be missing. `present()` exists for...
- assessor: **Failure scenario:** an app with no `inventory` directory makes `has` throw. That is an obscure error instead of "na...
- assessor: **comment-only: `listPeers` is all-or-nothing on one bad record.**
- assessor: **Where:** `src/endo/gateway/new-clip.ts`, `listPeers`.
