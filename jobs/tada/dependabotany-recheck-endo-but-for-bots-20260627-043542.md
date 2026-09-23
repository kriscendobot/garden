The new ledger entry is committed to `origin/journal2` and discoverable by the standard recovery grep. Inbox is empty. Work complete.

---

## Completion report

**Job:** Daily dependabotany recheck of `endojs/endo-but-for-bots` — re-evaluate embargoed Dependabot PRs whose maturity date has arrived.

**Ledger recovered** (2 embargoed OPEN rows on record):

- **#197** (electron 40→42), EMBARGO-**2026-06-30** — maturity 3 days out as of today (2026-06-27). **Not due → left embargoed, untouched.** It also carries its own maintainer-directed one-time recheck (`dependabotany-recheck-endo-but-for-bots-pr197`) firing 2026-06-30T23:00Z, with the daily sweep as backstop.
- **#362** (grouped `all-minor-patch` ×15), EMBARGO-**2026-05-31** — maturity passed, so due, but on inspection the PR is **CLOSED**.

**Action taken — #362 row retired (no terminal verdict needed):** GitHub shows #362 was closed by **dependabot[bot] itself** on 2026-05-31 ("Looks like these dependencies are updatable in another way, so this is no longer needed") — i.e. superseded, not awaiting a botanist decision. Per the workflow's "still OPEN" gate, no re-botany, merge, or close was warranted. I recorded a ledger-row-retirement journal `message` entry tagging the row as superseded, posted to `journal2` at `entries/2026/06/27/043924Z-message-botanist-bacb07.md` (verified discoverable via the canonical recovery grep). The ws 8.21.0 / GHSA-96hv-2xvq-fx4p CVE-fix is not lost — it returns in dependabot's next regrouped run.

**Schedule state:** The ledger now holds exactly one embargoed OPEN row (#197). The standing daily `dependabotany-recheck-endo-but-for-bots` schedule is therefore **retained** (deletable only when zero embargoed rows remain). No schedule change this tick.

**Follow-ups:**
- The next sweep that matters for #197 is its dedicated 2026-06-30T23:00Z one-time job (post-maturity); today's daily sweep was correctly a near no-op.
- Once #197 reaches a terminal verdict on/after 2026-06-30, the ledger will be empty and the daily `dependabotany-recheck-endo-but-for-bots` schedule can be deleted.

No code changed; no merges or closes performed; inbox drained clean.
