Inbox empty. Fix stage complete.

## Completion report — gauntlet FIX round 2, kriscendobot/minion.town PR #96

Applied the design panel's round-2 must-fix items to `designs/claude-agent-credential-reauth.md` in one pass, pushed as a review-feedback follow-up commit (`b52f96b`), and CI came back **GREEN**.

**Must-fix (request-changes) items addressed:**
- **InferResult misattribution** (critic, skeptic, ergonomist): rewrote §2 prose, the sentinel table header/cells, and §7 to name the exact type and layer — `needs-auth`/`subscription-busy`/`unavailable`/`usage-exhausted` are admission-time siblings on `infer()`'s return union, *not* members of `endo-claude.md`'s `InferResult` (which carries text or the mid-run `limit-exceeded`).
- **Fail-closed catch-all** (critic, decomplector): the unclassifiable exit now gets its own bounded, eventually-visible `unclassified` disposition (own retry ceiling → standing-admin advisory), distinct from a genuine `limit-exceeded` retry, closing the silent-forever-retry hole.
- **Park ceiling split** (decomplector): split into two named deployment params — `ticketLifetime` (security bound on the mailed capability/URL) and `parkCeiling` (operational patience before `reauth-abandoned`) — with all §4/§5/§6/§8 references updated.
- **begin() → connect()** (ergonomist): renamed for surface coherence with base `ClaudeAccount.connect()`; distinct return tag justified by delivery difference.
- **Escalation facet special name** (ergonomist): named it `@claude-reauth` with a stated `introducedSpecialNames` provisioning rule alongside its siblings.
- **Acceptance evidence** (skeptic): added isolated tests for the wedged-agent host-only escalation path and the non-self-resetting API-key spend-cap sub-case.

**Comment-only should-fixes also applied** (copyeditor/pedant/novice): sentinel gloss on first use, above/below collision reword, tense slip fix, `@claude-account` two-shapes clarification, numeral form (`10 minutes`), backticked `ocap-mailboxes` citation, unified "confined `claude -p` loop" term, and a cued usage-exhausted pivot in §6.

Only the design file was committed; an unrelated `package-lock.json` `engines` drift from the warm-cache install was reverted before staging. Did not re-run the panel (the driver re-posts panel-3).

Follow-ups: none. The PR still carries four maintainer-facing `## Open questions`, which is expected for this design.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr96-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (4015855 cached reads)
- Output: 32938 tokens
- Cost: $3.7988065
- Wall-clock: 511s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
