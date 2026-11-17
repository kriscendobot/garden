The design for `endopi-extension-package-manifest` is done and up for review as draft PR **endojs/endo-but-for-bots#1674**. It is based on the frozen snapshot `llm-0368767`, and the only files it changes are `designs/endopi-extension-package-manifest.md` and that design's row in `designs/README.md`.

**What I did this run:** an earlier claimant of this job had already written the design and opened #1674 at head `a951879b0b`. `ensure-pr.sh --find-only` found and adopted that PR instead of opening a duplicate. I checked the PR and added one commit (`5b8aa3ffe8`) that bumps the design's "Updated" date in `designs/README.md` to 2026-11-17, as the sibling design PRs #1671 and #1672 did. The PR is still a draft.

**What the design settles:**
- **Manifest:** a `package.json` `endo` key lists folders for guests, skills, prompts and providers. If the key is absent, top-level folders with those names are used. Unknown keys produce a warning, and symbolic links, special files or paths that leave the package refuse the install.
- **Installing files is not a grant:** skills and prompts are copied into `.agents/skills` and `.agents/prompts`. An agent can only read them through the read-only mounts that the skills and prompt-template setup commands create, so installing a package grants the agent nothing.
- **Guests and providers:** they are recorded as pending and are never run or registered. The old guest store (removed in `8a1f07d38`) is not revived.
- **Where installs are recorded:** there is a user scope and a per-project scope, each with a ledger at `.agents/endo-packages/` that keeps a validated copy of the package. Sources can be `npm:`, `git:` or `file:`; an explicit version or Git ref pins the install against updates.
- **Commands:** the lifecycle sits under a new `endo package` command group, with `endo install` kept as a short alias. This answers #1639's open question: `endo list packages` and `endo remove npm:…` keep their ordinary daemon meanings.
- **Safety:** installs and removals are locked per scope, and an interrupted one is rolled back on the next package command. Update or removal refuses to touch a file the user has changed unless `--force` is given. Nothing in the package runs during install.
- **For reviewers and the builder:** an ownership map, a test plan, five build phases, and a six-item "Delta for #1639" list of changes that PR needs.

The design has no open questions for the maintainer and no diagrams, so no mermaid check was needed.

## Follow-ups
- **Build:** the build is reworking the existing draft #1639 (head `feat/endopi-extension-package-manifest`) to follow the design's "Delta for #1639" list. Guest and provider support stays with the parked plan `endopi-extension-package-guest-provider-kinds`. Providers wait on the provider registry (#1587), and guests wait on a design that says where guests go.
- A separate designer job, `build-endopi-extension-package-manifest-prerequisite-check`, is in todo. It asks for a write-up of what is still missing between the EndoPi designs and PRs #1501 and #667, and it may overlap with this design.
- #1674 is still a draft; the completion machinery records its design-panel gauntlet.

<!-- garden-design-build-handoff: successor=build-endopi-extension-package-manifest state=recheck:endojs-endo-but-for-bots-pr1674-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1674 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endopi-extension-package-manifest.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 20 tokens (642299 cached reads)
- Output: 4003 tokens
- Cost: $0.7458718000000001 (1 engagement(s) unpriced)
- Wall-clock: 1763s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
