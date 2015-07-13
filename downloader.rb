require 'csv_hasher'
require 'open-uri'

class PhotoDownloader

	def run path_csv
		csv_text = File.read(path_csv).encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    	csv = CSV.parse(csv_text, headers: false)
    	csv.each do |row|
	      puts row[1]
	      open(row[1]) {|f|
   			File.open("foto.jpg","wb") do |file|
     			file.puts f.read
   			end
		  }

    	end
	end

end

class PhotoDownloadGenerator

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

        csv_data = CSV.parse(line, :col_sep => ?;, headers: false)
        csv_data.each do |row|
          photo_url = get_photo_by_index row
          if is_photo photo_url
              open(photo_url) { |f|
                File.open("#{counter}.jpg","wb") do |file|
                  file.puts f.read
                end
              }
          end
        end
        
        puts "photo generated"
    end

  end

  def is_first_line counter
    counter == 1 
  end

  def is_photo photo_url
    photo_url.include? "http://"  and photo_url.include? ".jpg"
  end

  def get_photo_by_index row
    row[1]
  end

end

#photo_downloader=PhotoDownloader.new
#photo_downloader.run '/Users/gelias/Downloads/visitas.csv'

photo_generator = PhotoDownloadGenerator.new
photo_generator.run '/Users/gelias/Downloads/visitas.csv'
