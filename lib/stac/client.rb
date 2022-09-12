# frozen_string_literal: true

require 'faraday'

module STAC
  class Client
    class << self
      def open(url)
        new(url).tap(&:fetch_root)
      end
    end

    def initialize(url)
      @conn = Faraday.new(url)
    end

    def fetch_root
      @conn.get
    end
  end
end
