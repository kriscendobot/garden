Job complete. Draft PR opened, licensing surfaced to the maintainer, inbox clear.

## Completion report — `translate-grant-matcher-to-docs`

**Done.** Translated Mark S. Miller's *The Grant Matcher Puzzle* into an Endo-stack documentation page and opened a draft PR on the fork.

**Deliverable:** draft PR **endojs/endo-but-for-bots#630** — https://github.com/endojs/endo-but-for-bots/pull/630 (state OPEN, `isDraft: true`, base `master-eecc683` frozen snapshot).

**Source (authoritative, confirmed).** Fetched via `scripts/jobs/fetch-source.sh` (erights.org refuses the sandbox; retrieved from the `erights.github.io` mirror). Content SHA-256 `d25136c9…` — **byte-identical to the anchor the scholar fleet recorded** when it ingested the same puzzle (`scholar-ingest-grant-matcher-puzzle`), so the source identity is verified, not assumed. I also fetched the six linked Java reference files (`Charity`/`GrantStatus`/`GrantMatcher`/`EQ…`/`Equals…`/`MalletCharity`) to ground the code translation in the actual implementation.

**What changed (in the PR):**
- `docs/grant-matcher.md` — new page. Miller's argument and prose kept faithful; his key definitional passages (the three capability rules, the two questions, the "Alice gets greedy" crux) quoted as attributed block quotes, surrounding exposition paraphrased in a documentation voice.
- `typedoc.json` — one line registering the page in `projectDocuments` (renders under **Guides**, between message-passing and spackle). JSON validity verified.

**Translation conventions applied** (consistent with the thesis-translation direction), each substitution flagged inline for the reader:
- **E → Jessie / Hardened JavaScript:** eventual sends → `E()`; makers/facets/interfaces → `makeExo` + `M.interface`; Java reference impl → `makeGrantMatcher(sameDestination)` with `makeEqGrantMatcher`/`makeEqualsGrantMatcher` variants and a `makeGreedyForwarder`. Java's lock → the ocap turn discipline (synchronous busy-sentinel guard, mirroring Miller's `myNumDonations`).
- **CapTP → OCapN:** the third-rule / man-in-the-middle resistance attributed to OCapN's handoff; address-equality `EQ` rendered as `===` on presences, made pass-invariant across machines by OCapN.
- Matched the repo's blockquote house style (existing docs use `> **Bold.**`, not GitHub `[!NOTE]` alerts).

**Attribution & licensing — surfaced as a maintainer decision** (per the job): the page and the PR body both flag that Miller's work is copyrighted, no license is assumed, and it must not be merged/published until a maintainer confirms permission or reduces it to a summary-with-citation. Also sent to the **maintainer inbox** (delivered `20260707T224012Z-530858`).

**Not verified / out of scope (stated honestly):**
- **No rendered docs-site build.** TypeDoc's `projectDocuments` build needs a full workspace install; I verified the JSON and markdown structure but did **not** observe a rendered site. Flagged in the PR.
- **No upstream ferry** — fork-side draft only, as instructed.

**Follow-ups for the maintainer:** (1) the licensing/permission decision (blocks publish); (2) confirm the `Guides` vs `Annex` category placement; (3) optionally run the docs-site build to confirm rendering before un-drafting.
