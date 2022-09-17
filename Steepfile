# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib/**/*.rb'

  library 'json', 'pathname', 'uri'

  configure_code_diagnostics do |hash|
    hash[D::Ruby::InsufficientKeywordArguments] = nil
    hash[D::Ruby::UnsupportedSyntax] = nil
    hash[D::Ruby::UnknownInstanceVariable] = nil
  end
end
