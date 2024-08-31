# Setup

## LangChain

1. Create instance of `t3.medium` on AWS. 
   * Application and OS Images: Ubuntu Server 24.04 LTS, 64-bit (x86)
   * Instance type: t3.medium
   * Security group: open inbound port 8501 for tcp, in addition to port 22 for ssh.
   
2. Install Nix and enable Nix flakes.
   ```
   sh <(curl -L https://nixos.org/nix/install) --daemon --yes
   mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
   ```

3. Clone this repository, and navigate to the project folder.

4. Sign up for Claude organizational account, get a basic/free plain and create an API key. Put the API key in the `.env` file. Check that the `.env` file is listed in the `.gitignore` file so the key does not get committed to the git repo.

   ```
   ANTHROPIC_API_KEY=sk-ant-api03-XXXXXXXXXX
   ```

5. Run the app in tmux session. (To return to tmux session, use `tmux a -t llama`.)
   ```
   tmux new -t llama
   conda activate aifv
   streamlit run app.py
   ```

6. View app from browser, by going to http://XXX.XXX.XXX.XXX:8501, where the XXXs form the server's public IP address.


## References

* https://gist.github.com/RobFisher/0d1e8bb008147a72c014c876051f9c5b 
* https://discourse.nixos.org/t/installing-a-python-package-from-pypi/24553 


