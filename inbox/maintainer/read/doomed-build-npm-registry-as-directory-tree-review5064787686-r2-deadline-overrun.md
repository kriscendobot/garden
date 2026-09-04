from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-31T12:04:40Z
doom_base: build-npm-registry-as-directory-tree-review5064787686-r2
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-31T12:04:40Z
last_seen: 2026-08-31T12:04:40Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden2-5bcdff64.
The handler returned rc=124 at its applied 7200s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/build-npm-registry-as-directory-tree-review5064787686-r2; it stays HELD until a human promotes it
(promote-plan.sh build-npm-registry-as-directory-tree-review5064787686-r2) or removes it.
Original job base: build-npm-registry-as-directory-tree-review5064787686-r2

--- original job body ---
---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-08-31T09:43:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the approved npm registry directory-tree design (halt recovery)

Repository: endojs/endo-but-for-bots (bot fork: kriscendobot/endo-but-for-bots).
Approved design: https://github.com/endojs/endo-but-for-bots/pull/1083 and designs/npm-registry-as-directory-tree.md.

This recovery child supersedes the unexecuted parked child build-npm-registry-as-directory-tree from the halted first orchestration. Run only after the preceding weaver and conductor have merged the design PR into llm.

Implement the approved design in full. Replace the bespoke EndoRegistry presentation with the specified package-registry directory-tree capabilities, including the shared platform guard split, Node and Endor adapters, resolver/mapper migration, error and read-consistency contracts, compatibility path, and cross-backend conformance tests described by the design. Preserve the existing fetch, SQLite, integrity, MVS, workspace, peer, optional-dependency, and CAS behavior behind the adapters.

Open the implementation as a draft PR from the bot fork against llm, run the repository-local verification required by the builder role, and report the PR URL and exact executed evidence. Do not mutate or merge endojs/endo upstream.

Source authorization: maintainer @kriskowal approved PR 1083 and directed, "Conduct and build this" in review 5064787686.
