**Viability: proceed.** PR #1639 is open, has not been superseded, and the need behind it still holds. I spent no clean, panel, fix, CI-wait or un-draft budget.

Deciding question: Is `designs/endopi-extension-package-manifest.md` still unimplemented on current `llm` by anything other than #1639, with Endo still lacking a way to distribute skills and prompts from one package?
Answer: yes.

Evidence:
- **PR state:** #1639 is open, unmerged and a draft. It was created today (2026-11-02) by the build job `endopi-extension-package-manifest-build`, and has no comments, reviews or linked closing issues.
- **Base:** `llm-48d6f3e` is identical to the current `llm` tip (ahead 0, behind 0), and the head is 3 commits ahead and 0 behind. No newer base history exists to displace it.
- **Not superseded on `llm`:**
  - The design and its `designs/README.md` row still say `Proposed`.
  - The design has not changed since #265 merged it on 2026-05-15.
  - `packages/cli/src/packages/` does not exist, and `endo.js` has no `install` command, only a stale `install` entry in the help group at line 1022.
  - Code search finds the `endo-package` keyword only in that design, and `.agents/skills` only in it and `endopi-skills-markdown-format.md`.
- **Not superseded by other PRs:** searches for the design name, `endo install` and `.agents/skills` found no competing implementation among open or merged PRs. The nearest neighbors are unrelated CLI or provider work, such as #1595 and #1573.
- **Premise holds:** the design's gap is that one package cannot ship coordinated skills and prompts, and that gap remains. Its parent design, `endopi`, merged in #265 and has not been withdrawn.

Stale design assumptions (neither one displaces the PR):
- **Guest store:** the design relies on an "existing `endo install` path", but 8a1f07d38 removed it on 2026-03-25, before the design was written. #1639 discloses this, leaves guests pending, and asks the maintainer where they should go.
- **Providers:** these are also deferred because the registry in #1587 is still an open draft. Both remainders belong to the parked job `endopi-extension-package-guest-provider-kinds`.

For the panel and maintainer:
- **No consumers yet:** nothing on `llm` reads the `.agents/skills` or `.agents/prompts` directories, because the skills and prompt-template designs are also still `Proposed`. A job named `endopi-prompt-templates-open-pr` is on the board, but I did not read it, and I found no skills-format PR. Installed resources therefore sit unused until those land. That is a question of sequencing, not of whether the PR is still needed.
- **Open decisions in the PR body:** whether `endo install` should return for this manifest, and whether a `packages` directory may be shadowed in `endo list packages`.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1639-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (231392 cached reads)
- Output: 4586 tokens
- Cost: $0.5657504000000002
- Wall-clock: 134s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
