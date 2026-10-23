Fix round 1 for endojs/endo-but-for-bots PR #1543 is done. I applied every finding from the latest panel review (5623727251), including the should-fix ones, pushed them as one follow-up commit, and CI came back green (`ci-wait-merge` rc 0, 30 of 30 checks, 0 failed). There was no pre-pass output block, so the review was the source.

The commit is `42ed60c66` on `design/claude-api-key-agents`. It went from `3749575e5` straight forward with `safe-push-pr-head.sh` (no history rewritten).

**`designs/api-key-inference-providers-and-pinned-agents.md`**
- **Provider ownership (critic and skeptic must-fix):**
  - Each provider record now has a fixed `ownerId`, and there is a per-owner `InferenceProviderDirectory`. A provider id is only looked up inside the signed-in owner's directory.
  - Looking up a foreign or unknown id gives the same `provider-not-found` error, so it can't be used to probe for other users' providers.
  - The agent factory refuses a provider and guest with different owners (`provider-owner-mismatch`).
  - Owner partitioning is now required in phase 1, with denial tests. Before, it was only required "for a multi-principal deployment".
- **Crash recovery across the two stores (critic, skeptic, decomplector must-fix):**
  - The provider registry now coordinates creation and retirement through a durable `ProviderOperation` record (states `intent` → `secret-created` → `committed`/`aborted`).
  - The provider id and secret name are fixed before any external write, and the idempotency key is scoped to the owner.
  - The doc spells out what happens on a crash at each step and on a lost response, and adds a reconciler that finishes or aborts unfinished operations and revokes orphan secrets.
  - A new `retiring` state means the registry can never show an `active` provider whose secret is already revoked. Phase 1 tests a crash at every one of these steps.
- **Dollar caps (skeptic must-fix):** the "cannot be exceeded" claim is replaced by worst-case reservation at admission and settlement afterwards. A model with no pinned price can't be admitted under a dollar budget, and a cancelled turn is charged its full reservation. Late usage reports and overruns are reconciled into the ledger. The doc now states plainly what the cap does and doesn't guarantee, and phase 2 adds matching tests.
- **Secret canary (skeptic must-fix):** the "zero copies" check now covers only stored or observable copies. It names the components allowed to hold the key briefly in transit and lists every system the check searches.
- **Key management page (ergonomist must-fix):** a new Providers page with usage, limit editing, Rotate key, and an immediate Revoke now. It is part of phase 3.
- **Should-fix items:**
  - The facets are now described as adapters over the existing `makeProviderBrokerGrantIssuer`. The doc explains why `makeOwnedProviderBrokerService` isn't reused directly.
  - The minion.town dialog is mapped onto the existing three-pane Add agent wizard (`chat-inventory-create-menu.md`).
  - Copyedits: "two-commit" became "two-step", and the "This bearer test was settled" antecedent is fixed.
- The ownership map table and prose are updated to match.

**Other files**
- **`designs/claude-bare-course-correction.md`:** two copyedits ("ruled out"; "for the duration of one `llm` pin interval").
- **`designs/README.md` (archivist must-fix):** added a dated totals paragraph: Proposed 32 → 34, indexed records 251 → 253. This adds the PR's two designs to the latest totals already in the README rather than recounting the whole table.

**Follow-up:** one point in the doc is still unconfirmed. The design says the existing grant issuer can serve Lal and Fae's in-process provider calls without the slice listener. I didn't check that in code; the doc leaves it as a phase 1 item to confirm, and if it fails the plan is to extend the issuer rather than build a second broker. The panel isn't re-run here; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1442222 cached reads)
- Output: 16276 tokens
- Cost: $1.2505164
- Wall-clock: 956s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
