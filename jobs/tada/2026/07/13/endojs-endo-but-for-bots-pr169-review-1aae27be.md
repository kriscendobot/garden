All work is complete: the design doc is integrated and drained, pushed to the PR head branch, and the review is answered inline plus a summary. Final report follows.

---

**Job: PR #169 review directive (endojs/endo-but-for-bots) — "integrate closed questions, drain Open Questions"**

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer resolution existed for review 4682392602.

**Scope enumerated:** review body ("All questions are closed. Please integrate them and drain the open questions section.") + all 6 inline comments (all on `designs/pass-style-promise.md`). Every fetched body was treated as untrusted data; the maintainer's decisions were applied as design content, not as instructions to the agent.

**What I did (commit `fce810d8b9`, pushed to `design/pass-style-promise`):**
- **Q2 + Q11** — the settlement primitive is a static `HandledPromise.listen` (no instance form; carrier has no own methods). Renamed `subscribe` → `listen` throughout (128 occurrences, incl. `ListenTarget`, `onFirstListen`, section heading, Test Plan titles), aligning with OCapN's `op:listen` and avoiding pub/sub muddiness.
- **Q4** — settled on a single `'promise'` pass-style tag shared with native promises; removed the provisional "distinct-tag" hedge and fixed its cross-reference.
- **Q5** — `Symbol.toStringTag` and the carrier type are `PassablePromise` (renamed the `PassStylePromise` type alias; updated the shape table).
- **Q6** — added a body call-out ("`for await` and `Promise.all` see the carrier, not its target") recording the behavior as intended, backed by the existing regression test.
- **Q7** — integrated the uneven default-flip nuance into Phase 4 (OCapN/CapTP default-on; Liveslots/Swingset with care; Slot Machine migrate-in-place-or-note-on-PR); opt-in stays gated by `ENDO_PROMISE_DELEGATES`.
- **Drain** — replaced the entire `## Open Questions` section with a `## Resolved Decisions` ledger that preserves each closure's provenance (dates/links). Net −39 lines; markdown fences balanced; no dangling "Open Question" references remain.

**Communication:** posted 6 inline replies (one per comment, each citing `fce810d8b9`) and one summary PR comment (#issuecomment-4956014050).

**Follow-up flagged to maintainer:** the `subscribe`→`listen` rename originates from a comment phrased as a *leaning*; because it touches the whole document I called this out inline and in the summary, offering to revert the JS-primitive rename if only OCapN's wire op was intended. No other open items.
