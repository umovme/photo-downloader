# photo-downloader

Setup
-------------
* Clone the repository ...
```
git clone https://github.com/umovme/photo-downloader.git
```
* Access de repo folder
```
cd photo-downloader
```
* Run the setup.rb file
```
ruby setup.rb
```

Configure
-------------
* Put CSV files into folder files_to_process
* Open file conf/environment.yml and configure the index variables
```
index_customer_folder: 3
index_execution_date_folder: 0
index_photo_url: 43
```
* Run the run.rb file to process the CSV files
```
ruby run.rb
```

Result
-------------
* The photos is going to be saved into ./photos folder
