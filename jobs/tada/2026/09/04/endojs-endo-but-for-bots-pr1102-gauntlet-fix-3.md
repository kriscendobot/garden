CI is GREEN (rc 0, 5/5 checks passed, 0 failed).

## Completion report

**Job:** endojs/endo-but-for-bots PR #1102 — gauntlet FIX round 3 (design PR: `introduced-special-names.md`).

Re-derived state from a clean worktree: the PR head (`kriscendobot:design/claude-agents-capability`) sat at `a1f172b20` with no fix-3 commit yet; panel-3 had posted a unanimous request-changes verdict (2026-09-04T10:51:13Z) with seven seats reporting.

**Applied the panel's must-fix and should-fix items** in one follow-up commit (`759730ee1`), each grounded against the cited source before writing:

- **Idempotency comparison** (critic/skeptic/decomplector/ergonomist/novice): replaced "byte-identical to the persisted map" with an order-insensitive comparison of the resolved `{destination -> identifier}` set; documented the omitted-option bare-reacquire no-op (the dominant `provideGuest(name, {agentName})` restart shape) and the rebind-rejects / rename-succeeds consequences.
- **Closed-set premise false** (skeptic/decomplector): the embedder-supplied `specials` keys spread via `...platformNames` (`host.js:505`) are unvalidated; added a Phase 1 assertion keeping the reserved prefix off both the daemon-owned and `specials` sets, making invariant 2 structural rather than a promise.
- **Indelibility mechanism** (ergonomist/skeptic/critic): dropped the nonexistent `NameHub.write`, stated the full write surface (`storeIdentifier`/`storeLocator`/`move`/`copy`/`remove`/`rename`), and re-anchored the guarantee to the name grammar (`assertValidName`/`isValidName`, `pet-store.js`) instead of `makePetSitter`.
- **#982 / `@main` honesty** (critic/novice): the reserved prefix cannot bind bare `@main`; marked #982 partially addressed with the `@main`-override as separate work.
- **Revocation direction** (critic/skeptic/decomplector): stated that `thisDiesIfThatDies` makes destroying the introduced id cancel the whole agent, and that a caretaker forwarder must be neutered, not destroyed.
- **Persistence label** (critic/skeptic/novice): removed the false `'petName'` data-carrying-label precedent; specified one `[label, identifier]` pair per binding, matching `extractLabeledDeps`'s shape.
- **Pinned the prefix** to `@intro-` (RFC 6648 rationale over `@x-`), stated at the first example, with `validSpecialNamePattern` cited and the recipient `list` enumeration path added.
- **Mechanical** (copyeditor/pedant): zero em-dashes and zero `→`, full citation paths, no Latin shorthand, added a Dependencies section, noun-phrase title, all lines ≤100 cols; fixed the two flagged README modifier/antecedent slips.

Pushed as a review-feedback follow-up (`safe-push-pr-head.sh`, advanced `a1f172b20b → 759730ee14`). Watched CI bounded: **GREEN** — 5/5 checks, 0 failed.

Stopped here without re-running the panel, as instructed (the driver re-posts panel-4).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 58 tokens (1984599 cached reads)
- Output: 24442 tokens
- Cost: $2.4506155
- Wall-clock: 870s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
