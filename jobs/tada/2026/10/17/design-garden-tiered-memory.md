The design is written and landed, it has a draft review PR, and the classification of the existing memories went to the maintainer inbox for veto. No memory has been copied or pushed.

**What landed**
- `designs/garden-tiered-memory.md` plus an index row in `designs/README.md`, pushed straight to `main2` as commit 63dc4d85598.
- The design ends with three open questions, so I also opened a review PR: draft [kriscendobot/garden#125](https://github.com/kriscendobot/garden/pull/125). Its base is the frozen snapshot `main2-c2f25a3`, its head is `design/garden-tiered-memory`, and its diff is just those two files. The body carries the `<!-- garden-design-open-questions -->` marker, so no design panel should be staged for it.

**What the design specifies**
1. **Tiers.** The current host-local memory directory stays the private tier, and private stays the default. The shared tier is `memory/<slug>.md` on `journal2`, in the same frontmatter shape plus `shareable: true`, `updated` and `reviewed`. Its `README.md` index is generated from the files, never edited by hand.
2. **Write path.** `scripts/jobs/share-memory.sh` is the only way in, and it refuses on any failure:
   - a shape check: the literal `shareable: true`, the slug matching the filename, no `user`-type memories, and links only to other shared memories;
   - a secret scan with no override flag. It looks for token prefixes, cloud ids, high-entropy strings, email addresses, links to private repos (checked through the GitHub API), and private-matter words. It reports rule ids, never the matched text;
   - a per-file compare-and-swap against the version the writer read.

   Gardeners don't share memories themselves; they propose them under a `## Memory candidates` section in their report. A daily `memory-audit` schedule re-scans the shared tree and alerts. The leak runbook is: rotate the credential, then retire the file.
3. **Read path.**
   - The liaison reads the shared index as a third preflight step.
   - Gardeners get the index appended to their prompt by `worker_job_prompt` in `scripts/jobs/handlers/worker-common.sh`, capped at 6 KiB.
   - Two hosts editing the same fact: the second writer is refused and must re-read and merge.
   - Wrong or stale facts are deleted with `retire-memory.sh`; git history is the archive. Entries not reviewed in 60 days surface at muster.
4. **Doc changes** are spelled out for `roles/liaison/AGENT.md`, `roles/COMMON.md` and `CLAUDE.md`, plus a new `skills/garden-memory/SKILL.md`. These are not applied yet.
5. **Migration.** I classified all 81 memories: 49 shareable, 28 private, 4 needing a maintainer decision.
   - Of the 49 shareable: 6 need rewording to drop a private-repo reference, 10 are PR-status notes to re-check before migrating, and 1 is stale and should be retired instead.
   - **`kriscendobot/minion.town` is a private repo** (checked through the GitHub API), so all 12 minion.town memories are private.
6. **First shared entry.** `bearer-tokens-vs-ocaps` can't be copied as is: it cites minion.town PR #180 and links to a private memory, and the scanner would rightly refuse it. Section 6 of the design has a reworded version without those.

**Open questions on #125**
- Should the shared tier be a private repo instead? The scanner can catch secret-looking strings, but not facts that are sensitive in meaning. My recommendation is to start on `journal2`.
- Should there be a third, fleet-private tier, for facts about private repos like minion.town?
- Should a separate job audit what `journal2` already publishes (budget, usage and host data)?

**The inbox message.** The maintainer inbox is on the public `journal2` too, so message `20261017T080940Z-762fe4` keeps its reasons content-free and gives only a category for each private memory.

**Follow-ups**
- No build job is posted. The build (the two scripts, the audit schedule, the prompt hook, the doc edits, the new skill) should wait for the maintainer's answers on #125 and the vetoes on the classification. Migration then goes one fact at a time through `share-memory.sh`.
- `ironhorse-generator-tostringtag-fix.md` is in the private memory directory but missing from `MEMORY.md`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-garden-tiered-memory.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (2023514 cached reads)
- Output: 27060 tokens
- Cost: $1.8060867999999999
- Wall-clock: 352s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
