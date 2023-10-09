# Searcher

Searcher app search function is implemented to search single word terms,
trying to search more than one word at a time will not bring any results.

# Setting Searcher up
Working Docker is needed for running this app, Desktop Docker works well 

Open terminal and clone git repo to your computer with command 
```
git clone https://github.com/kaiajogiste/searcher
```
open searcher folder in explorer/finder or anywhere where you can change file name, 
choose docker-compose file based on your operating system and change its name to docker-compose.yml
```
docker-compose-linux.yml
docker-compose-macOS.yml
docker-compose-windows.yml
```
go back to terminal, navigate to searcher folder
```
cd searcher
```
use this command to build and run Docker 
```
docker-compose up -d --build
```
wait until Docker is running and open http://localhost:8080/searcher in your browser
