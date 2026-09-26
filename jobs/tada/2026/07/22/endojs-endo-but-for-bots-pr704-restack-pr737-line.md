Restacked PR #704 onto bridge cut 5 and force-with-lease pushed `b212146bac9e2fd401dba13f2d35b49f31e8cae7`; PR remains draft. Commented test evidence on #704.

Passed: daemon round-trip/OCapN suites (14 tests), OCapN handoff suite in all three SES modes, ESLint and TypeScript checks. Full daemon confinement suite blocked: native `better-sqlite3` build failure leaves daemon socket absent.
