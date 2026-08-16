---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Encode the maintainer's new verb "pin the merge base" in the garden vocabulary and the comment-watcher recognizer.

Provenance (quote it in the docs): kriskowal, CHANGES_REQUESTED review on https://github.com/endojs/endo-but-for-bots/pull/282, 2026-08-16T06:28:34Z — "Please pin the merge base to llm-xxxxx and rebase. I will hereafter call this 'pin the merge base', leaving the rebase and resolution of conflicts implicit." Maintainer confirmed encoding it in the liaison session the same day.

Meaning: pin the PR's base to a NAMED FROZEN REF (the `llm-<sha>` form), then rebase onto it and resolve conflicts. The rebase and the conflict resolution are implicit in the phrase and must not need to be asked for separately.

DO NOT introduce a third redundant verb. Map it onto what already exists:
- `weave #N` already means "rebase and resolve conflicts" (README Key vocabulary, line ~85).
- skills/frozen-base-branch/SKILL.md already covers pinning to a frozen base ref.
"pin the merge base" is the COMPOSITION of those two. Decide and document whether it dispatches the existing weaver with a frozen-base parameter or warrants its own thin mapping, and justify the choice in the report; prefer reusing the weaver.

Work:
1. README.md § Key vocabulary — add the row, adjacent to `weave #N`, making the distinction from bare `weave` explicit (the base is pinned to a named frozen ref, not merely the current base).
2. CLAUDE.md § Orchestrator vocabulary — add it to the verb table there so the liaison recognizes it.
3. scripts/jobs/comment-watcher.sh — teach the recognizer the phrase in IMPERATIVE position, alongside BRANCH_OP_VERBS (line ~721) and the verb table around lines 760-830. It is a multi-word phrase, not a single token, so it needs care: the existing machinery matches single verbs and has explicit guards against verb-as-subject-matter and future-tense prose ("a subsequent rebase ... will"). Preserve those guards, and make sure "pin the merge base" as SUBJECT MATTER (someone describing the policy, as this very job does) does not mint a job.

This is a tested hot path. Extend the comment-watcher tests to cover: the imperative hit; the subject-matter miss; and no regression in the existing single-verb recognition or the distinct-imperative-verb counting.

Do not change what `weave`, `rebase`, or `retcon` already do.
