# Gauntlet fix round 5: kriscendobot/minion.town PR #168

I made the round-5 panel's must-fix change to `designs/guest-oauth-bonds.md` and took most of its should-fix items in the same commit. The commit is `171daf2` (ebbaf22 → 171daf2), pushed to `design/guest-oauth-bonds` with `safe-push-pr-head.sh`. CI is **green** (3/3 checks, `ci-wait-merge` rc 0). I did not re-run the panel; the driver posts panel-6.

**Must-fix (skeptic #1): one compromised sign-in can remove all the others.**
- **Added to § 4:** a section on a bearer obtained by recovering the guest through a sign-in, not only by stealing it. In that case an attacker holding any one sign-in can recover the guest and remove every other sign-in.
- **Why removal is not gated:** the server cannot tell a recovered bearer from the original. They are the same identifier, byte for byte. Each possible gate either fails against that attacker or blocks the owner in the case removal exists for.
- **The risk is accepted explicitly, and the user is told.** The § 2 page copy now says anyone controlling a sign-in can take the guest *and remove its other recovery sign-ins*. It also says each sign-in adds a way in and none is a backup for the others.
- **Compensating control:** rows added since this browser last opened the list are marked **New since your last visit**. The design states that this does not help an owner who holds the guest only through recovery.

**Should-fix items taken:**
- **Rate limit (critic #2):** replaced the circular reasoning for the shared budget. Any separate owner allowance is keyed on the same bearer, so a thief could use it up first.
- **Empty-state text (critic #3):** the list response gains a `listComplete` flag, false until the migration finishes. While it is false, the empty state no longer says the guest cannot be recovered.
- **Same-origin check on add (critic #4):** the add route now applies the same `Origin` check as list and remove.
- **Migration fingerprints (skeptic #2):** the script recomputes the fingerprint for every row, and quarantines any row where it doesn't match the stored one.
- **Rolling deploy (skeptic #3):** old processes must be drained before the script runs, and the step-3 re-run is now required. It sets the `listComplete` flag when clean.
- **`Origin` check (skeptic #4):** described as defense in depth only. A request with neither `Origin` nor `Sec-Fetch-Site` is accepted.
- **Silent re-add of a removed account (decomplector #1):** fixed on the add side. Every add now signs out first, using the existing sign-out chain and a `sessionStorage` flag, so the user always picks the account. Removal is now a plain store delete. The "Used to open this guest here" marker, the extra `signInId` in the recovery response, and the sign-out after removal are all gone.
- **Ownership map (decomplector #2):** added a row for the migration script and listed the rate-limit counters as store state.
- **Response shapes (ergonomist #3):** wire fields use the user's words (`addedAt`, `lastUsedAt`), and the list envelope and error codes are spelled out.
- **Tests:** acceptance tests 1, 4, 8 and 11 and the browser-render check were updated to match. The render check now also covers the old "Add a recovery provider" label being gone, keyboard-only use of the dialog, and the sign-out before add.
- **Copyeditor:** applied findings #1–#5.

**Not taken:**
- Changing `§` to "section" throughout (pedant, comment-only).
- The novice's background-section and terminology items.
- Ergonomist #1 (route alias), #2 (rename lands in the same build) and #6 (focus order in the design text). The render check does cover the old label and focus behavior.
- Critic #5's `<!-- garden-design-open-questions -->` marker: it applies to designs on the garden's own repo, not this minion.town PR, and adding it would stop the design panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1414635 cached reads)
- Output: 18042 tokens
- Cost: $1.3165429999999996
- Wall-clock: 480s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
