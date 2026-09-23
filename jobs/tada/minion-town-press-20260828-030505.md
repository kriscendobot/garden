I've now done a thorough, evidence-based assessment. Let me record the key conclusion and complete.

Findings from this dispatch:

**1. The #52 deviation is settled, not a fork.** `designs/weblet-ocap-synthesis.md` § 9 explicitly names the `register(directoryId, owner)`-vs-`register(directory)` deviation and declares "§ 9 is the authoritative record" — a deliberate, security-reasoned landed shape (the guest hands the directory's formula id + owner key; the exo pins it in its own store; the unit-3 attenuated `site-register-caplet` closes the former cross-tenant exposure). The maintainer already accepted this direction (review on #47, merge of #52). The only residual is a mechanical doc-sync of §§ 2.2/3.1 to the landed shape — buildable, not a maintainer decision. **This is the answer to the job's step 1: build-on-able, not an open question.**

**2. The § 9 arc is largely delivered — further than the design's own status line.** I verified in the current tree that unit 4's residue is gone: no `4012` close code, no `assertNotHostShaped`/host-shape guards, and the host-authority `makeDaemonPowersSource`/`powersFormulaId` resolver symbols are removed (`powers-source.ts`/`powers-plane.ts` survive only as files retargeted to site directories). `site-registry-exo.ts`, `daemon-site-registry.ts`, and `site-register-caplet.ts` are all present. Units 1–5 have essentially landed; remaining § 9 residuals are the live-daemon CI verification (deliberately `ENDO_CHECKOUT`-gated outside CI) and `weblet_upgrade` on the live path.

**3. The board is saturated with in-flight/parked work; no clean non-colliding artifact for me.** Since the job body was written, #52/#57/#61 all merged. Open threads: #60 (design: CLI→guest, pushed 03:02 — 3 min before my claim), #59 (pluribus TCP netlayer doc), #58 (Playwright e2e), #56 (design: invitation-only onboarding — a maintainer mandate, non-draft, awaiting review), #54 (844-occurrence weblet→clip rename, draft), #37 (ocap-mailboxes design, review addressed, awaiting maintainer merge word), #33/#50/#45/#32/#29/#17. `inbox-list` shows no live minion.town builder/designer — the openers of those drafts have all completed; the drafts are parked.

**4. Why I neither pressed nor pinged this tick.** The one candidate fork the job flagged (the deviation) resolved to "documented/settled." The non-draft designs (#37, #56) are in normal maintainer-review latency — not a design fork I'm positioned to resolve, and pinging "please review" is the escalation the job warns against. The remaining on-arc residuals are: (a) a §§ 2.2/3.1 doc-sync that would directly collide with the live 844-occurrence rename in #54 and add marginal review burden, and (b) #33 (`retarget user powers to site directories`), which is now several merges behind `main` and overlaps the per-guest attenuated `site-register-caplet` that landed in #52 — its disposition (rebase-to-salvage the garden-#58 user-powers-discovery sliver vs. close-as-superseded) is PR-lifecycle housekeeping for the liaison, not a design decision needing @kriskowal. Manufacturing either would be the busywork the stop-condition explicitly forbids.

Net: assessment complete, no genuine design fork blocks the arc, and no clean non-colliding artifact to advance without stepping on a live parked draft. Deferring per the job's guidance. One soft note for the liaison's next triage: **#33 looks substantially superseded by #52's landed `site-register-caplet`** and is worth a close-vs-rebase disposition — but that's routine PR triage, not a maintainer fork, so I'm not escalating it to the maintainer inbox this tick.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-press-20260828-030505.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 17 tokens (443562 cached reads)
- Output: 18364 tokens
- Cost: $1.2041080000000002
- Wall-clock: 292s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
