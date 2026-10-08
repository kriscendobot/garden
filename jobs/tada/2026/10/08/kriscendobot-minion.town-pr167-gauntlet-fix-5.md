Fix round 5 for kriscendobot/minion.town#167 is pushed and CI is green (3 of 3 checks, `ci-wait-merge` rc 0).

The panel's round-5 review was must-fix on c764d6f. I pushed one follow-up commit, `f155401`, to `design/root-canary-principal` with `safe-push-pr-head.sh`. It changes only `designs/root-canary-principal.md`.

- **Pedant must-fix (relative paths):** repo paths are now written relative to `designs/`. Files that already exist are links: `../src/auth/verifier.ts`, `../src/http.ts`, `../src/endo/git-remote/`, `../deploy/aws/systemd/minion-mcp.service` and `../deploy/aws/npm-registry/README.md`. The `root-canary-*.sh` scripts don't exist yet, so they are plain code with the `../deploy/aws/scripts/` prefix. Pedant's other note is fixed too: `per-\`iss+sub\`` is now `the \`iss+sub\` limit`.
- **Copyeditor should-fixes:** A8 now says Cognito issues the refresh token and the client requests the scopes. "Silently goes dark" is replaced with a plain statement that an unanswered re-mint reminder leaves the canary stopped without anyone noticing. The awkward "are premises A2, A8, and A9" sentence is reworded.
- **Critic and skeptic should-fixes, which overlapped:**
  - The A2 fallback no longer suggests `AdminLinkProviderForUser`, which can't merge a federated identity that already has its own user. It now says to delete the stray pool user and re-run the sign-in.
  - § 2.0 now says plainly that a failure of A1 (after the `openid` retry), A2, A3 or A8 stalls the design until the maintainer answers open question 1.
  - Build scope item 0 runs A2 first, before any IAM or secret work.

The remaining comment-only and should-fix items from critic, skeptic, decomplector, ergonomist and novice are not addressed. They include the script contracts, the A10 premise about the thunk's `redirect_uri`, the per-host-class blast radius, and the front-loaded vocabulary. Panel-6 can pick them up if it raises them again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (830798 cached reads)
- Output: 5127 tokens
- Cost: $0.7447476
- Wall-clock: 371s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
