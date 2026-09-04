Everything is in place. Job complete.

---

## Completion report

**What I did.** Designed the "worthy first experiment" for clip publishing, session bootstrap, and content upgrade on kriscendobot/minion.town, expanding kriskowal's `CHANGES_REQUESTED` review on PR #85 into a self-contained design and opening a draft design PR.

**What changed (branch `design/clip-immutable-nonce-locator`, PR #88, base `main`, draft):**
- **New `designs/clip-immutable-nonce-locator.md`** — populated header block (`Status` = spec only/no live change, `Mandate`, `Grounded against`, `Companion`), all five directives captured as normative decisions:
  1. Immutable per-payload clip content, cached forever; dynamic routes named as **reserved-but-unbuilt**.
  2. **Nonce-locator CapTP session**: backend reachable only via a backend **formula id** carried in the URL **hash** as `URLSearchParams` (`#?v=1&p=<nonce>`), conveyed out of band; the fragment is never sent to the server, so holding the GET is insufficient to connect. Specified `v` as versioning the **locator/handshake protocol only** (not content, not app storage).
  3. Upgrade = **mint fresh clip id + redirect** (app-driven over CapTP) + app-owned local-storage migration (origin-scoped, so it doesn't carry across).
  4. Static local-storage schema guarantee alongside static content.
  5. The **guest primer as the wiring contract** — stated exactly what it must say.
  - Two **mermaid sequence diagrams** (GET→hash-nonce→session; upgrade redirect + storage migration), both validated with `mermaid.parse`.
  - A reconciliation table (survives vs. replaced) against `clip-ocap-synthesis.md`, the #85 disposition option, follow-on units, and six genuine `## Open questions`.
- **`designs/clip-ocap-synthesis.md`** — added **"Superseded by"** notes to §§ 3.2 (in-place upgrade), 3.3 (ambient `back` serving), and 3.4 (stable identity), each pointing to the new doc; kept the `@sites` spine and § 9 landed-units record.

**Reconciliation.** Explicitly stated what survives (the `@sites` register-by-introduction spine, the ocap premise, guest-owned directory, the deployed `ocap-site-clip-isolation.md` isolation floor) and what is replaced (in-place rewrite → fresh-id+redirect; stable identity → per-content-version origin; ambient `back` → nonce-gated locator). Noted **no design/doc currently owns a "guest primer"** surface, so the design introduces that contract and scopes authoring it as a named follow-up.

**#85 disposition — surfaced, not decided.** Posted a comment on PR #85 (issuecomment-5535632640) and put the same in #88's body/§9, naming the deciding question: close #85 as superseded, or salvage the daemon `@sites` wiring / owner gate / fs-record `contentRoot` plumbing under the new model. No lifecycle action taken.

**Follow-ups.** The draft's design-panel gauntlet stages automatically at completion. Maintainer decisions pending: #85 disposition, and the six open questions (notably static-redirect-at-old-origin, nonce rotation/revocation, and per-recipient nonces vs. the unique-URL rule).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-immutable-nonce-locator-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2497624 cached reads)
- Output: 28415 tokens
- Cost: $2.8033740000000003
- Wall-clock: 550s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
