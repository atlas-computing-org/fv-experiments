# Setup

## LangChain

1. Install Miniforge

   https://github.com/conda-forge/miniforge

2. Create conda environment and activate it.

   ```
   conda create --name aifv python=3.13
   conda activate aifv
   ```

3. Install LangChain, its Anthropic API, and `dotenv` for storing passwords.

   ```
   conda install langchain -c conda-forge
   conda install langchain-anthropic -c conda-forge
   conda install python-dotenv -c conda-forge
   ```

4. Sign up for Claude organizational account, get a basic/free plain and create an API key. Put the API key in the `.env` file. Check that the `.env` file is listed in the `.gitignore` file so the key does not get committed to the git repo.

   ```
   ANTHROPIC_API_KEY=sk-ant-api03-XXXXXXXXXX
   ```

5. Run the test.

   ```
   python test.py
   ```




