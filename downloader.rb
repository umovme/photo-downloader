require 'csv_hasher'
require 'open-uri'
require 'fileutils'

class PhotoDownloadGenerator

  PHOTO_PATH = "/tmp/photos"

  def run path_csv
    counter = 0;
    begin
        file = File.new(path_csv, "r")
        while (line = file.gets)
            counter = counter + 1
            process_data(line, counter)
        end
        file.close
    rescue => err
        puts "Exception: #{err}"
        err
    end
    
  end

  def process_data line, counter

    if( is_first_line counter )
        puts "Ignoring header ..."
    else
        download_photo line
    end

  end

  def download_photo line
    columns = CSV.parse(line, :col_sep => ?;, headers: false)
    columns.each do |column|
       
       photo_url = get_photo_by_index column
       
       if is_photo photo_url
          puts "record with photo ... downloading photo #{photo_url}"
          build_photo photo_url, column
       else
         puts "record has no photo"
       end
    
    end
  end

  def build_photo photo_url, column
      photo_name = extract_photo_name photo_url
      customer_identifier = extract_customer_identifier column
      customer_photo_folder = "#{PHOTO_PATH}/#{customer_identifier}"
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

  def is_photo photo_url
    photo_url.include? "http://picviewer" 
  end

  def extract_customer_identifier row
      row[3]
  end

  def get_photo_by_index row
    row[43]
  end

end

#photo_downloader=PhotoDownloader.new
#photo_downloader.run '/Users/gelias/Downloads/visitas.csv'

photo_generator = PhotoDownloadGenerator.new
photo_generator.run '/tmp/Pesquisa_ASSERT.csv'
