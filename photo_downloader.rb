# encoding: UTF-8
require 'csv_hasher'
require 'open-uri'
require 'fileutils'
require 'yaml'
require 'logging'

class PhotoDownloader

  def initialize
    @logger = Logging.logger('log/photo_downloader.log')
    @logger.level = :info
  end

  def photo_path
    @@settings['photo_path']
  end

  def files_folder
    @@settings['files_folder']
  end

  def files_extension
    @@settings['files_extension']
  end

  def load_settings
    @@settings=YAML.load_file(File.join(File.dirname(__FILE__), 'conf/environment.yml'))
  end

  def run
    log_start_process
    load_settings
    load_files.each do |filename|
      process_file filename
    end
    log_finish_process
  end

  def process_file filename
    file = File.new(filename, "r")
    @logger.info "  Starting processing file #{File.absolute_path(file)}"
    load file
    file.close
  end

  def load_files
    file = files_folder + '/' + files_extension
    files = Dir[file]
  end

  def log_finish_process
    @logger.info "Downloads finished successfully!!"
    @logger.info "=========================================="
  end

  def log_start_process
    @logger.info "=========================================="
    @logger.info "Starting downloading photos process ... "
  end

  def load file
    counter = 0;
    begin
        while (line = file.gets)
            counter = counter + 1
            process_data(line, counter)
        end
        rename_file_to_processed file
    rescue => err
        @logger.info "Exception: #{err}"
        err
    end
  end

  def process_data line, counter
    if( is_first_line counter )
        @logger.info "Ignoring header ..."
        return ''
    end

    if( is_last_line line)
        @logger.info "Last line ... download of photo finished successfully!!!"
        return ''
    end
    
    download_photo line
  end

  def download_photo line
    columns = CSV.parse(line, :col_sep => ?;, headers: false)
    columns.each do |column|
      begin 
         photo_url = get_photo_by_index column
         
         if is_photo photo_url
            @logger.info "Found record with photo #{photo_url}"
            build_photo photo_url, column
         end

      rescue => err
          @logger.info "Error while downloading photo: #{err}"
      end
    end
  end

  def build_photo photo_url, column
      photo_name = extract_photo_name photo_url
      customer_identifier = extract_customer_identifier column
      execution_date = extract_execution_date column
      customer_photo_folder = "#{photo_path}/#{customer_identifier}/#{execution_date}"
      FileUtils::mkdir_p customer_photo_folder
      open(photo_url) { |f|
          File.open("#{customer_photo_folder}/#{photo_name}.jpg","wb") do |file|
              file.puts f.read
          end
      }
  end

  def extract_photo_name photo_url
      initial_index = photo_url.index("?")
      final_index = photo_url.index("&")
      photo_url[initial_index + 4 .. final_index - 1 ]
  end

  def is_first_line counter
    counter == 1 
  end

  def is_last_line line
    line.include? "FIM;"
  end

  def is_photo photo_url
    photo_url.include? "http://picviewer" 
  end

  def extract_customer_identifier row
      index_customer_folder = @@settings['index_customer_folder']
      row[index_customer_folder]
  end

  def extract_execution_date row
    index_execution_date_folder = @@settings['index_execution_date_folder']
    row[index_execution_date_folder]
  end

  def get_photo_by_index row
    index_photo_url = @@settings['index_photo_url']
    row[index_photo_url]
  end

  def rename_file_to_processed file
    original_filename = File.absolute_path(file)
    filename_processed = "#{File.absolute_path(file)}.processado"
    @logger.info "Renomeando arquivo ...#{original_filename} para #{filename_processed}"
    File.rename(original_filename, filename_processed)
  end

end