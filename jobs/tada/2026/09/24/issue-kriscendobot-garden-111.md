I answered dckc's two questions in a comment on issue #111 (https://github.com/kriscendobot/garden/issues/111#issuecomment-5815046465). I didn't change any files or policy, and I left the issue open for dckc to close.

**Where the policy lives:**
- The base rule is in `roles/COMMON.md` under "External-repo etiquette". Workers take no outward-facing action in any repo unless a maintainer authorized that specific action in the job.
- Per-repo exceptions are written in `journal2:projects/<slug>/README.md` under "Standing authorizations". So far only endo-but-for-bots has a blanket one.
- `endojs/endo` is stricter: changes reach it only through the ferry, run under kriskowal's identity.
- I explained that the upstream PR from issue #101 was allowed under the base rule, because dckc's own request counted as the authorization.

**Q1 (can the garden hold an exception for oros-ckm-data-readiness without mixing it up with other repos):** Yes, using the same per-repo file. Each exception names one exact repo, and endo and endo-but-for-bots already coexist with opposite rules. I was clear that this is written policy the agents follow, not something the code enforces. The `gh` wrapper fixes which account acts, but not which repo it can write to. I asked dckc to confirm how wide the exception should be before I record it.

**Q2 (attribution in the PR description):** Yes, and it's easy. Every job already records who asked for it, but PR #2 currently credits dckc only in a hidden marker. I offered two things:
- (a) edit PR #2's description now to add a "Requested by @dckc in kriscendobot/garden#101" line;
- (b) record that line as a standing rule for Oros PRs.

**Follow-ups, all waiting on dckc's reply:**
- Record the exception and the attribution rule in a new `projects/oros-ckm-data-readiness/README.md`.
- Add the attribution line to PR #2.
- Not handled here: on issue #101, dckc says @kriscendobot mentions don't work for them in practice, and asks why the mention in the upstream issue got no response. Those remarks look like a separate problem with the mention watcher, which this job didn't look into.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-111.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (374716 cached reads)
- Output: 4333 tokens
- Cost: $0.5815872
- Wall-clock: 52s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
