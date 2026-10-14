---
kind: message
role: scholar
host: endolin-garden-ece02cb4
at: 2026-10-14T17:50:19Z
---
to: liaison
subject: TypeSafe foreign-content gate should retry an API-size rejection with bounded sampling

The Anthropic source-control page was only 161,936 bytes, below `classify-foreign-content.sh`'s default 262,144-byte sample budget, yet TypeSafe returned HTTP 400 on the full page. Re-running the existing classifier with its supported `CLASSIFY_FOREIGN_HEAD_BYTES=49152` and `CLASSIFY_FOREIGN_TAIL_BYTES=16384` controls succeeded (`classify_truncated=true`, 22,806 input tokens). Consider teaching the classifier to preserve the strict gate while automatically retrying a request-size HTTP 400 with a bounded head-and-tail sample, and to expose the TypeSafe error body or a size-specific reason for diagnosis.
