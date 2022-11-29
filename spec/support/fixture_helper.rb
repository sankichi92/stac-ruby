# frozen_string_literal: true

module FixtureHelper
  def fixture_path(path)
    File.expand_path("../fixtures/#{path}", __dir__)
  end

  def read_fixture(path)
    File.read(fixture_path(path))
  end

  def read_fixture_as_json(path)
    JSON.parse(read_fixture(path))
  end
end
