Done.

## Completion report

**Job:** improve-gardener-suppress-happy-path-progress

**What I did:** Gated both happy-path `journal-entry.sh progress` calls in `scripts/jobs/gardener.sh` behind a new opt-in `GARDEN_GARDENER_VERBOSE` env flag (default off), making the success path silent.

**What changed (one commit, pushed to `origin/main2`):**
- The `claimed job` progress line (~108) is now wrapped in `if [ -n "${GARDEN_GARDENER_VERBOSE:-}" ]; then … fi`.
- The `completed job` progress line (~147) is likewise gated.
- Replaced the inline comment "narrate progress into the journal (garden practice)" with a silent-until-error rationale: explains that the claim/complete pairs were the dominant fleet journal volume, that the durable record is the completion `result` entry, that the failure path captures output by hash + escalates to the gardener inbox, and that `GARDEN_GARDENER_VERBOSE=1` opts the narration back in.
- The failure-escalation path and the completion `result` report are untouched.

**Process:** Built in an isolated worktree off `origin/main2` (per the shared-tree concurrency rule), `bash -n` syntax-checked clean, committed under the `endolinbot` bot identity, pushed `HEAD:main2`, and removed the worktree.

**Follow-ups:** None. Existing deployments pick this up on the next deliberate deploy; no migration needed since the flag defaults off and the only behavioral change is suppression of two non-diagnostic lines.
