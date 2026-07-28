Job complete. Report follows.

---

## Completion report — `endojs-endo-but-for-bots-pr881-review-5111ec6e`

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) for review 4799182277; re-run for the peer review 4799231902 also returned PROCEED.

**The review.** dckc's review 4799182277 had an empty body and exactly one inline comment, on `packages/exo-google-sheets/src/exo-google-sheets.js:273`: `if (readOnly)` is a smell; code that can't write should statically not have write authority; "this whole file is a very strange way to do attenuation"; see `@agoric/pola-io` and the `disciplined-python-attenuation` style guide. I read both references (npm tarball for pola-io; raw GitHub for the style guide) as data, plus the in-repo precedent in `exo-shell` / `exo-git`.

The critique was correct. Every facet came from one `makeFacet(kind, scope)` closure holding the whole Sheets client, string-tag-dispatched; a reader and a writer differed by a label, not by what they held, and four write methods were gated by a mutable `readOnly` boolean the control facet could flip either way.

**What changed** (3 commits, pushed to `build-exo-google-sheets-facets`, head `2f496e52d6`, PR still MERGEABLE and draft):

- **a690aca1a3** `refactor(exo-google-sheets): attenuate by construction, not by flag` — split one authority into three classes over disjoint client operations: `src/a1.js` (A1 as powerless data), `src/powers.js` (`makeReadPowers`/`makeAppendPowers`/`makeWritePowers`, each taking only its own client operations, plus the policy and two revocable forwarders), `src/facets.js` (exos that take power objects and no client), `src/exo-google-sheets.js` (the one place a whole client is held). `setReadOnly(flag)` replaced by `control.revokeWrites()`.
- **c2ba34f3ae** `docs(...)`: design doc's `SpreadsheetControl` corrected — it had claimed write authority is "not a mode bit the agent can flip" while specifying exactly that; README gained a per-module authority table.
- **2f496e52d6** `feat(...): add part(), the mereological narrowing verb`.

**Two bugs found and fixed en route:** `title()` and `sheets()` called the network without `charge()`, so they escaped both the rate limit **and** `revoke()` — a revoked capability could still read the spreadsheet title and tab list. Both now enter through the same caretaker as any other read, with tests.

**Peer coordination.** Mid-job, gardener 7 (`...-review-baf7087b`) messaged that dckc had posted a second review (4799231902) five minutes later on the same thread — "POLA-shaped attenuation usually follows a mereology builder pattern: `whole.part('A')`" — and handed me the constraint rather than have two workers rewrite one file. They had already replied publicly on the thread and were off the bus by the time I drained. I folded it in: `part(designation)` is now the uniform narrowing verb on all four facets, composing (`part('Tasks').part('A1:C10')`) and naming both axes at once (`part('Tasks!A1:C10')`), with `sheet(title)` retained as the disambiguator for an A1-shaped tab title.

I also corrected one point in gardener 7's published reading: they listed `sheet()`/`range()`/`help()` bypassing the `revoked` flag as part of the same hole. It is not — those perform no I/O, and a facet minted from a revoked capability shares its caretaker, so it is born revoked. Charging the limiter for a local operation would be the error. Said so on the thread.

**Verification** (run in the isolated project worktree): prettier clean, eslint clean at **0 warnings** (the original had 6 pre-existing ones, now removed), `tsc` clean, **6 tests passing** (was 1). New tests cover structural attenuation, `part()` composition and two-axis orthogonality, `revokeWrites` severing mutation while reads survive, `revoke` stopping metadata reads, and the throttle covering metadata.

**Threads closed:** SHA-citing replies on both inline comments (`#discussion_r3667143734`, `#discussion_r3667184381`) and two top-level summaries (`#issuecomment-5106507616`, `#issuecomment-5106587591`).

**Follow-up flagged, not taken:** the same `setReadOnly(flag)` shape lives in `@endo/exo-playwright` (`packages/exo-playwright/src/browser.js:346`, plus its tests and README) and in the `endoclaw-oauth` / `endoclaw-browser` designs. Out of scope for this PR; offered on the thread as a separate PR. No garden-library (`main2`) changes were needed for this job, so the per-job garden worktree is empty.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr881-review-5111ec6e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 193 tokens (12744741 cached reads)
- Output: 71095 tokens
- Cost: $9.9256165
- Wall-clock: 1139s

<!-- garden-usage-end -->
