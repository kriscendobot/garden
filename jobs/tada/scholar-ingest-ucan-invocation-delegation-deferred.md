Completed deferred UCAN ingestion for issue-kriskowal-garden-34.

- Added 10 section files: UCAN Lifecycle, Time, Token Resolution, Nonce, Metadata, Implementation Recommendations, FAQ, Related Work, and UCAN Delegation Policy plus Semantic Conditions.
- Updated the two UCAN source indexes (13 high-level-spec sections, 6 delegation sections) and the affected topic indexes: ucan-authorization, capability-security, content-addressed-storage, marshal, and patterns.
- Landed all library content through scholar staging and the journal lander; regenerated the sections index and topic-count projection.
- Verification run: `library-link-check.sh --source-slug ucan-wg--spec-readme` and `--source-slug ucan-wg--delegation-readme` both passed; `regenerate-topics-counts.sh --check` reported current.

Follow-ups: none; the named deferred sections are now ingested.

Self-improvement: nothing this time.
