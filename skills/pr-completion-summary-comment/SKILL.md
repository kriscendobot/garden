---
created: 2026-06-25
updated: 2026-06-25
author: gardener
---

# Skill: pr-completion-summary-comment

After pushing work to a PR in response to a maintainer directive, a review, or feedback, the doer **must** post a top-level summary comment on the PR. This is the human-readable acknowledgment that closes the loop on the PR conversation. It is REQUIRED, not optional: inline thread replies and a silent push are not enough.

## Why

Maintainer feedback on PR #474 (2026-06-25): the fixer posted the four inline Copilot-thread replies and pushed the fix, but posted no after-the-fact summary comment. The maintainer expected one: "there simply wasn't a summary posted after the fact ... I expect feedback on the PR in general." Inline replies live on individual threads and the maintainer has to re-walk the diff to reconstruct what happened across all of them. A top-level summary is the single place the PR conversation carries a coherent account of the work.

This is distinct from, and in addition to, the per-thread inline replies in [`../pr-review-thread-replies/SKILL.md`](../pr-review-thread-replies/SKILL.md) and the fix-up commit discipline in [`../review-feedback-followup-commits/SKILL.md`](../review-feedback-followup-commits/SKILL.md). Those skills already name the top-level summary as their close-out step; this skill is the canonical statement of what that summary must contain and that it is mandatory.

## When to post

After any push that responds to feedback on an existing PR: a fixer addressing a review, a weaver explaining a non-trivial conflict resolution, a shepherd reporting CI driven to green, a conductor noting a merge outcome, a botanist rendering a dependabot verdict, a builder pushing follow-up work to a PR that is already under review. Not required for the initial draft-PR open, whose body is itself the opening summary.

## The comment shape

One top-level comment (`gh pr comment <N>`, or `POST /repos/<owner>/<repo>/issues/<N>/comments`) that carries:

- **Head SHA.** The exact commit the summary describes, so a reviewer reading later knows which state the account refers to.
- **What changed.** A short, behavior-over-diff account of the work: which items were addressed and how, each mapped to its addressing commit SHA when there is a commit per concern.
- **What was declined and why.** Any item not addressed, with the reason (out of scope, deferred to a follow-up PR, verified-no-change-needed with the proof). Silence on a declined item reads as an oversight.
- **Verification status.** Tests / lint / types: green, red-with-reason, or not-yet-run with the run URL when available.

Keep it scannable. A bulleted item-to-SHA map plus a one-line verification status is the floor; prose paragraphs only where an item needs explanation.

### Per-section provenance for an aggregated summary

The gh wrapper appends **one** whole-body provenance footer (model · harness · provider · deployed-garden sha) to the end of any comment the fleet posts (`scripts/jobs/comment-provenance.sh`). That is correct for a summary written entirely by the posting doer. But when the summary **stitches together sections contributed by different roles/jobs over the PR's lifetime** — each potentially produced by a different model/harness/provider than the composing process — a single whole-body footer misattributes every section but one.

For that case, footnote **each contributed section with that section's own facts**, in the same `<sub>…</sub>` style, using the section renderer from `comment-provenance.sh`:

```sh
# resolved facts of the SECTION's author (harness/provider are the resolved names):
provenance_footnote "<model>" "<harness>" "<provider>"
# or, from a worker kind (resolves harness/provider for you):
provenance_footnote_for_kind "<model>" "<worker-kind>"
# a section produced deterministically (no LLM):
provenance_footnote "" "" "" 1        # → "model automatic"
```

Append the returned line immediately after its section, before concatenating the next. Section footnotes carry a distinct marker (`PROV_SECTION_MARKER`) that does **not** suppress the closing whole-body footer, so the assembled comment carries a footnote per section **and** the single closing footer naming the composing process and the deployed garden sha. A reader can then tell, section by section, which model/harness/provider (or automatic) produced it. A section whose facts do not resolve simply carries no footnote (fail-open) — never a wrong one. This mirrors the panel review's per-seat footnotes (`scripts/jobs/gardening/panel.sh`, [`../panel-review/SKILL.md`](../panel-review/SKILL.md)).

## Authorization

Posting a comment on an upstream PR requires the per-action authorization the job carries (see [`../../roles/COMMON.md`](../../roles/COMMON.md) § External-repo etiquette). On `endojs/endo-but-for-bots` the standing comment authorization (per `journal/projects/endo-but-for-bots/README.md` § Standing authorizations) covers it, so the summary is unconditionally required there. On any other repo, when the job does not carry the comment authorization the doer records the summary in its completion report and surfaces the gap over the message bus rather than posting under the bot identity; the orchestrator posts it. The summary is not skipped, only relocated.

## Output

One top-level summary comment on the PR (or, when posting is unauthorized, the same content in the completion report for the orchestrator to post). The PR conversation carries a coherent, SHA-anchored account of the work in addition to any inline thread replies.

## Pitfalls

- **Inline-only.** Replying on each thread but posting no top-level summary is the exact gap #474 surfaced. Both are required.
- **Silent push.** A push with no comment at all leaves the maintainer to diff the branch to discover what happened. Never the answer when responding to a directive.
- **Omitting declines.** A summary that lists only the addressed items and stays silent on the declined ones hides the decision the maintainer most needs to see.
- **Quoting.** Bash heredocs and `-f body=` interact poorly with backticks; escape SHAs and code spans or use `--field` with a here-string, per the same pitfall in [`../pr-review-thread-replies/SKILL.md`](../pr-review-thread-replies/SKILL.md).
