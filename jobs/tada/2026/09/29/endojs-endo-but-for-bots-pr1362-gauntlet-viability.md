**Viability report: endojs/endo-but-for-bots#1362** (`feat(npm-registry-server): serve staged development releases over the npm protocol`)

The PR is open and still a draft. It was created on 2026-09-29, less than an hour before this check. It has no reviews or discussion comments yet. Its head sits on the frozen base `llm-3aa902d`.

Deciding question: Does `llm` still lack an npm-protocol registry server for staged dev releases, with the design that motivated this PR (#1361, `designs/npm-dev-registry-serving.md`) still live? **Yes.**

Evidence:
- **Base history:** comparing `3aa902d...llm` shows `ahead_by = 0`. `llm` has gained no commits since the PR's base was pinned, so nothing newer can have displaced it.
- **No competing code:** `packages/npm-registry-server` does not exist on `llm`. The only npm or registry package there is `@endo/exo-npm`, which is an `EndoRegistry` exo capability and version resolver used when the daemon worker loads packages. It is not an npm-protocol HTTP registry.
- **No competing PR:** searching the repo for `npm-registry-server` returns only #1362 itself and its design PR #1361. The nearby PRs are different work: #1117 (package registries as directory trees) is something #1362 builds on, and #890 (npm dev-publishing design, merged) is earlier groundwork.
- **Premise still holds:** design #1361 is open, still a draft, and has no reviews that reject or redirect it. The deployment #1362 is for (`npm.minion.town`, via the companion minion.town PR) is still pending.

The gauntlet may proceed. No clean, panel, fix, CI-wait or un-draft budget was spent.

Note for the panel: the PR says it diverges from the design in one way. Its HTTP adapter reads versions straight from its own tables and content store rather than through the directory-tree interface, because that interface (#1117) has not landed. The design only allows a temporary adapter if it is written against that interface, and this one is not.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (220453 cached reads)
- Output: 1765 tokens
- Cost: $0.42442260000000004
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
