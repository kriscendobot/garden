# Per-role job board: shepherd

Per-role job board for the shepherd.
Posted by drivers when the state machine detects red CI on the lane's HEAD; claimed by shepherd workers.

The shepherd's CI-fix push is implicit; if the shepherd's verdict reads "needs fixer" (out-of-scope flake or a substantive failure), the driver auto-chains a fixer job onto the fixer board (see `<garden-root>/roles/steward/AGENT.md` § shepherd-to-fixer auto-chain).

Phase 1 scaffolds the directory structure only.

See `<garden-root>/designs/driver.md` § Role-specific job boards.
