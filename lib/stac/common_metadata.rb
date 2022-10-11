# frozen_string_literal: true

require 'time'

module STAC
  # Provides read/write methods for \STAC Common Metadata.
  #
  # These methods are shorthand accessors of #extra Hash.
  # Asset and \Item Properties include this module.
  #
  # Specification: https://github.com/radiantearth/stac-spec/blob/master/item-spec/common-metadata.md
  module CommonMetadata
    attr_accessor :extra

    def title
      extra['title']
    end

    def title=(str)
      extra['title'] = str
    end

    def description
      extra['description']
    end

    def description=(str)
      extra['description'] = str
    end

    def created
      if (str = extra['created'])
        Time.iso8601(str)
      end
    end

    def created=(time)
      extra['created'] = case time
                         when Time
                           time.iso8601
                         else
                           time
                         end
    end

    def updated
      if (str = extra['updated'])
        Time.iso8601(str)
      end
    end

    def updated=(time)
      extra['updated'] = case time
                         when Time
                           time.iso8601
                         else
                           time
                         end
    end

    def start_datetime
      if (str = extra['start_datetime'])
        Time.iso8601(str)
      end
    end

    def start_datetime=(time)
      extra['start_datetime'] = case time
                                when Time
                                  time.iso8601
                                else
                                  time
                                end
    end

    def end_datetime
      if (str = extra['end_datetime'])
        Time.iso8601(str)
      end
    end

    def end_datetime=(time)
      extra['end_datetime'] = case time
                              when Time
                                time.iso8601
                              else
                                time
                              end
    end

    # Returns a range from #start_datetime to #end_datetime.
    def datetime_range
      if (start = start_datetime) && (last = end_datetime)
        start..last
      end
    end

    # Sets #start_datetime and #end_datetime by the given range.
    def datetime_range=(time_range)
      self.start_datetime = time_range.begin
      self.end_datetime = time_range.end
    end

    def license
      extra['license']
    end

    def license=(str)
      extra['license'] = str
    end

    def providers
      extra.fetch('providers', []).map do |provider_hash|
        Provider.from_hash(provider_hash)
      end
    end

    def providers=(arr)
      extra['providers'] = arr.map(&:to_h)
    end

    def platform
      extra['platform']
    end

    def platform=(str)
      extra['platform'] = str
    end

    def instruments
      extra['instruments']
    end

    def instruments=(arr)
      extra['instruments'] = arr
    end

    def constellation
      extra['constellation']
    end

    def constellation=(str)
      extra['constellation'] = str
    end

    def mission
      extra['mission']
    end

    def mission=(str)
      extra['mission'] = str
    end

    def gsd
      extra['gsd']
    end

    def gsd=(num)
      extra['gsd'] = num
    end
  end
end
