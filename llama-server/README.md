# Llama Server


## Setup

1. Create instance of `g5.xlarge` on AWS. Cost is about $1/hr. You may need to request quota increase for the number of vCPUs in on-demand G instances to 4.
   * Application and OS Images: Ubuntu Server 24.04 LTS, 64-bit (x86)
   * Instance type: g5.xlarge
   * Security group: open inbound port 8501 for tcp, in addition to port 22 for ssh.
   * Configure storage: need at least 64 GiB gp3

2. On your local computer, set up SSH to make it easier to log into the instance (through command line or VS Code).
   * Copy `.pem` file into `~/.ssh` folder and give appropriate permissions
     ```
     chmod 600 ~/.ssh/llama-key.pem
     ```
     
   * Create config file
     ```
     touch ~/.ssh/config && chmod 600 ~/.ssh/config
     ```

   * Put into `~/.ssh/config`
     ```
     Host llama
       HostName 3.137.144.145
       User ubuntu
       Port 22
       IdentityFile ~/.ssh/llama-key.pem
     ```

3. Install [NVIDIA drivers and CUDA toolkit](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/). 
   ```
   # install gcc, make, cmake and build-essential
   sudo apt-get update && sudo apt install gcc make cmake build-essential

   # download install script
   wget https://developer.download.nvidia.com/compute/cuda/12.6.1/local_installers/cuda_12.6.1_560.35.03_linux.run

   # run install script
   sudo sh cuda_12.6.1_560.35.03_linux.run

   # test installation
   nvcc --version
   nvidia-smi
   
   # add to paths
   echo "export PATH=/usr/local/cuda-12.6/bin${PATH:+:${PATH}}" > ~/.bashrc
   echo "export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" > ~/.bashrc

   # reboot
   sudo reboot
   ```
   For other ways of testing the installation, see [this guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/#verify-the-installation), which also lists additional packages which need to be installed for building the CUDA samples.

4. Install Nix and enable Nix flakes.
   ```
   sh <(curl -L https://nixos.org/nix/install) --daemon --yes
   mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
   ```

5. Clone this repository, and navigate to the project folder.

6. Build the nix shell. This step will take a long time because of CUDA and Ollama. Use `cachix` if you want to speed things up.
   ```
   nix develop
   ```
   At the end, we have a shellhook that runs `ollama serve`. Look for the words "Nvidia GPU detected" to verify that Ollama is interfacing with the GPUs. Now, press "Ctrl+D" to detach from the shell.

7. Run the app in tmux session. (To return to tmux session, use `tmux a -t llama`.) Note that the first time you send a query to the llama model, it takes a long time to respond because it is loading the model into the GPUs. Subsequent queries should be a lot faster.
   ```
   tmux new -t llama
   nix develop
   streamlit run app.py
   ```

8. View app from browser, by going to http://XXX.XXX.XXX.XXX:8501, where the XXXs form the server's public IP address.

## Notes

* Tried using [vLLM](https://python.langchain.com/v0.2/docs/integrations/llms/vllm/) but it requires more specialized GPU hardware, e.g. A100, H100.

## References

* [How to install and deploy llama 3 into production](https://nlpcloud.com/how-to-install-and-deploy-llama-3-into-production.html)
* [Local RAG agent with Llama3](https://github.com/langchain-ai/langgraph/blob/main/examples/rag/langgraph_rag_agent_llama3_local.ipynb)
* [Streamlit and LangChain](https://python.langchain.com/v0.2/docs/integrations/memory/streamlit_chat_message_history/)
* https://stackoverflow.com/questions/78159761/how-can-i-adjust-the-nix-flake-configuration-for-my-virtual-environment-to-ensur 
