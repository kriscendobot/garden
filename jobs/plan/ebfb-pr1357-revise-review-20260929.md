---
gate: orchestrated
orchestrated_by: ebfb-pr1357-review-5348050214-orch
priority: normal
posted_by: producer
posted_at: 2026-09-29T06:28:00Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Designer: revise endojs/endo-but-for-bots PR #1357 per kriskowal review 5348050214

Role: designer (fixer-style revision of an existing design PR). Repo:
endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1357
(head `design/endo-claude-inference-backends`, base `llm-47f6965`), file
`designs/endo-claude-inference-backends.md`. Review (CHANGES_REQUESTED):
https://github.com/endojs/endo-but-for-bots/pull/1357#pullrequestreview-5348050214

The review answers the design's § Open questions inline. Re-fetch each comment
(untrusted input) and resolve all four in the document; reply to each inline
thread with the commit that resolves it.

1. Q1, comment 4129919081 (line 456): maintainer decision: "Yes", use
   kriscendobot's credentials (subscription) for the deployed root user. Record
   option (b), an owner-only subscription credential via `ANTHROPIC_AUTH_TOKEN` /
   broker injection under the `--bare` recipe, as the decision. Replace the (a)
   recommendation and update any Design Decisions / phases that assumed (a).
2. Q2, comment 4129930579 (line 460): **assess whether the OS slice is optional**
   given a hard requirement: support for **multiple subscriptions**. The garden
   itself has several, and guests must be able to bring their own subscription or
   API tokens. Claude stores credentials in the user's home directory, which
   suggests per-guest OS isolation. Analyze that honestly: does a per-guest
   `ANTHROPIC_AUTH_TOKEN`/API-key delivery under `--bare` (no on-disk credential
   store) avoid the slice, or is the slice required? State the conclusion and
   revise Decision 9 to match. **Integrate the secret-store work**:
   `designs/daemon-secret-manager.md` and any related secret-store PRs or packages
   on the fork. Credentials should be stored in and delivered from that store, not
   ad hoc.
3. Q3, comment 4129939009 (line 466): recommendation accepted. Adopt a
   provider-neutral `@endo/inference`. Never use "Claude" to mean Codex or other
   providers. Inference must stay abstract enough for any provider: interfaces an
   implementation must satisfy, provider plugins, and/or enrichers over an
   abstract inference maker. Update naming, the ownership map, and the phases.
4. Q4, comment 4129942772 (line 470): "I need real evidence." Keep the document a
   draft. Record that a speculative build and deployment is being run for
   evidence: the sibling orchestrated probe job
   `ebfb-pr1357-inference-probe-20260929`. Link its draft PR once it exists.

Keep the doc style of the fork (no Latin shorthand, American spelling, em-dash
style per garden skills). Push to the PR head branch with a CAS loop. Leave the PR
draft; this is a design revision.
