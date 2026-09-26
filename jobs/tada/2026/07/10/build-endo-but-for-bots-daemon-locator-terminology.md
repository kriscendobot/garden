No reply yet. The investigation is genuinely complete and the outcome is faithfully reported to the maintainer. There is no code to build or commit here, so I'll close out with a full report rather than open an empty PR or loop on a requeue.

---

## Completion report

**Job:** `build-endo-but-for-bots-daemon-locator-terminology` (design `daemon-locator-terminology.md`, M3 / size S) — build the daemon terminology + `endo://` locator-format change on `endojs/endo-but-for-bots` as a fresh feature PR.

**Outcome: no build performed — the design is already fully implemented and merged on `llm`.** Opening a "fresh feature PR" would have produced an empty/duplicate PR, so I did not open one. I verified this directly in an isolated project worktree checked out at `origin/llm` (HEAD `7870da1d91`).

**What I found already landed** (commits `5bd2f09d69` *"locator scheme with @-delimited connection hints (closes #34)"* and `24b8dcb688` *"align locator hint terminology"*, both post-dating the 2026-02-24 design):
- **Terminology types** (`types.d.ts`): `PeerKey`, `FormulaAddress`, `FormulaKey`, `ConnectionHint`, `PeerLocator`, `FormulaLocator`.
- **New locator format** (`locator.js`): `endo://{peerKey}/{formulaAddress}@{hint}@{hint}?type=…`; `parseLocator` returns `hints`; `formatLocatorWithHints`, `hintsFromLocator`, `internalizeLocator`, `externalizeId`, plus back-compat aliases.
- **`locateWithHints`** fully wired: `host.js` impl, `interfaces.js` guard, `types.d.ts` interface, `help.md` + `help-text-data.js` docs. (`directory.locate()` already folds hints in as well.)
- **Comprehensive `locator.test.js`** covering the design's locator test plan: parse/format round-trips, URL-encoded `@` `/` `?` hints, and externalize/internalize round-trips for both local and remote nodes.

**What is *not* implemented (and I judge out of scope for this size-S job):** the design's **"LOCAL_NODE Normalization"** section — sentinel-based *storage*, the `repairIds` startup DB-repair pass, `normalizeId`, `internalizeLocator` taking `isLocalKey` to fold local keys → `LOCAL_NODE`, and `externalizeId` swapping `LOCAL_NODE` → agent key. The `LOCAL_NODE` sentinel exists in `locator.js`, but storage still uses real node numbers and there is **no `repairIds`/`normalizeId` anywhere in `src/`**. That is a large, high-risk core-identity + on-disk migration (not size-S), and the design notes it "builds on `daemon-256-bit-identifiers.md`" — reading as a separate/later phase.

**What changed:** nothing in the repo (no commits, no PR). No garden files changed.

**Escalation / follow-ups:** Messaged the maintainer (via the liaison) with the above and a recommendation to (1) mark the design **Complete/Landed** for the terminology + locator format, and (2) if the **LOCAL_NODE storage-normalization** phase is genuinely wanted, post it as a **separate, M-sized job** rather than fold it into this one. Awaiting their decision on that separate phase — it should arrive as a new job, not a requeue of this one.
