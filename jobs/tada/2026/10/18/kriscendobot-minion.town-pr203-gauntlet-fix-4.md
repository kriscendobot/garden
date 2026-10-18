# Gauntlet FIX round 4: kriscendobot/minion.town PR #203

I applied the panel-4 must-fix items to the PR and pushed them. CI came back green: `ci-wait-merge` returned rc 0 with 3 checks and 0 failures. As the job asks, I did not re-run the panel.

**Source:** the latest panel verdict was review 5564834460, a bot-authored comment headed "Must-fix before merge". No pre-pass block was attached to the job. The must-fix items came from skeptic, decomplector and novice. I also took the should-fix items from critic, skeptic, ergonomist and copyeditor.

**Pushed:** one follow-up commit, `04e403b3`, to `design/git-remote-s7-bearer-identity-test` through `safe-push-pr-head.sh --mode advance`. It advanced the head from `0e41474e`. It rewrites the bearer-secret and control-plane block of § 7 in `designs/git-remote-capability.md`:

- **`/hello` dropped** (skeptic 1, critic 1, decomplector 3):
  - It made every stored hash a key that could answer the challenge, and it did not tie later requests to the listener that answered.
  - The listener is now a unix-domain socket in a directory only `minion-git-remote` can write. On TCP, the listener serves TLS and the caplet pins its public key.
- **Why a listener at all** (decomplector 1): a new paragraph says why the design doesn't use a CapTP reference (it would break the § 10 / Increment 1 isolation) or the capability-URL alone (that URL cannot mint or revoke).
- **Partition lifecycle** (decomplector 2, skeptic 3, critic 3):
  - Creation now happens inside `/open`, which runs only after the daemon has persisted the formula. There is no `/create` route, no *pending* state and no orphan timer.
  - Quota is enforced per caplet, and the section says how an operator reclaims partitions the daemon has dropped.
  - Restoring the store from an older snapshot brings a partition back empty. The section states this plainly.
- **Secrets** (skeptic 2, ergonomist 1–2):
  - Each secret is now created alongside its object, and the listener keeps only hashes and never returns a secret. This removes the contradiction where the listener had to return a key it stored only as a hash.
  - "Facet opener" is renamed to facet key, and the separate per-view key is gone.
  - The section now says why handing the guest a raw partition key does not widen what it holds (critic 2).
- **Readability** (novice 1–5):
  - A short overview of the whole flow now comes first.
  - Formula, allocator and facet are defined.
  - The bearer test is walked through for two cases.
  - Each lifecycle step names the route it uses.
  - The sub-cases are now separate paragraphs.
- **#180** (critic 4, skeptic 4–5, novice 3):
  - #180 is summarized and pinned at `3b5fd6e2`, and the section now says it governs #180's rebase.
  - It adds a list of conformance checks.
  - The maintainer's test is restated as the design's own criterion.
- **Copyedits** (copyeditor 1–5, 8): bearer secret is glossed in the opening, the "Value crossing" column is defined, the "lost write" heading now matches its body, the store-records list is complete, and a bridge sentence leads into the caveats.

**Checks:** the orthographer and thesaurus greps found 0 candidates, and the added lines contain no em dashes or other hard-to-type characters.

**Follow-ups:** the driver posts panel-5. This is a substantive redesign of the control plane (socket binding, creation folded into `/open`, fewer secret kinds), so #180's rebase will need to follow it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr203-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (2000031 cached reads)
- Output: 19450 tokens
- Cost: $1.5019981999999994
- Wall-clock: 1196s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
