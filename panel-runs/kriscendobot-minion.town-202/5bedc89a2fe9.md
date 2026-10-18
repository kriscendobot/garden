---
kind: panel-run
repo: kriscendobot/minion.town
pr: 202
panel_kind: code
provider: anthropic
base_ref: origin/feat/new-clip-inventory-a61dc66
pr_body_hash: 361fdaa0e96607a66638f7aa8ba34baa32f201d6570023c00b8c6960005c8476
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 5329a05b83a164811acb5d31553ad6eea6167e13
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 5bedc89a2fe9
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — kriscendobot/minion.town #202 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `5329a05b`

seat verdicts (34): archivist=must-fix assessor=comment benchmarker=comment breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=must-fix migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=must-fix reexport-auditor=pass releaser=pass saboteur=must-fix scribe=pass spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=comment typist=comment warden=pass wire-watcher=must-fix
must-fix items (20):
- archivist: **must-fix**, `designs/chat-clip.md` (header "Aligns with" line, the `[ocap-mailboxes.md](./ocap-mailboxes.md)` link)...
- archivist: **Verified, no finding.** I checked these doc claims against the code and they hold:
- archivist: `CHAT_CORRESPONDENT_KINDS` is `handle`, `guest`, `host`, `remote`, and `invitation` is listed as pending (`src/endo/g...
- archivist: The 4096 UTF-16 send bound, 200-message window, 16-segment max depth, and 64-part limit match their constants. The "6...
- archivist: The agent-method set in `chat-clip.md` § 3 matches the `E(agent).*` calls in the power.
- archivist: `CHAT_POLL_MS = 3000` (`clips/new-clip/model.js:243`) matches the "Polled every 3 s" claim.
- archivist: The UI labels Invite, Accept, Reply, Dismiss, Answer, and Decline match `clips/new-clip/main.js`.
- archivist: Enter sends and Shift+Enter makes a newline (`clips/new-clip/main.js:764`).
- archivist: The `new-clip.md` § 3 wording on the 16-segment path cap and the "one wider endowment" is consistent with the chat s...
- archivist: `clip-shell-framework.md` link to `chat-clip.md` resolves, and no stale "one form" or "one call" wording remains in t...
- archivist: The new CI step in `.github/workflows/test.yml` matches the design's "CI" labels, and the browser demo is correctly d...
- archivist: **Scope note, not a finding.** I did not verify the claim that `test/new-clip.test.ts` pins the agent-method set, or ...
- archivist: **No banner comments.** A scan of added lines found no `// ----`, `/* ==== */`, or box-drawing rule lines.
- breaker: **must-fix: a race lets an imported locator become a chat peer.** `designs/chat-clip.md` § 3 says: "Holding the URL ...
- breaker: **Attack:** a URL bearer pipelines `importLocator(['inventory','x'], <X's locator>)` and `invitePeer([], 'x')` together.
- breaker: **Interleaving:** `notPeerEntry` reads no record. `introduce` sees an empty slot and writes the record. `E(agent).inv...
- breaker: **Result:** `x` now has an introduction record and resolves to X. `conversation([], 'x')` returns the owner's whole m...
- breaker: `adoptValue` has the same race, using a handle a legitimate peer sent.
- breaker: **Fix:** run every inventory write that can land at `<app>/inventory/<name>` inside `exclusive`, and re-check the rec...
- breaker: [proposed-rule: a check-then-write guard that protects a reserved slot must hold the same lock as every writer that c...
