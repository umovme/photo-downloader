# Photo Downloader

##1. Introdução
O Photo Downloader é um serviço que armazena as fotos obtidas durante a execução de atividade na plataforma uMov.me. 
Após exportar o arquivo no formato *.CSV* contendo os dados coletados, é preciso mapear em um arquivo de configuração quais os indices (do .CSV) as fotos/imagens estão localizados e também permite configurar pastas e subpastas para melhor organização das fotos armazenadas.

##2. Instalação
Para executar o Photo Downloader é preciso realizar os passos abaixo

####2.1. Instalar Ruby
O serviço foi desenvolvido na linguagem ruby, por isso é necessário instalar esta a linguagem na máquina onde o serviço será executado. Os instaladores podem ser obtidos em: 
* Windows: http://rubyinstaller.org/
* Unix based: https://www.ruby-lang.org/en/

####2.2. Instalar Ruby Gems
RubyGem é uma biblioteca, um conjunto de arquivos Ruby reusáveis, necessário para executar programas desenvolvidos na linguagem ruby.
Pode ser obtido em https://rubygems.org

####2.3. Download do serviço
O serviço está disponibilizado publicamente em https://github.com/umovme/photo-downloader e existem duas maneira de baixá-lo:
*Realizar o download do [arquivo zip](https://github.com/umovme/photo-downloader/archive/master.zip)
*Clonar o projeto executando o comando no terminal: `git clone https://github.com/umovme/photo-downloader.git`

####2.4. Instalando o Photo Downloader
Após baixar o serviço, acesse o diretório **/photo-downloader** (caso baixar o zip então o diretorio será **/photo-downloader-master**) e execute o comando abaixo para configurar a aplicação:
`ruby setup.rb `

Após a execução do `setup.rb` serão criadas as pastas **/file-to-process**, **/photo** e a **/log**

##3. Configuração
O arquivo, no formato *.CSV*, contendo os dados exportados deve ser incluído na pasta **/file-to-process**
	
####3.1. Configuração do ambiente
O arquivo **/conf/environment.yml** destina-se à configuração das pastas, subpastas  e fotos atribuindo a cada uma delas o respectivo índice no arquivo exportado.
No exemplo abaixo, foi definido que será criado uma pasta **/photos** contendo as subpastas definidas no índice 3 e 0, respectivamente para a pasta de primeiro nível e de segundo nível. As fotos serão encontrados nos índices 33, 34 e 45
```
photo_path: photos
files_folder: files_to_process
files_extension: '*.csv'
index_first_level_photo_folder: 3
index_second_level_photo_folder: 0
indexes_photo_url:
    - 33
    - 35
    - 43
```

OBS: Os parâmetros `photo_path`, `files_folder` e `files_extension` podem ser alterados, porém é preciso que seja realizado antes de rodas o comando `ruby setup.rb`

##4. Executar o serviço
Visto que a instalação e configuração foram realizadas com sucesso, então o serviço está pronto para ser executado, para tanto execute o comando abaixo. 
`ruby run.rb` 

##5. Verificação dos logs do serviço
O arquivo de log é gerado a cada execução do serviço, caso ainda não exista. Serve basicamente para informar cada linha que está sendo processada, verificando se existe foto nos indices informados anteriormente.
