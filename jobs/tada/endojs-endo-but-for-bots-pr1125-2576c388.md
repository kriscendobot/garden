Inbox empty. Work complete.

---

**Completion report**

**Directive** (PR #1125, comment r3996772398 by kriskowal): decide whether to migrate a guest formula from a prior version based on what exists on master — no deployed guest formula has a `pins`/`heldPins` property; those are artifacts of our own branch iterations.

**Preflight:** Ran the recheck preflight → exit 2 (HINT). Corroborated: the only correlated thread text was the garden's own "On it" acknowledgment reply (id 3996796290), not a resolution. No commit/reply/board artifact satisfied the ask, so I proceeded with the work.

**Verification of the premise:** On master (`origin/llm`), the guest formula-record case carries **no** pins-related field at all (only `hostAgent`, `hostHandle`, `handle`, `petStore`, `mailboxStore`, `mailHub`, `worker`). Confirmed no deployed formula has either the old `pins`/`heldPins` or the new `guestPins`/`hostPins`.

**Change** (commit `e2b38e8bc`, pushed to `kriscendobot/endo-but-for-bots@bot/build/endo-guest-invite-primitive`): removed the legacy-name migration shims across the daemon:
- `formula-record.js` — `formula.guestPins ?? formula.pins` / `?? formula.heldPins` → direct `formula.guestPins` / `formula.hostPins`.
- `mail.js` (`reincarnateMailboxPins`) — same fallback removal.
- `manager.js` — dependency-label normalization, guest incarnation destructure (dropped `legacyGuest/HostPinsDirectoryId` merge), and guest-invite host-pin retention.
- `types.d.ts` — deleted the two `@deprecated pins?`/`heldPins?` `GuestFormula` fields.

Canonical `guestPins`/`hostPins` stay **optional** — the legitimate backward-compat concern (real master guest formulas that carry neither) is handled by the `?`/`!== undefined` guards, which remain.

**Checks (all green):** daemon `lint:types`; repo-root `tsc -p tsconfig.json` (checkJs, with `--max-old-space-size=8192`); `eslint` on the four files (0 errors); `mail-pins.test.js` (2/2); and the two guest-pins `endo.test.js` cases (`provideGuest accepts a caller-selected guest pins directory`, `guest invites a guest and they exchange mail`) run via a short-socket-path workaround (uncommitted, reverted) for the known long-path limit — 2/2.

**Posted:** threaded reply on the review comment (id 3996818621) reporting the decision and evidence.

**Follow-up (out of scope, noted):** the PR body still describes the hidden directory by its old field name `heldPins`; a future body edit could align it to `hostPins`, but that's documentation drift, not part of this directive.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-2576c388.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (3806368 cached reads)
- Output: 23455 tokens
- Cost: $3.313909
- Wall-clock: 438s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
