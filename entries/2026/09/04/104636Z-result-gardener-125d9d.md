---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-04T10:46:50Z
---
PR: https://github.com/kriscendobot/minion.town/pull/88 (design panel, seat decomplector)
Diff base: origin/main. Worktree: /home/kris/garden2/scratch/project-wt-kriscen-2460ae0613c0-21df4b26

### decomplector (simple-vs-easy / complecting lens)

**Verdict:** request-changes

**Findings:**

- **§ 2.1 + § 5 + Q7 — place-vs-value, and the complexity it exports.** The origin labels a *place* (a mutable directory's formula id) while the design needs it to denote a *value* (one immutable payload). The repair is a promise the edge keeps — and that cost does not stay at the edge: § 5 tells **every clip author** to embed a defensive schema-version marker "to fail-closed if a policy breach ever puts a differently-shaped payload at its origin," complexity that exists only because immutability is a policy rather than a property of the representation. Content-addressing (Q7) deletes unit 4's enforcement path, § 5's marker, and Q1's mutable-pointer tension in one move. § 8 gates unit 4 on Q7; unit 5 and § 5's marker are ungated — gate them, or answer Q7 in-doc. [proposed-rule: a design deferring a representation choice must mark every downstream unit and guest-facing workaround that choice would delete, not only the unit implementing it.]

- **§ 3.1 — the locator complects name, grant, and object.** "Naming and authorizing are one act" is honest, and Q2/Q3 are correctly derived as one primitive. But unit 1 **builds** the braid now, § 1 books the sunset cost as "unmitigated," and old origins live forever — so every `v=1` backend minted before Q2 is answered carries a grant revocable only by destroying the object, permanently. The forwarder the design names in one sentence is the minimum viable abstraction that unbraids the three. Take it in unit 1, or state that unit 1 must not serve live clips before Q2 settles. [proposed-rule: a design naming the decomplected alternative to a braid it ships must state which follow-on unit may not land before that braid's open question is answered.]

- **Directive 4 vs § 5 — the contract line overclaims.** "An application **may rely on** a static local-storage schema… Both guarantees are part of the clip contract" reads unconditional; § 5 shows it holds only while the § 2.1 policy is upheld *and* the app maintains one-locator-per-origin, which "the locator does not enforce." Move both conditions into § 5's Decision line and the mandate bullet. [rule: skills/gricean-maxims/SKILL.md]

**Notes (out of scope but worth flagging):**

- Credit: unit 5's split of `publish` (content) from `mintLiveLink` (authority) removes the braid the live `publish`/`upgrade` surface carries, and § 3.3 cleanly separates protocol `v` from content version from storage schema. Keep both through any revision. [rule: roles/jurors/decomplector/AGENT.md § Operating norms]
- The origin does triple duty — payload identity, storage partition, party namespace. Q3 and Q8 are symptoms of that one braid; name the shared root so it is decided once. [proposed-rule: open questions that are facets of one modeling decision belong grouped under it, not listed independently.]
- Replay-safety of the post-connect redeem frame (§ 3.4) is a code-panel (breaker / locksmith) question on the implementation PR.

Self-improvement: this design pre-names most of its own braids, so the seat's value shifted from *finding* complecting to checking whether a named braid is **built ahead of its own open question** — worth adding that check to the brief's category walk.
