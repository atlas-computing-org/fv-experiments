# Llama Server


## Setup

1. Create instance of `g5.xlarge` on AWS. Cost is about $1/hr. You may need to request quota increase for the number of vCPUs in on-demand G instances to 4.
   * Application and OS Images: Ubuntu Server 24.04 LTS, 64-bit (x86)
   * Instance type: g5.xlarge
   * Security group: open inbound port 8501 for tcp, in addition to port 22 for ssh.
   * Configure storage: need at least 32 GiB gp3

2. Set up SSH
   * Create config file
     ```
     touch ~/.ssh/config
     chmod 600 ~/.ssh/config
     ```

   * Copy `.pem` file into `~/.ssh` folder and give appropriate permissions
     ```
     chmod 600 ~/.ssh/llama-key.pem
     ```

   * Put into `~/.ssh/config`
     ```
     Host llama
       HostName 3.137.144.145
       User ubuntu
       Port 22
       IdentityFile ~/.ssh/llama-key.pem
     ```

3. Install Python. Create conda environment and activate it.
   ```
   curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
   bash Miniforge3-$(uname)-$(uname -m).sh
   conda create --name aifv
   conda activate aifv
   ```

4. Install ollama and download Llama3.
   ```
   curl -fsSL https://ollama.com/install.sh | sh
   ollama pull llama3
   ```

5. Install LangChain and StreamLit.
   ```
   conda install langchain langchain-community streamlit -c conda-forge
   ```

6. Run the app in tmux session. (To return to tmux session, use `tmux a -t llama`.)
   ```
   tmux new -t llama
   conda activate aifv
   streamlit run app.py
   ```

7. View app from browser, by going to http://XXX.XXX.XXX.XXX:8501, where the XXXs form the server's public IP address.

## Notes

* Tried using [vLLM](https://python.langchain.com/v0.2/docs/integrations/llms/vllm/) but it requires more specialized GPU hardware, e.g. A100, H100.

## References

* [How to install and deploy llama 3 into production](https://nlpcloud.com/how-to-install-and-deploy-llama-3-into-production.html)
* [Local RAG agent with Llama3](https://github.com/langchain-ai/langgraph/blob/main/examples/rag/langgraph_rag_agent_llama3_local.ipynb)
* [Streamlit and LangChain](https://python.langchain.com/v0.2/docs/integrations/memory/streamlit_chat_message_history/)
