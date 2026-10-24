## Completion report: endojs/endo-but-for-bots#1367 fix

I fixed the round-3 design-panel findings on PR #1367 and pushed them. The PR is still a draft and CI is green on the new head `fcf06700e6`. I didn't merge, un-draft, or change authority.

**Why the gauntlet halted:** the round-3 panel finished with 20 must-fix items, but posting its review to GitHub failed with a GraphQL error. The panel step failed three times, used up its retries, and the gauntlet halted. The full findings file stayed on the other host. I worked from the journal's panel-run record and the gauntlet-halt summary, which cut each finding short, and checked each one against the code.

**What I changed** (2 commits on `design/daemon-git-remote-capability-urls`):
- **3950771125, the design doc.** The decomplector was right on both points, and I confirmed each in the code:
  - **New `provideGitClone` option dropped.** The existing host-side controller can already make a cloned remote fetch-only: `getGitRemoteController(remote).setAllowedDirections(['fetch'])`. The change is saved with the remote's stored state, so it survives a restart. The worked example, diagram, plan and tests now use that call.
  - **New `provideGitCapabilityCredential` host method dropped.** In its place is a pure `splitGitCapabilityUrl` helper in `@endo/exo-git`, whose output goes to the existing `provideBasicCredential`. The full token-bearing URL never crosses CapTP, and Open question 3 now records why the compound method was rejected.
  - **A false claim corrected.** The redaction section said the remote's audit log hadn't landed. It has (`GitRemoteController.audit()`), so the redaction test now checks it too.
  - **Copyediting.** "Client half" is now used consistently, the restart paragraph is rewritten, and the "half right" phrase is gone.
- **fcf06700e6, `README.md` and `daemon-git-remotes.md`.** The index entry and M3 row now describe the smaller slice. I fixed the unclear pronouns in the M3 narrative. The status-totals sentence now says the twelve named buckets hold 254 records and three qualified records bring it to 257. The new `daemon-git-remotes.md` text is wrapped.
- **PR body.** The size check fired at 539 words, so I rewrote it to the template at under 300 words. The template check passes.
- **Checks.** The pre-push probes are clean, every Mermaid diagram parses, and CI is green.
- **Summary comment** posted: https://github.com/endojs/endo-but-for-bots/pull/1367#issuecomment-6387069131

**Follow-ups:**
- The cut-off summaries only included the copyeditor and decomplector findings. Whatever the integrator, pedant, pruner and skeptic seats raised in round 3 couldn't be recovered here. I covered what I could see: the PR-body template and size checks, line wrapping, and the redaction boundary.
- The gauntlet is still marked halted. A fresh panel round (`run the gauntlet #1367`) is the next step and should check the narrowed design.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `8b5bc8a3b7b1fe3c2cb544df6e9b2c4fd0c63903`; this job presented `fcf06700e69fe1b54e4cbc7dc9a5fd7af78ed3fc`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1367-fix-20261024.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3788761 cached reads)
- Output: 23037 tokens
- Cost: $2.1266841999999997
- Wall-clock: 800s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
