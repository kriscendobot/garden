---
source: designs/daemon-capability-filesystem.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-capability-filesystem.md
source_path: designs/daemon-capability-filesystem.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 170
lane: designs
status: current
title: §Bazel-style-selective-dependency-mounting
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *This is the same trick Bazel uses: a build step sees
> only the dependencies explicitly mounted into its
> sandbox. If a dependency is not declared, it is not
> mounted, and the build step cannot see it — the absence
> is enforced structurally, not by policy.*

§Absence-is-structural-not-policy. §A-guest-cannot-access-
$HOME/.ssh-if-no-mount-exposes-it, regardless of what the
physical filesystem contains.

§The-Bazel-property: §undeclared-dependencies-are-not-
denied-they-are-absent. §Structural-invisibility-not-
denylist.

§Why-this-matters-for-AI-agents: a prompt-injected agent
trying to read `~/.ssh/id_rsa` finds *no path* to it in
the VFS. The path doesn't exist as far as the agent is
concerned. §No-amount-of-clever-prompting-can-construct-
authority-it-doesn't-have.

§Cite-academic-research: the doc references
arxiv:2509.22040 (*Your AI, My Shell*) and the IDEsaster
report with §84%-success-rates-against-unprotected-
editors statistic. §Threat-model-with-citations is the
discipline.
