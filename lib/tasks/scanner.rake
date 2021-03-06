# frozen_string_literal: true

require File.expand_path('../../app/lib/phobrary/index.rb', __dir__)
require File.expand_path('../../app/lib/phobrary/cluster.rb', __dir__)

namespace :phobrary do
  desc 'Clean photo library database'
  task purge: :environment do
    Photo.destroy_all
    Shot.destroy_all
    Camera.destroy_all
    Folder.destroy_all
  end

  desc 'Run clustering algorithm'
  task cluster: :environment do
    Phobrary::Commands::Cluster.cosine_distance
    # Phobrary::Commands::Cluster.jenks_moments
  end

  desc 'Scan photo library directories'
  task scan: :environment do
    source_library_directory = File.join('..', 'library', 'source')
    target_library_directory = File.join('..', 'library', 'target')
    Phobrary::Commands::Index.index_directories(source_library_directory)
    Phobrary::Commands::Index.index_photos(source_library_directory, target_library_directory)
  end
end
