All changes are confirmed on both branches.

## Completion report

**Job:** `improve-scholar-child-reachability-probe` — move the scholar's per-cycle manual hub-child reachability probe into deterministic code.

**What I did**

- Added **`scripts/jobs/check-source-children.sh <hub-url-or-mirror-path>`**. Given a hub/nav page it: (1) fetches the hub through the existing `fetch-source.sh` (direct → erights GitHub Pages mirror → Internet-Archive `id_` fallback); (2) extracts the hub's same-host child hrefs, resolving relative links and normalizing `../`/`./`/`//`, stripping fragments, and dropping `mailto:`/`javascript:`/off-host links, with dedup; (3) probes each child through the same `fetch-source.sh` logic, retrying the toggled **www / no-www** host form before declaring dead; (4) emits a one-line-per-child manifest — `child_url=… child_status=reachable child_via=direct|mirror|wayback` or `child_status=dead child_via=-`. Stdout is the manifest only; diagnostics + a count summary go to stderr. Exit 0 (probed; dead children are rows, not failures), 1 (hub itself unreachable), 2 (usage). Follows the house style of `fetch-source.sh` (sources `common.sh`, `require_tools`, `log`/`die`, `CHECK_SOURCE_FETCH` override for test stubbing).
- Added **`scripts/jobs/test/check-source-children-test.sh`** — hermetic, stubs `fetch-source.sh`. 22 assertions across 5 cases: full classification/resolution/off-host-filter/dedup, the www-retry rescue, hub-unreachable → exit 1, usage exits, and the mirror-URL hub form. All pass.
- Cited the new script from **`roles/scholar/AGENT.md`** (a new reachability-step bullet under the source-acquisition step) and **`journal/library/conventions.md` § source acquisition** (a new paragraph beside the `fetch-source.sh` citation), the same way `fetch-source.sh` is cited — so the scholar reads the script path in its always-read procedure docs.

**What changed / where it landed**

- `main2` (commit `76aeaaff0`, built in an isolated worktree off `origin/main2`): the two scripts + `roles/scholar/AGENT.md`.
- `journal2` (via `land-journal-edit.sh`): `library/conventions.md`. Both verified present on `origin/main2` and `origin/journal2`.

**Follow-ups / notes**

- The two shellcheck notes on the script (SC1091 sourcing `common.sh`; SC2034 `GARDEN_TAG` — read by `log()`) are the same benign ones `fetch-source.sh` already carries; left as-is for consistency.
- The conventions.md citation references `check-source-children.sh` by its main2 script path the same way the existing `fetch-source.sh` citation does — no script body is duplicated into the journal.

Self-improvement: the citation had to be split across two branches (role file on `main2`, conventions.md on `journal2` via the lander) because the scholar's always-read procedure docs live on both — a reminder that "cite a new main2 script from the scholar's docs" is always a two-branch landing, not one.
