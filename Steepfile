# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib/**/*.rb'

  # TODO: Add 'open-uri' and remove 'sig/open-uri.rbs' when 'open-uri' RBS is defined.
  library 'json', 'pathname', 'time', 'uri'

  configure_code_diagnostics do |hash|
    hash[D::Ruby::ArgumentTypeMismatch] = :hint
    hash[D::Ruby::InsufficientKeywordArguments] = nil
    hash[D::Ruby::MethodBodyTypeMismatch] = :hint
    hash[D::Ruby::MethodDefinitionMissing] = nil # To supress noisy VS Code extension message.
    hash[D::Ruby::UnsupportedSyntax] = :hint
  end
end
