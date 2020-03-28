FROM psbds/dev-container-aks:v1.1.3


WORKDIR akssnippets-cli

COPY . .

RUN echo "source /akssnippets-cli/cli/autocomplete.bash" >> ~/.bashrc
RUN echo "alias akssnippets=/akssnippets-cli/cli/index.bash" >> ~/.bashrc