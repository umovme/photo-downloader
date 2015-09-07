# photo-downloader

Setup
-------------
* Clone the repository below...
```
git clone https://github.com/umovme/photo-downloader.git
```
* Access the repository folder
```
cd photo-downloader
```
* Run setup.rb file to configure the application
```
ruby setup.rb
```

Configuration
-------------
* Put the CSV files within the folder ./files_to_process 
* Open the conf/environment.yml file and configure the variables for running the application as shown below 

```
index_first_level_photo_folder: 3
```
Index in the CSV file that will represent the name of the top-level folder (ex.: ssn/name of client)

```
index_second_level_photo_folder: 0
```
Index in the CSV file that will represent the name of second-level folder (eG.: execution date ... 2015-01-01)

```
indexes_photo_url:
    - 33
    - 35
    - 43
```
Index list in the CSV file that indicates which columns may contain URLs for photo download

* Run the run.br file to process the CSV files
```
ruby run.rb
```

Result
-------------
* The photos will be saved in the folder ./photos 
```
./photos
    /index_first_level_photo_folder
          /index_second_level_photo_folder
                /indexes_photo_url.jpg
```