# PR #1248 review posted: object-capability discipline and formula patterns

I reviewed endojs/endo-but-for-bots#1248 at head `80985ceef0` and posted the review as a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1248#issuecomment-5805288498

kumavis asked for the review in comment 5805146255. The review covers object-capability discipline, formula durability and minimal delegation. It lists 2 high, 9 medium and 10 low findings, each with `file:line` and a suggested fix, plus a "done well" section. Nothing was executed; the findings come from reading the code only.

- **Preflight exit 2 was a false positive.** The only reply on the PR citing 5805146255 was our own "On it" acknowledgement (5805231160). No peer had resolved anything, so I went ahead with the review.
- **Method:**
  - I checked out the PR in an isolated project worktree from `ensure-project-worktree.sh` and ran three parallel read-only review passes: `daemon/src`, `hosted-agent/src`, and the sandbox adapters (claude, opencode, codex, sandbox).
  - I re-checked the two high findings by hand: the `inspect` leak via `readReferences` and `lookupById`, and the rw bind of `state.directory` in `restoreTranscript`.
  - `chat`, `floot`, `9p-server`, `platform` and `exo-stream` were only skimmed.
- **High findings (fix before merge):**
  1. The session owner's `inspect()` and `create()` return raw formula ids, and `lookupById` turns them back into live capabilities. That bypasses the `SessionClient` fence.
  2. The Claude native controller's `restoreTranscript` writes through a directory the guest can modify. A guest-planted symlink could make it write to any host path the daemon user can write.
- **Medium findings:**
  - Each session's broker dependency also holds operator powers, including unmetered `subscription()` and `resetRedeemer()`.
  - Backend modules run unconfined with all of `@agent`.
  - The credential caplet keeps the whole host for one lookup.
  - The Claude pool hands the broker the raw `SecretBlob`.
  - Caplet namespaces are guest agents rather than plain directories.
  - The hosted caplets run unconfined with no apparent reason.
  - `SessionOwner` is not a formula.
  - Session records are reachable through the host's pet-name tree.
  - A name is published before its formula is persisted.
- **Changes:** no code or garden changes. The only output is the PR comment.
- **Follow-ups:** none posted. The author (kumavis) or the maintainer can ask for a `fix #1248` on the high findings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1248-151c786d.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (662251 cached reads)
- Output: 10920 tokens
- Cost: $5.029839400000003
- Wall-clock: 327s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
