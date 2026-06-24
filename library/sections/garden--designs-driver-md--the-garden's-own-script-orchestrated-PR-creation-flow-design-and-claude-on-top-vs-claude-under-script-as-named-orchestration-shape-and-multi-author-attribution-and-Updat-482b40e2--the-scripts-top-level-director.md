---
title: §The scripts/ top-level directory with named convention
source-slug: garden--designs-driver-md
section-slug: the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
source-url: https://github.com/kriskowal/garden/blob/main/designs/driver.md
source-repo: kriskowal/garden
source-path: designs/driver.md
source-author: gardener + fixer + designer
total-lines: 691
ingest-cycle: 281
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
---

Lines 38-50 carry §the-scripts/-top-level-directory-with-named-convention:

```
scripts/                              # executable shell scripts for humans + systemd
  driver/
    driver.sh                         # the per-lane driver entry point
    README.md
  watcher/<feed-slug>/
    watcher.sh
    README.md
  daemons/
    start.sh
    stop.sh
  systemd/
    garden-driver@.service
    garden-watcher@.service
```

§First-explicit-observation in library: **§the-scripts-top-level-directory-with-named-convention — §scripts/-IS-the-new-named-top-level-directory + §it-coexists-with-roles/-and-skills/-as-three-named-top-level-directories + §each-has-a-distinct-audience (scripts: humans + systemd; roles: subagent context; skills: just-in-time playbooks)**.

§Three-named-top-level-directories-with-named-audiences (scripts + roles + skills); §the-discipline-IS-separation-of-audience-not-just-separation-of-content.

§The-scripts/-mirrors-the-systemd-templated-unit-shape — `garden-driver@.service` + `garden-watcher@.service` are systemd templates where `@<instance-name>` parameterizes the unit; §sibling-pattern to many systemd conventions.
