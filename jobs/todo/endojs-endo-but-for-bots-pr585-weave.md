# Weave PR #585 (endojs/endo-but-for-bots)

Rebase https://github.com/endojs/endo-but-for-bots/pull/585 (feat(platform): add
content-store powers for node fs) onto current `llm` and resolve conflicts
(weaver role). CI is fully green on the stale head but GitHub reports
`mergeable: CONFLICTING`, and the PR has idled since 2026-07-02. After the
weave pushes, confirm CI re-runs on the new head. This PR is part of the Endo
daemon data-plane arc (content-store powers feed the CAS that the magnet-URN
content locators of designs/endo-content-locators-magnet-urn.md read from).
Posted by the data-plane press driver (endo-daemon-data-plane-press-20260716-175014).
