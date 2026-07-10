---
role: builder
---

Run the gauntlet on endojs/endo-but-for-bots PR #652 ("feat(cli): expose mount deniedSegments via --deny/--no-deny (#127)"): clean → panel review → fix-loop → un-draft. It is stacked on the already-un-drafted revocation base (#650), not on the in-flight glob rung, and is CI-green, so it is unblocked and advances the #127 daemon-mount split toward closing.
