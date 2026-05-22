---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 321
created_at: 2026-05-22T23:06:00Z
last_appended_at: 2026-05-22T23:06:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#321

## Items

- [ ] `packages/familiar/scripts/make-distributables.mjs:50-61` win-vs-win32 normalization branch is dead code on every current call site. The workflow matrix has no Windows row; `process.platform === 'win32'` returns `win32` directly via the host-fallback. Defensible as forward-compose plumbing for the universal-binary follow-up. Revisit when a Windows runner is added to the matrix or when the universal-binary lipo step lands.  
  **Source juror(s)**: corner-prober  
  **Round**: 1 (barrister-f40efb)  
  **Recommended action**: No action until a Windows matrix row or universal-binary PR is staged; at that point, either exercise the branch or remove the normalization.

- [ ] No release-side smoke test for the matrix exists. The workflow runs only on `workflow_dispatch` or `familiar-v*` tag push, so the first end-to-end exercise is the next maintainer-triggered release. The PR description names this as the next-step exercise.  
  **Source juror(s)**: prover  
  **Round**: 1 (barrister-f40efb)  
  **Recommended action**: Run one `workflow_dispatch` dry-run before the first `familiar-v*` tag and capture a `result` entry showing the three artifact names produced (`familiar-darwin-arm64`, `familiar-darwin-x64`, `familiar-linux-x64`). Liaison-initiated when staging the first release.

- [ ] Universal-binary path remains the tracked post-MVR followup per `designs/familiar-release.md`. The script-argument plumbing landed in this PR is the precondition for that step.  
  **Source juror(s)**: integrator  
  **Round**: 1 (barrister-f40efb)  
  **Recommended action**: When the universal-binary PR is opened, cross-link this PR (#321) as the prerequisite in the future PR body. Tracked in the design's followups table.
