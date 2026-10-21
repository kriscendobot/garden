**Gauntlet viability for https://github.com/endojs/endo-but-for-bots/pull/1518: overtaken (do not run the gauntlet)**

The PR is a probe, so it should stay a draft and never enter the gauntlet. It should not be closed either. I spent no clean, panel, fix, CI-wait or un-draft budget.

- **PR facts:** It is open, unmerged and a draft. The title is "test(browser): probe WebKit suite coverage (gap-revealing prototype)". The head is `probe-endo-webkit-testing-20261021` at `8f4c30be3ad`, and the base is `master-6ee3fda`.

Deciding question: Is https://github.com/endojs/endo-but-for-bots/pull/1518 still a change meant to be cleaned, reviewed by a panel and taken out of draft for merge, rather than a probe meant to stay a draft?

Evidence:
- **It was built as a probe.** Its title says "gap-revealing prototype". The job that produced it was `probe-endo-webkit-testing-20261021`, and its report is in `jobs/tada/2026/10/21/`.
- **The probe's job is done.** The PR body is a report of four gaps, each ending in "Maintainer's call: design revision" or an implementation-time choice. The bot's completion comment says "next: draft remains for maintainer design review".
- **Probes don't get a gauntlet.** Under the garden's rules, a probe PR stays a draft and no fix, panel or un-draft steps follow it. Running the gauntlet would un-draft a prototype that the PR body itself says "should not be cited as broad Safari or package support".
- **The gauntlet was started by mistake.** The gauntlet record says `created_by: design-pr-gauntlet-coverage-audit`. That script has a check meant to skip probe PRs (`design-pr-gauntlet-coverage-audit.sh:247`), and the title should have matched it. I didn't find out why it slipped through.
- **Nothing has replaced it.** There are no reviews and no newer PR on WebKit testing. The probe's report is still current and is waiting for the maintainer to decide on its four gaps.

Option: close as superseded

The line above is required for an overtaken result, but don't act on it. The right move is to leave the draft open for the maintainer to answer the four design questions. If the maintainer later wants this probe turned into a real PR, they should ask for that with `run the gauntlet #1518` or a new build job.

**Follow-up:** I sent the maintainer inbox a note asking why the coverage audit started a gauntlet on a probe PR. The same mistake may hit other probes, for example https://github.com/endojs/endo-but-for-bots/pull/1516 (the Bun probe). I made no code changes.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1518-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (540316 cached reads)
- Output: 4444 tokens
- Cost: $0.5593912
- Wall-clock: 87s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
