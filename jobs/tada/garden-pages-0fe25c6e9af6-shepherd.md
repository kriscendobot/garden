The Pages deploy is green on the current tip. All three jobs (build, deploy, report-build-status) succeeded, Pages status is `built`, the newest `github-pages` deployment reports `state=success`, and the live site serves 200 for both `/garden/` and `/garden/bulletin/`.

No code change was needed — no commit, nothing to push. This was a GitHub-side transient deploy flake.

---

**Completion report**

- **Failing run:** https://github.com/kriskowal/garden/actions/runs/28790440069 (SHA `0fe25c6e9af6`, tip of `main2`).
- **Classification: `flake`.** The `build` job succeeded and the `docs/` artifact uploaded cleanly; only the `deploy` job failed, with GitHub's generic backend message `##[error]Deployment failed, try again later.` The Pages source is `main2/docs` (legacy build type), `docs/` is valid on the tip, and the live site stayed up throughout (served from the prior good deploy `09461d1b`). No content or asset problem.
- **What I did:** Re-fetched live state (the red run was still the newest — not superseded). Re-ran the failed deploy job twice; both hit the same fast "try again later" while GitHub's legacy Pages backend was transiently unhealthy (Pages status stuck `building`). A full fresh rerun of the workflow (rebuild artifact + re-deploy) then went **green**.
- **Result:** Run `28790440069` conclusion `success`; all jobs green; `repos/kriskowal/garden/pages` status `built`; newest `github-pages` deployment `state=success`; live site `index:200 bulletin:200`.
- **Changes:** none — no commit, no push (transient flake, not a content error).
- **Follow-ups:** none.

**next: none** — the failure was a transient GitHub-side deploy flake, now cleared. Green run: https://github.com/kriskowal/garden/actions/runs/28790440069
