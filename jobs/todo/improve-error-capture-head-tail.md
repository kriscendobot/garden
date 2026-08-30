---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
skills/gardener-inbox-error-reporting/report-error.sh
When truncating oversized handler transcripts, retain bounded beginning and ending slices with an explicit omission marker instead of only the tail. The 172020-byte fuzz-repair failure lost its initial diagnostic context, making escalation less actionable.
