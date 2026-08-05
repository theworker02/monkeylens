# Contributing to MonkeyLens

## Setup

```bash
bin/setup
```

## Validate a change

```bash
bundle exec rake test
bundle exec rake build
bundle exec ruby -Ilib exe/monkeylens doctor
```

Add tests for behavior changes and update the changelog for user-facing changes. Keep the runtime model deterministic: snapshots generated from an unchanged process must compare equal.
