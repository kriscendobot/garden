---
role: designer
---

# design: refine endoclaw-oauth as a suitable connector foundation

Follow-up requested by @kriskowal in review of endojs/endo-but-for-bots PR #612
(design/exo-google-sheets). Refine `designs/endoclaw-oauth.md` so it is a solid
foundation for domain connectors that ride it (exo-google-sheets, and its Gmail
/ Calendar siblings). In particular, **settle the first-mint OAuth flow**:
browser redirect against a localhost callback vs. the device-code grant — which
does the host run, is it configurable, and is that choice fully hidden from
connectors (they consume an already-minted OAuth exo and should not care)?

Confirm the OAuth/OAuthControl surface (setAllowedPaths, setReadOnly, token
refresh, revocation) is sufficient as the credential layer the Sheets connector
narrows on top of, and note any gaps the connector designs currently assume.
Repo: endojs/endo-but-for-bots. Reference: designs/endoclaw-oauth.md,
designs/exo-google-sheets.md (Resolved Question 5).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 18
  claimed_at: 2026-07-07T00:12:12Z
