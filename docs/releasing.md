# Releasing MonkeyLens

1. Update `MonkeyLens::VERSION`.
2. Update `CHANGELOG.md`.
3. Run `bundle exec rake test` and `bundle exec rake build`.
4. Commit and tag the release, for example `v0.1.0`.
5. Push the tag to create the GitHub release and attach the `.gem` file.
6. Add a repository environment named `rubygems`.
7. Add `RUBYGEMS_API_KEY` as an environment or repository Actions secret.
8. Run **Publish to RubyGems** manually and enter the exact version.

Never commit `.gem/credentials` or paste an API key into an issue, pull request, workflow file, or chat transcript.
