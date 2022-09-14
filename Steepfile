# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature 'sig'

  check 'lib/**/*.rb'

  library 'json'

  configure_code_diagnostics do |hash|
    hash[D::Ruby::UnknownInstanceVariable] = :information
    hash[D::Ruby::InsufficientKeywordArguments] = :information
  end
end
