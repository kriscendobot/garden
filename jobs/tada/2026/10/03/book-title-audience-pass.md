**Completion report: book-title-audience-pass**

The book is retitled and every chapter has had the audience pass. It's all in one draft PR: **https://github.com/kriscendobot/garden-book/pull/3**. Nothing was built or published.

**Title.** The new title is **"Better Code and Gardens"**, the maintainer's suggestion. I tried others ("Tending the Fleet", "The Self-Weeding Garden", "Agents in the Garden"), but this one is the shortest, plays on a title readers already know, and names both halves of the subject. It is changed in all three places:
- `build/intro.html`'s title page
- `build.py`'s `<title>`
- `build.py`'s sidebar nav

I also rewrote the title page's edition note to describe this revision. In `build/README.md`, the edition history has a new "Pending (not yet published)" entry at the top; the older editions are still listed.

**Audience pass.** All ten chapters were read in full: I split them across six parallel editing agents and then reviewed the combined diff. The changes add 125 lines and remove 107 across 8 chapter files.
- **The maintainer's decisions:** present-tense credits to "the maintainer" or kriskowal are now dated history attributed to "the original instance's maintainer". Examples include the coinage of the verbs "pin the merge base" and "retcon", the orchestration pattern, the gauntlet reversal, the bid-market directive, and the Ironhorse delegation. All citations, links and dates are kept.
- **"Today" and "currently" lines:** in chapters 1, 4, 5, 6, 8 and 10 these read like live status reports. Examples are budget pools, the backoff fraction, worker leveling, the AWS account and access level, and quota routing. They now say "on the original instance, at the time of writing".
- **"You":**
  - It stays where it means a reader running their own instance, which is most of chapters 3 and 4.
  - Where it implied the reader was kriskowal, it changed. Examples are "ferries … under **your** identity as maintainer" and "maintainer (`kriskowal`)".
  - Chapter 3 now has a short note saying who "you" means.
- **Leftovers from the original writing jobs:** lines like "The job asked this chapter to say plainly…" and "The chapter is complete… written in three cycles" are removed.
- Chapters 2 and 9 needed no changes; they already describe the maintainer as a role.

**Deviation from the brief.** The PR's base is the snapshot branch `main-bab8e7b`, not `main` as the job asked. `ensure-pr.sh` refuses a moving base, and PR #1 uses the same snapshot. Whoever merges it will need to target `main`.

**Follow-ups:**
- **Chapter 2 claim:** chapter 2 says "(This chapter was landed that way.)" about committing directly to the journal. That may no longer be true now that the book lives in its own repo. I left it for an editorial decision and flagged it in the PR body.
- **Overlap with other PRs:** this PR touches the same chapter files as the open draft PRs #1 (copy-edit) and #2 (design pass), so they will probably conflict. Sorting that out belongs to the final integration job.
- **Rate limit:** the bot account hit a GitHub rate limit while I opened the PR, even though `gh api rate_limit` showed almost the full quota. It cleared after about 4 minutes of retries.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-title-audience-pass.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1632660 cached reads)
- Output: 10679 tokens
- Cost: $4.7620712
- Wall-clock: 504s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
