namespace :importer do
  desc "Start the server and import services"
  task start: [:environment] do |task, args|
    importer_pid = nil
    begin
      system 'rake db:migrate'
      importer_pid = fork do
        system 'rake importer:import_tab_files'
      end
      system 'rails server'
    rescue SignalException
      logger.warn "Terminating..."
      Process.kill("TERM", importer_pid)
      Process.wait
    end
  end

  desc "Extract items to import from TAB files"
  task import_tab_files: [:environment] do |task, args|
    SECS = 5
    logger = Logger.new STDOUT
    ActiveRecord::Base.logger = logger

    begin
      loop do
        Import.import_files
        logger.info "Polling for new TAB files in #{SECS} seconds..."
        sleep SECS
      end
    rescue SignalException
      logger.warn "Stopping import service..."
    end
  end

  desc "Generate sample input file"
  task :generate_sample do
    NUM_PURCHASES = 1000
    require 'securerandom'
    logger = Logger.new STDOUT
    logger.info "Generating #{NUM_PURCHASES} entries..."

    names = %w( Peter Clark Frodo Sam Tony Natalia Mary Diana Sherlock )
    last_names = %w( Parker Kent Baggins Gamgi Stark Romanova Jane Prince Holmes )
    companies = %w( StarkIndustries CentralPerk )
    addresses = %w( 221BBakerSt 1600Pennsylvania TheShire YellowBrickRd )
    items = %w( RedCape EnergyGenerator Pipe Brain Heart Courage TheOneRing )
    attributes = [
      'purchaser name', 'item description', 'item price', 'purchase count',
      'merchant address', 'merchant name'
    ]

    file_name = SecureRandom.uuid + '.tab'
    file_path = Rails.root.join('tmp', file_name)
    File.open(file_path, 'wb') do |f|
      gross_value = 0

      f.write( attributes.join("\t") + "\n" )
      NUM_PURCHASES.times do
        attrs = {
          'purchaser name'   => names.shuffle.first,
          'item description' => items.shuffle.first,
          'item price'       => (rand * 100).round(2),
          'purchase count'   => (rand * 10).to_i,
          'merchant address' => addresses.shuffle.first,
          'merchant name'    => companies.shuffle.first,
        }
        f.write( attrs.values.join("\t") + "\n" )
        gross_value += attrs['item price'] * attrs['purchase count']
      end
      logger.info("Generated #{gross_value.round(2)} worth of purchases.")
      logger.info("File: #{file_path}")
    end
  end
end
