module ApiExplorer
  class DescriptionProxy < GroupProxy
    def base_url(url)
      path url
    end
  end
end
