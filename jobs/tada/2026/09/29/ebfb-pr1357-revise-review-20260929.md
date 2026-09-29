## Completion report: ebfb-pr1357-revise-review-20260929

I revised PR https://github.com/endojs/endo-but-for-bots/pull/1357 to resolve all four of kriskowal's inline comments from review 5348050214. The work is one commit, `7a6d4259cf`, pushed to `design/endo-claude-inference-backends`. The PR is still a draft, and its head is now that commit.

**What changed in `designs/endo-claude-inference-backends.md`:**
- **Q1 (comment 4129919081):** Decision 5 now records option (b). The deployed root user runs on kriscendobot's subscription `setup-token`. The token is stored as a `SecretBlob` in the daemon secret manager and used under the `--bare` recipe.
  - **For now**, it goes into the process environment as `ANTHROPIC_AUTH_TOKEN`, the path the earlier probe showed working.
  - **Later**, the `@endo/hosted-agent` broker injects it, so the confined process only holds a short-lived lease. The broker currently refuses a subscription mode. A new gate 6 must first show that a forwarded subscription token authenticates through the broker and is billed against the subscription.
  - The earlier recommendation to use an API key instead is withdrawn.
  - I also noted that `@endo/claude-sandbox` injects `CLAUDE_CODE_OAUTH_TOKEN`, which `--bare` ignores. Decision 5 gives its time-boxed exception (review date 2026-12-08) a way to retire.
- **Q2 (comment 4129930579):** The assessment is split, and Decisions 9 and 11 are rewritten to match.
  - **The home-directory credential store does not force the OS slice.** Under `--bare`, Claude Code never reads the stored login. Each turn already gets a fresh, empty `HOME` and config directory, so several subscriptions on one host need no per-user home directories.
  - **The slice is required once more than one principal is involved, for a different reason.** Without OS isolation, all turns run as one Unix user. A defect in the binary could then let one guest's turn read another's environment, config directory or local listener. That exposes a raw credential under the environment-variable delivery, or a lease under broker delivery.
  - **Result:** guests who bring their own subscription or key need the slice plus broker delivery. Only the root's own turns may skip it.
  - **Secret store:** every credential is one `SecretBlob`, following the pattern in #1224 and #1120. Each backend instance is bound to exactly one credential. Guests' credentials come in through an intake the root runs, which gives the guest the admin facet so they can replace or revoke it. A new gate 7 tests two credentials running concurrently.
- **Q3 (comment 4129939009):** A new section defines `@endo/inference`, which names no provider. It has three layers: interfaces an implementation must satisfy, provider plugins, and enrichers that wrap an abstract backend. `@endo/claude` is the Claude plugin, and Codex and OpenAI backends are never called Claude. I updated the title, the ownership map (new secret-manager row), Decisions 1, 2, 7 and 8, and the phases.
- **Q4 (comment 4129942772):** Status is now "Draft, awaiting production evidence". A new § Evidence probe names the sibling job `ebfb-pr1357-inference-probe-20260929`. Its PR is marked *pending* because that job is still parked in `plan/` and hasn't opened one.
- **Other edits:**
  - Dependencies now include daemon-secret-manager, #1224, #1120, #1248 and the claude-sandbox exception.
  - The old Open questions became "Resolved questions", and one new open question was added: whether the secret store, which today has a single owner, is acceptable for guests' credentials.
  - `designs/README.md` now shows this design as Draft with an updated summary and estimate.
  - Style checks: no em-dashes, no Latin shorthand, and prettier passes.

**Replies:** each of the four inline threads has a reply that links the resolving commit (`discussion_r4130725970`, `…726251`, `…732878`, `…731654`). One reply post hit a network timeout and succeeded on retry.

**Follow-ups:**
- Once the probe job opens its draft PR, add the link to § Evidence probe. Its job spec already asks it to comment on #1357.
- Two design questions are still open and recorded in the document: the new open question about the secret store's single owner, and whether `@endo/inference` should relate to `@endo/hosted-agent`'s existing `HostedTurnBackend` session contract (listed under Known Gaps).
- I kept the filename unchanged so the review threads stay anchored to it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr1357-revise-review-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1966197 cached reads)
- Output: 28105 tokens
- Cost: $1.8125234
- Wall-clock: 332s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
