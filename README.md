# photo-downloader

setup
-------------
* Clonar o repositório abaixo ...
```
git clone https://github.com/umovme/photo-downloader.git
```
* Acesse a pasta do repositório
```
cd photo-downloader
```
* Execute o arquivo setup.rb para configurar o aplicativo
```
ruby setup.rb
```

configure
-------------
* Coloque os arquivos CSV dentro da pasta ./files_to_process
* Abra o arquivo conf/environment.yml e configure as variaveis para execução do aplicativo conforme é mostrado abaixo

```
index_first_level_photo_folder: 3
```
Indice no arquivo CSV que representará o nome da pasta de primeiro nível( ex.: cnpj/nome do cliente)

```
index_second_level_photo_folder: 0
```
Indice no arquivo CSV que representará o nome da pasta de segundo nível(ex.: data de execução ... 2015-01-01)

```
indexes_photo_url:
    - 33
    - 35
    - 43
```
Lista de índices no arquivo CSV que indica quais colunas podem conter URLs para download de photo

* Rode o arquivo run.rb para processar os arquivos CSVs
```
ruby run.rb
```

result
-------------
* As fotos serão salvas na pasta ./photos
```
./photos
    /index_first_level_photo_folder
          /index_second_level_photo_folder
                /indexes_photo_url.jpg
```
