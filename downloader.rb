require 'csv_hasher'
require 'open-uri'
require 'fileutils'

class PhotoDownload

  PHOTO_PATH = "/tmp/photos"
  CSV_FILES_FOLDER = "/tmp/*.csv"

  def run
    files = Dir[CSV_FILES_FOLDER]
    files.each do |filename|
      file = File.new(filename, "r")
      puts "Starting processing file #{File.absolute_path(file)}"
      load file
      file.close
    end
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
        puts "Exception: #{err}"
        err
    end
  end

  def process_data line, counter
    if( is_first_line counter )
        puts "Ignoring header ..."
        return ''
    end

    if( is_last_line line)
        puts "Last line ... download of photo finished successfully!!!"
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
            puts "Found record with photo #{photo_url}"
            build_photo photo_url, column
         end

      rescue => err
          puts "Error while downloading photo: #{err}"
      end
    end
  end

  def build_photo photo_url, column
      photo_name = extract_photo_name photo_url
      customer_identifier = extract_customer_identifier column
      current_date = Time.new.strftime("%Y-%m-%d")
      customer_photo_folder = "#{PHOTO_PATH}/#{customer_identifier}/#{current_date}"
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
      row[3]
  end

  def get_photo_by_index row
    row[43]
  end

  def rename_file_to_processed file
    original_filename = File.absolute_path(file)
    filename_processed = "#{File.absolute_path(file)}.processado"
    puts "Renomeando arquivo ...#{original_filename} para #{filename_processed}"
    File.rename(original_filename, filename_processed)
  end

end

photo_generator = PhotoDownload.new
photo_generator.run
