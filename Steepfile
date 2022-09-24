# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib/**/*.rb'

  library 'json', 'pathname', 'uri' # TODO: Remove 'sig/open-uri.rbs' and add 'open-uri' here after its RBS are defined.

  configure_code_diagnostics do |hash|
    hash[D::Ruby::InsufficientKeywordArguments] = nil
    hash[D::Ruby::UnsupportedSyntax] = nil
  end
end
