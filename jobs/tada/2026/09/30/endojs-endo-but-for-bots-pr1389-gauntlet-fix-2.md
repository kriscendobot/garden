## Fix round 2: endojs/endo-but-for-bots PR #1389 (SturdyRef layer-1 shim contract design)

I applied the round-2 panel findings to `designs/sturdyref-shim-contract.md` and pushed them as one follow-up commit (`5f2f90ad36`) to `design/sturdyref-shim-contract` with `safe-push-pr-head.sh`. The push advanced the head from `55b47f7c5e` and did not rewrite history. CI is **GREEN**: `ci-wait-merge.sh --no-merge` returned 0 with 28 checks and none failed.

The panel's disposition was must-fix. Skeptic and pedant asked for changes; the other seats were comment-only or approve. I applied the findings that asked for changes and the should-fix items from the other seats:

- **Provenance (skeptic 1):** new section. The brand check only proves the ref was built by this realm's constructor, not who minted it. Minter provenance belongs to layer 5 (the CapTP side-table lookup) and layer 8 (daemon), and the Ownership Map has a row for it. Callers get a plain rule: enlivening a ref runs its minter's code.
- **Child-compartment claim (skeptic 3, critic 1):**
  - The claim now rests on SES source: `setGlobalObjectMutableProperties` in `global-object.js` fills a child compartment's globals from `universalPropertyNames`.
  - It is marked as believed until the build's test confirms it.
  - The #774 test becomes a characterization test that layer 2 flips.
  - I did not run SES to check it.
- **Pre-lockdown test row (skeptic 2):** narrowed to what layer 1 can test: `lockdown()` does not throw, the global is still there, and the constructor is frozen. There is no longer a claim that it "matches the permit shape".
- **Eval twins (skeptic 4):** the doc now says semantic drift between twins is accepted for layer 1. Any later semantic change must add a contract marker to the shape check.
- **Handler mutability (skeptic 5, critic 4, decomplector 3, ergonomist 5):** proposed answer is that the constructor does not harden the handler. Open questions 3 and 4 now point to each other so they are decided together.
- **Handler ownership (critic 3, skeptic 7):** the handler owns memoization and idempotence, and a thenable returned by the hook is assimilated.
- **Forward sketch (decomplector 1, critic 2, skeptic 6):** rewritten as one shared handler over one side table, so CapTP data lives once. Open question 7 no longer blocks layer 1, because a data-yielding hook would be optional and additive.
- **Readability and style:**
  - Named the `TypeError` rejection for a non-ref argument to `enliven`.
  - Added background on the handler pattern and a worked example.
  - Split the dense bullets.
  - Glossed "swiss number" and changed "revived" to "reintroduced".
  - The `@endo/ocapn` name overlap will also be noted in the package README.
  - Headings are now title case, matching the repo's other designs (pedant).

**Follow-ups:**
- The claim about what child compartments see still needs a real run in the layer-1 build.
- The panel-3 stage runs next; the driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1389-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1221895 cached reads)
- Output: 13199 tokens
- Cost: $1.084519
- Wall-clock: 1867s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
