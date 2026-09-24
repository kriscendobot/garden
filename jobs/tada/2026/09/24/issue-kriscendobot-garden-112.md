I answered dckc's issue kriscendobot/garden#112 with a researched comment (https://github.com/kriscendobot/garden/issues/112#issuecomment-5817418958). The issue stays open for the submitter to close. The comment says up front that it is not legal advice.

**The lex/yacc line:** the U.S. Copyright Office's January 2025 report says a human is the author only where they decided the expressive elements of the output. It found that prompting alone does not meet that bar. So "one person requested it and approved it" probably doesn't make them the author of the machine-written parts. Their edits, their design text (where it shows up in the result) and their selection and arrangement can still count. The UK's rule for computer-generated works is different, and the comment notes that. The practical problem for an Apache-style CLA is that the contributor is asked to grant a license and to state the work is their "original creation", which doesn't fit material nobody owns.

**Question 1 (endo):** I checked the `endojs/endo` repo and its history directly.
- **What's documented:** endo is Apache-2.0. The only copyright statement is the collective "Endo contributors". There is no CLA, no sign-off check (DCO), no NOTICE file, and nothing about copyright in CONTRIBUTING, the PR template or AGENTS.md. Each contributor licenses their work under Apache-2.0 §5 and keeps whatever copyright they have.
- **What practice shows:** it is mixed.
  - Some commits have Copilot's bot as the author, with kriskowal as co-author.
  - About 60 maintainer commits carry `Co-Authored-By: Claude` trailers.
  - Work the garden ferries to endo goes the other way: the ferry rewrites every commit's author to kriskowal and strips all AI trailers and bot text from the PR.
- **Inference:** ferried work shows up as kriskowal's, and nothing in the history records that an AI wrote it. Most of the policies I found would count that as a disclosure gap. I left whether to change the ferry for @kriskowal and @erights to decide.

**Question 2 (other projects):** the comment has a table of projects that have a CLA (or similar) and accept AI-assisted work, with sources:
- **Apache Software Foundation:** allowed under conditions; asks for a `Generated-by:` line in the commit message.
- **OpenSSL:** amended its CLA in June 2026 so contributors don't claim to own uncopyrightable AI output and must disclose AI use; requires an `Assisted-by:` trailer.
- **Kubernetes:** bans AI co-author and `Assisted-by`-style trailers because "the AI cannot sign a CLA", but requires disclosure in the PR description.
- **OpenInfra/OpenStack, Fedora and CPython:** all accept AI help and hold the human submitter responsible.
- **Linux** is included for comparison: it uses sign-off (DCO) rather than a CLA.

The common ground is that a human signs and answers for the work, and AI use is disclosed. No policy covers dckc's case, where several humans who directed the bots each claim copyright on approval.

The comment ends with a suggested starting point for Oros: an Apache ICLA with OpenSSL-style clauses, a visible `Requested-by` line, an `Assisted-by` trailer, and a human who has signed the CLA approving on the record.

**Follow-ups (not posted as jobs):**
- **Oros convention:** if dckc wants it, it would be written into the Oros project notes in the journal (`projects/oros-ckm-data-readiness/README.md`), the same place discussed in #111. The reply is waiting on them.
- **Ferry question:** whether the ferry should add an AI-disclosure line to PRs it carries upstream, instead of removing all AI attribution, is a policy call for the maintainers.

No garden files changed and nothing was committed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-112.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (894744 cached reads)
- Output: 11348 tokens
- Cost: $1.1380118000000001
- Wall-clock: 159s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
