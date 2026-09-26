Fix stage complete. CI is green.

## Completion report — gauntlet FIX round 1, kriscendobot/minion.town PR #49

**What I did.** Applied the panel round-1 (request-changes) must-fix/should-fix items to the vitals-weblet / git-remote-capability companion design pair, pushed as a review-feedback follow-up commit (`09735bf`), and watched CI to terminal: **GREEN** (1 check, 0 failed).

**Scope note.** The PR's own diff changes only `designs/vitals-weblet.md`; `designs/git-remote-capability.md` is already merged (via #41). The panel reviewed both as one unit and its request-changes findings overwhelmingly targeted the companion file (and the cross-doc inconsistencies between them). I applied fixes to **both** files — cross-doc consistency (e.g. `fleet.json`↔`garden.json`, `writer`↔`write`) is unfixable from one side alone — bringing `git-remote-capability.md` into this PR.

**Changes applied (by seat):**
- **pedant** — ASCII arrows (`→`→`->`) in the vitals-weblet mermaid EP label; mermaid re-checked (parse valid; local render blocked only by a Chrome-sandbox environment limit, not syntax).
- **ergonomist** — pet-name `vitals-writer`→`vitals-write` and `my-site-writer`→`my-site-write` (verb-suffix convention); made all three attenuations explicit (`-read`/`-write`/`-readwrite`) so the bare name is never the strongest right.
- **skeptic** — stated the leader-push funding/self-exemption assumption (§4 vitals-weblet); stated ref-advance→record-re-point crash-safety as *derivation* (served `contentRoot` is a pure idempotent function of the live ref tip, reconciled) rather than a silent two-write gap; updated §8 to acknowledge #40's reconciliation is now done in this PR.
- **critic** — pinned Strategy A's git `object-format` to **SHA-1** (CAS keys objects by its own sha-256 of the bytes, *not* the git oid), so the SHA-1 leader-repo push is not foreclosed by a SHA-256-only reading.
- **decomplector** — partition **composes** (does not subtype) the directory node; pointed at attenuation as a queryable structured field.
- **copyeditor** — `vitals/fleet.json`→`vitals/garden.json`; `#41` self-ref→"this design"; added missing comma after a quotation; dropped a dangling "earlier `no-cache` sketch" reference; spelled out "OQ" at first use and labeled the §13 numbering.
- **novice** — glossed the core terms (ocap/guest/pet-name/capability-URL/partition/attenuation) at first use.

**Deliberately not done:** the repo-wide **em-dash** rewrite — the pedant explicitly deferred it on this PR given unaddressed repo-wide precedent (surfaced as a policy question, not a blocking demand). New prose matches the file's established em-dash voice. Novice's larger "move §1 ahead of Grounded-against" reorder was addressed with the term gloss instead of a risky whole-section move.

**Follow-ups.** None owned by this stage. The driver re-posts panel-2; per the fix-stage contract I stopped without re-running the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr49-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 93 tokens (5230127 cached reads)
- Output: 30361 tokens
- Cost: $4.614848499999998
- Wall-clock: 520s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
