# frozen_string_literal: true

module ServiceProviders
  class DataFetcherRegistry
    # NOTE: Adding a new data source, implies adding a new source to HotelRawDatum source enum
    DATA_FETCHERS = {
      acme: ServiceProviders::Acme::DataFetcher,
      paperflies: ServiceProviders::Paperflies::DataFetcher,
      patagonia: ServiceProviders::Patagonia::DataFetcher
    }.freeze
  end
end
