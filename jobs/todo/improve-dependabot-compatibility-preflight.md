---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabot-watcher.sh
Add a bounded deterministic compatibility preflight for declared peer-dependency and Node-engine intersections. It should cheaply flag or close only proven incompatible Dependabot bumps before a botanist spends a full review; the Vite 6/`@vitejs/plugin-react` 6 conflict and Babel 8 versus the project’s Node floor were both terminal, declaration-level incompatibilities.
