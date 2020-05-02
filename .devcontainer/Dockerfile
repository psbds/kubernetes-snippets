FROM psbds/dev-container-aks:v1.3.0

WORKDIR akssnippets-cli

COPY . .

RUN echo 'source /workspaces/$(ls /workspaces)/cli/autocomplete.bash' >> ~/.bashrc
RUN echo 'alias akssnippets="/bin/bash /workspaces/$(ls /workspaces)/cli/index.bash"' >> ~/.bashrc