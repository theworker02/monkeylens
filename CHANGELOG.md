# Changelog

All notable changes to MonkeyLens are documented here.

## 0.2.0 — 2026-08-04

- Added `MonkeyLens::Policy` for approving known runtime drift without deleting evidence from the baseline.
- Added wildcard waivers for change type, target, and method identifiers.
- Required a written reason for every waiver.
- Added optional ISO-date expiration for temporary approvals.
- Added YAML policy loading through `MonkeyLens::Policy.load`.
- Added `Policy::Decision` with effective and waived changes, threshold evaluation, and JSON-ready output.
- Added the `MonkeyLens.evaluate` convenience API.

## 0.1.0 — 2026-08-04

- Initial runtime snapshot and drift engine.
- CLI commands for capture, check, diff, inspect, and doctor.
- Text, JSON, and SARIF formatters.
- Rake and Rails integrations.
- RBS signatures, CI, Pages, release, and RubyGems publishing workflows.
