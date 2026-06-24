# Author the canonical self-healing-wrapper skill

Per designs/self-healing-audit.md (Part A, role/skill gaps): there is no single
canonical playbook for the garden's self-healing posture, so the pattern is
copied ad hoc (scripts/driver/driver.sh) or absent.

Author skills/self-healing-wrapper/SKILL.md: a reusable playbook for an outer
wrapper that, on failure, (1) captures the failure output, (2) hands it to a
`claude -p` debugging/self-improvement responder wearing a role/skill specific
to the self-healing task, and (3) proposes/posts a fix. Cite the exemplars:
scripts/driver/driver.sh (EXIT trap + capture_and_self_improve), the v1
report-error.sh, and the gardening state machine's diverted tracing
(designs/gardening-state-machine.md). Cross-link the prompt-on-failure-capture
and gardener-inbox-error-reporting skills once they are ported (see
self-heal-port-capture-skills). Build in an isolated worktree off origin/main2.
