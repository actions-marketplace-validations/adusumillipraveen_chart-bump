# Container image that runs your code
FROM alpine:3.12

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY . /
RUN /install.sh
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/bump-charts.sh"]