---
role: builder
---

Build the Phase 4 sub-mount primitive for the daemon-mount capability in endojs/endo-but-for-bots (design `journal/plan/designs/endo-but-for-bots/daemon-mount.md`, § `provideSubMount`): implement the `provideSubMount(mountName, subpath, newName, options?)` host method that formulates a child `mount` rooted at a subdirectory of an existing mount (recording `parent` for dependency tracking) with its own confinement root so a sub-mount at `/project/src` cannot escape to `/project/.env` via `..`, plus tests for read-only attenuation and sub-mount isolation. Open it as a PR against the `llm` base.
