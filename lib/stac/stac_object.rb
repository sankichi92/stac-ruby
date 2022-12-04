# frozen_string_literal: true

require_relative 'errors'
require_relative 'hash_like'
require_relative 'link'
require_relative 'spec_version'

module STAC
  # Base class for \STAC objects (i.e. Catalog, Collection and Item).
  class STACObject
    include HashLike

    @@extendables = {} # rubocop:disable Style/ClassVars

    # Returns available extension modules.
    def self.extendables
      @@extendables.values.uniq
    end

    # Adds the given extension module to .extendables.
    def self.add_extendable(extendable)
      @@extendables[extendable.identifier] = extendable
      self
    end

    class << self
      attr_reader :type # :nodoc:

      # Base method to deserialize shared fields from a Hash.
      #
      # Raises ArgumentError when any required fields are missing.
      def from_hash(hash)
        raise TypeError, "type field is not '#{type}': #{hash['type']}" if hash.fetch('type') != type

        transformed = hash.transform_keys(&:to_sym).except(:type, :stac_version)
        new(**transformed)
      end
    end

    # HTTP Client to fetch objects from HTTP HREF links.
    attr_accessor :http_client

    attr_reader :stac_extensions, :links

    def initialize(links:, stac_extensions: [], **extra)
      @links = []
      links.each do |link|
        add_link(**link.transform_keys(&:to_sym)) # to set `owner`
      end
      @stac_extensions = stac_extensions
      @extra = extra.transform_keys(&:to_s)
      @http_client = STAC.default_http_client
      apply_extensions!
    end

    # Serializes self to a Hash.
    def to_h
      {
        'type' => type,
        'stac_version' => SPEC_VERSION,
        'stac_extensions' => stac_extensions.empty? ? nil : stac_extensions,
        'links' => links.map(&:to_h),
      }.merge(extra).compact
    end

    def deep_dup
      super.tap do |obj|
        obj.http_client = http_client.dup
      end
    end

    def type
      self.class.type
    end

    # Returns extended extension modules.
    def extended
      @extended ||= []
    end

    # Adds the given extension identifier to #stac_extensions.
    #
    # When the given argument is extendable, the item extends the module.
    def add_extension(extension)
      case extension
      when Extension
        stac_extensions << extension.identifier
        apply_extension!(extension)
      else
        stac_extensions << extension
        if (extension = @@extendables[extension]) && extension.scope.include?(self.class)
          apply_extension!(extension)
        end
      end
      self
    end

    # Adds a link with setting Link#owner as self.
    def add_link(rel:, href:, type: nil, title: nil, **extra)
      link = Link.new(rel: rel, href: href, type: type, title: title, **extra)
      link.owner = self
      links << link
      self
    end

    # Reterns HREF of the rel="self" link.
    def self_href
      find_link(rel: 'self')&.href
    end

    # Adds a link with the give HREF as rel="self".
    #
    # When any ref="self" links already exist, removes them.
    def self_href=(absolute_href)
      remove_link(rel: 'self')
      add_link(rel: 'self', href: absolute_href, type: 'application/json')
    end

    # Returns a link matching the arguments.
    def find_link(rel:, type: nil)
      links.find do |link|
        if type
          link.rel == rel && link.type == type
        else
          link.rel == rel
        end
      end
    end

    private

    def extensions
      stac_extensions
        .map { |extension_id| @@extendables[extension_id] }
        .compact
        .select { |extension| extension.scope.include?(self.class) }
    end

    def apply_extensions!
      extensions.each do |extension|
        apply_extension!(extension)
      end
    end

    def apply_extension!(extension)
      extended << extension
    end

    def remove_link(rel:)
      links.reject! { |link| link.rel == rel }
    end
  end
end
