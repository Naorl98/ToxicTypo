#!/bin/bash

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password=stdin 324037305534.dkr.ecr.ap-south-1.amazonaws.com

docker rm -f toxic

docker pull 324037305534.dkr.ecr.ap-south-1.amazonaws.com/toxic-naor:latest

docker run -d -p 8080:8083 --name toxic 324037305534.dkr.ecr.ap-south-1.amazonaws.com/toxic-naor:latest