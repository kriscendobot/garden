CI is green. All panel round-5 must-fix items applied, pushed, and CI passed.

## Completion report

Applied the gauntlet panel round-5 must-fix items to PR #49 (kriscendobot/minion.town, a design-only PR touching `designs/vitals-weblet.md` and `designs/git-remote-capability.md`), pushed as one review-feedback follow-up commit (`e78c406`), and confirmed CI green.

**Fixes applied (by juror finding):**
- **critic #1 / skeptic #1** (§ 1 steady-state) — committed the partition to **reset on every publish** so the bound follows arithmetically; separated the **reachable/billable** bound (delivered by the reset) from the **on-disk** bound, and named `git-remote-capability.md` § 12 item 7 (per-partition GC) as the delivery prerequisite for the disk bound.
- **decomplector #1 / copyeditor #4** (§ 4 funding) — replaced the price-list "is this partition operator-owned?" identity check with **self-funding read off the capability at mint time** (a no-meter attenuation / pre-funded escrow minted alongside `vitals-write`); smoothed "charges…at the capability" → "meters…against the capability".
- **skeptic #2** (§ 4 leader handoff) — added the mirror-image **revoke the outgoing leader's capability** step, grounded in § 6's first-class revocation.
- **critic #2 / novice #1** (§ 4 origin-across-cutover) — restated the invariant plainly, put contingency before preference, and **deferred the option tree to a new § 11 OQ 5** rather than pre-committing to an option the same paragraph unwound.
- **ergonomist #1 / copyeditor #1** — restored **`write-only`** to match the `read-only` sibling in the § 6/§ 7 attenuation triad.
- **copyeditor #3** (§ 4 Freshness) — restored the elided verb/preposition.
- **copyeditor #2** — glossed "OQ" at its first use and reworded the clause.
- **pedant #1** — fixed § 13 OQ 10 list-marker continuation indentation (3→4 spaces).
- **pedant #2** — unified the § 12 heading to the hyphenated **named-not-actioned** form.
- **novice #2** — spelled out **compare-and-swap** in § 4 to end the CAS/content-store acronym collision.
- **pedant #3** — cleaned the `*[quoted verbatim]*` marker to `*Quoted verbatim:*`.

**Result:** pushed `5524911..e78c406`; CI GREEN (rc 0). Per stage instructions, I did not re-run the panel — the driver re-posts panel-6.

No follow-ups outstanding from this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr49-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 69 tokens (2980979 cached reads)
- Output: 25541 tokens
- Cost: $3.0044385000000005
- Wall-clock: 413s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
