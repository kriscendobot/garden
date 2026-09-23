No reply yet (expected for a low-priority gate). My work on this gated job is complete.

---

## Completion report

**Job:** `endo-but-for-bots-harden-exported-literals-followup` — gated follow-up to open a separate PR hardening exported function literals (origin: erights bullet 4 on endojs/endo-but-for-bots#474).

**Outcome:** Did not open a PR. The job is explicitly **gated on a maintainer (@kriskowal) scope decision**, and I could not correctly execute even the "narrow" change without it. I performed read-only diligence, found the spec's premise was inaccurate, and sent the maintainer a decision-ready scoping message via the liaison.

**What I verified (read-only):**
- **#474 is MERGED** (into `master`, 2026-06-26): "retire function-keyword in favor of arrow/method syntax." **No open PR** on endo-but-for-bots or endo covers the harden follow-up.
- **Spec premise was wrong/branch-dependent.** The job said `evadeCensorSync`/`evadeCensor` are "un-hardened arrow consts." On the default/working branch `llm` they're actually un-hardened **function declarations** (`src/index.js:65` / `:129`); the arrow-const form erights reviewed (his ref: line 91) exists on `master` post-#474. The diff shape and base branch therefore matter.
- The `@endo/harden-exports` eslint rule exists in-repo (#474 touched it); a repo-wide pass would lean on it.

**Action taken:** Sent the maintainer (`inbox/maintainer`, id `20260627T125202Z-44b78c`) a message asking two questions: (1) breadth — narrow (two evasive-transform exports) vs repo-wide (every exported function literal, aligned with the harden-exports rule, designer-first); (2) base branch — `llm` vs `master`. erights's directive already authorizes opening the cross-repo PR; only breadth + base are owed.

**Follow-ups:**
- On the maintainer's reply, dispatch a **builder** (narrow) or **designer→builder** (repo-wide) to open a DRAFT PR on the chosen base and run the gamut. The reply routes to this job's inbox; if it arrives after this job closes, the bus dead-letters it into a fresh job, so the intent is preserved.
- Whoever picks it up should target the base branch the maintainer names and write the harden in the form matching that branch (function-declaration `harden(name)` statements on `llm`, or folded into the arrow consts on `master`).
