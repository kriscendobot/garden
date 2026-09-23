---
ts: 2026-05-14T00:39:04Z
kind: result
role: conductor
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/14/003700Z-dispatch-steward-41ae71.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source
---

# Conductor stall: PR #228 — token lacks `workflow` scope

PR #228 (`chore/security-md-uniformity` → `llm`) verified ready to merge:

- state=OPEN, mergeable=MERGEABLE, mergeStateStatus=CLEAN, reviewDecision=APPROVED.
- Head `5dc745be20f9f26dabb34e370595f13ae351fb33`; base `llm` tip `b21f63b9802e1169044b98501e15067a350b2b75`.
- CI: 28/28 SUCCESS, 0 failures, 0 in-flight.
- Cluster shape: two commits (`9ce7cbf7` chore: align SECURITY.md, `5dc745be` ci(scripts): check-security-md.sh + lint-job step). Already coherent; no fixups to absorb.

Per conductor loop step 5 I attempted:

```
gh pr merge 228 -R endojs/endo-but-for-bots --merge --delete-branch
```

GitHub rejected with:

```
GraphQL: refusing to allow an OAuth App to create or update workflow
`.github/workflows/ci.yml` without `workflow` scope (mergePullRequest)
```

`gh auth status` confirms the active account is `kriscendobot`, scopes `admin:public_key, gist, read:org, repo`; `workflow` scope is missing. The PR's second commit modifies `.github/workflows/ci.yml` (adds a lint-job step that runs `check-security-md.sh`), which puts it in the workflow-touching class of mutations the bot's token cannot perform.

This is a credential-class block, not a PR-class block. Per conductor norms ("Reject (... branch protection): stall `merge blocked: <gh error>`"), I am stalling with reason `merge blocked: oauth token lacks workflow scope`. The merge itself is unblocked from every other angle.

## What unsticks it

One of:

1. The maintainer (kriskowal) merges the PR under their own identity, which presumably carries the `workflow` scope. The PR's merge-commit shape will then be GitHub's default merge (the repo settings `merge_commit_title=PR_TITLE, merge_commit_message=PR_BODY` documented in `journal/projects/endo-but-for-bots/README.md` already encode the desired shape, so a direct `gh pr merge --merge` from kriskowal yields the same artifact a conductor would have produced).
2. The bot's gh token is re-authorized with `workflow` added to the scope list, and a fresh conductor dispatched. This is the more durable fix: future workflow-touching PRs from the LLM/garden flow are not rare (CI changes for #148, the steward's autonomy work, etc.), and re-hitting this stall on each one is friction.

I lean toward (2) as the durable fix but make no recommendation that runs ahead of the maintainer's preference; both options are visible to the liaison via the message companion to this entry.

## State at stall

- PR #228: OPEN, no autoMergeRequest set, branch `chore/security-md-uniformity` intact (no `--delete-branch` since the merge command failed before deletion).
- No comments posted (the failed merge does not constitute a comment; the per-action authorization in the dispatch covered the merge and a optional merge-complete comment, neither of which became real).
- Dispatch root untouched; ready for the steward's teardown on my return.

Self-improvement: the conductor role's *Loop* step 5 reject-stall list is currently `mergeable=BLOCKED | missing reviews | branch protection`; a credential-class GraphQL refusal (OAuth scope missing) is not in that list and the role file's only matching catch-all is "Repo auto-merge unavailable" (a different error). One sentence under step 5 naming the `workflow`-scope class explicitly (and pointing the conductor at the journal `message`-to-liaison route rather than the parent Monitor route, since CI green-wait will not change the scope) would tighten the stall reason next time. Logged as a gardener-touchable lesson; not urgent.
</content>
</invoke>