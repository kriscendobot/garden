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
title: §Threat-model-with-citations
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *Ambient access lets a prompt-injected agent read
> credentials (`~/.ssh/id_rsa`, `~/.aws/credentials`),
> poison configuration (`~/.bashrc`, `.git/hooks`), or
> exfiltrate source code — attacks demonstrated at 84%
> success rates against unprotected editors [1][2].*

§Cited-academic-research:
- arxiv:2509.22040 (Liu et al., *Your AI, My Shell*, Sep
  2025)
- IDEsaster report (Marzouk, Dec 2025)

§84%-success-rate-against-unprotected-editors. §The-
problem-is-empirically-documented.

§Cycle-94's-OCPL paper cited Mark Stiegler 2006 HPL-2006-
116 in similar fashion. §Cited-research-anchors-the-
motivation.

§This-design-is-the-response-to-documented-attack-
patterns. §Defense-driven-by-evidence-not-theoretical-
threat-model.
