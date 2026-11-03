**Gauntlet fix round 2: kriscendobot/minion.town#233**

I applied all the panel's must-fix items and pushed them to the PR head, moving it from `485bf557` to `89911497`. CI is green (`ci-wait-merge` rc 0). As the job instructs, I did not re-run the panel.

**Must-fixes applied (commits `603dc35c`, `89911497`):**
- **Cancel authorized by identity (locksmith):** I removed `owner` from the registry. `mint` now returns the entry's cancel, and each identity's `GuestInviter` holds it by pet name. `acceptLocal` is now bound inside `makeGuestInviters`, so sessions no longer receive it, which also covers most of the locksmith's should-fix on over-wide deps.
- **Cancel reporting success while a link stayed live (saboteur, breaker, wire-watcher, engine-realist):**
  - Each guest now holds at most one invitation per name.
  - A name is reserved before the first await, so a concurrent `invite` is refused.
  - A new mint retires whatever is still held under a name that `remove` freed.
- **Failed cancel losing the retry path (breaker):**
  - The entry stays pending until the daemon cancel succeeds.
  - If the minting connection is gone, the cancel clears the slot through the current connection, but only if `identify` shows the slot still names this invitation.
- **Spent invitation returning to pending (wire-watcher):**
  - A new `InvitationSpentError` marks the link as spent.
  - A redeem checks the slot first, so a removed or rebound link answers 404 rather than a retryable 503.
  - An overtaken accept spends the link and frees both guests' names.
- **Design contradiction (integrator):** design § 14, the remote design and the PR body now say that only the tool names are shared. I also corrected the stale passages in `designs/remote-guest-endo-cli.md` and `designs/guest-coupons.md`.
- **Missing changeset (releaser):** added `.changeset/mcp-guest-invite.md`.

**Should-fixes also applied, because they sat in the same code:**
- Spent entries drop their closures.
- Silent cleanup catches now log.
- `cancelInvite` reports an in-flight accept and a name still held by something else.
- The restart residue and its `remove` recovery are documented in the tool text and § 14.
- The stale `composeFacet` comment and the capability wording are corrected.
- Three of the pruner's rename-history cuts are made: the `mcp-tool-names.ts` comment, the design table cell and the § 14 "Names" paragraph.

**Verification:**
- **Types:** `tsc --noEmit` is clean.
- **New tests:** they cover the re-invite sequence, concurrent mint, retry after a failed cancel, a dead connection, a rebound slot, and an overtaken accept.
- **Real daemon:** `test/web/guest-web-daemon.test.ts` passed on the CI `ENDO_CHECKOUT` leg, including the new assertions on freed names and 404s.
- **Full local vitest:** with `TMPDIR` on scratch, the first run had 2 failures, in `test/git-remote/git-remote-e2e.test.ts` and `test/git-remote/capability.test.ts`, and a rerun had only the `capability.test.ts` one.
  - `git-remote-e2e.test.ts` was a dubious-ownership error from `TMPDIR` on scratch; it passes with `TMPDIR=/tmp`.
  - `capability.test.ts` ("propagates a git failure…") also fails with `TMPDIR=/tmp`, but CI's vitest step passes. I did not find its cause. This PR doesn't touch that file.

**Follow-ups for the maintainer (both noted in the PR body):**
- **Open decision:** should `cancelInvite` key on a pet name, as here, or on an opaque `inviteId`, as the remote design says? This should be settled before the tool shape ships. I documented the conflict rather than choosing.
- **Known limit, not fixed:** a redeem doesn't re-run the inviter's admission check, so a link outlives a later suspension of its inviter, and that inviter can't then void it (design § 14, *Known limits*).
- **Other should-fixes not applied:**
  - the duplicate `GuestInvitation`/`BrowserGuestInvitation` type
  - the memory backend's `acceptLocal` storing the locator as a contact
  - the remaining pruner cuts, including trimming the PR body
  - decomplector's lazy-mint alternative

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr233-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (2337503 cached reads)
- Output: 50796 tokens
- Cost: $2.8581486
- Wall-clock: 1094s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
