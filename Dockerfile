FROM jupyter/all-spark-notebook

# Install in the default python3 environment
RUN pip install --no-cache-dir 'flake8' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install One Dark Theme
RUN cd /tmp/ && \ 
git clone https://github.com/onepan/jupyterlab_onedarkpro.git && \
cd jupyterlab_onedarkpro && \
jupyter labextension develop . --overwrite && \
jlpm run build && \
echo "c.Completer.use_jedi = False" >> /etc/ipython/ipython_kernel_config.py

# Install Pyright LSP
RUN npm install --save-dev pyright

# Install from the requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/
RUN pip install --no-cache-dir --requirement /tmp/requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
