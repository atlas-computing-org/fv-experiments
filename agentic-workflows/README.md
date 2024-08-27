# Setup

## LangChain

1. Install Nix.

2. Clone this repository.

3. Sign up for Claude organizational account, get a basic/free plain and create an API key. Put the API key in the `.env` file. Check that the `.env` file is listed in the `.gitignore` file so the key does not get committed to the git repo.

   ```
   ANTHROPIC_API_KEY=sk-ant-api03-XXXXXXXXXX
   ```

3. Run the test.

   ```
   nix develop
   python test.py
   ```

## References

* https://gist.github.com/RobFisher/0d1e8bb008147a72c014c876051f9c5b 
* https://discourse.nixos.org/t/installing-a-python-package-from-pypi/24553 


