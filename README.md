[![On-Premise ETL][repo_banner_img]][repo_url]

> Crop: "Diogenes", John William Waterhouse, *circa* 1882, oil on canvas. [Image source.][repo_banner_url]

# On-Premise ETL

[![Python version][py_version_img]][repo_url]
[![Python style guide][py_style_guide_img]][repo_url]
[![Python code coverage][py_code_coverage_img]][repo_url]
[![Repo wiki][repo_wiki_img]][repo_wiki_url]
[![Repo license][repo_license_img]][repo_license_url]

A basic On-Premise ETL pipeline showcasing Python/SQL best practices and fundamental knowledge on data modeling.

## ⚡️ Getting started
1. First, [download][py_download_url] and install **Python**. Version `3.7` or higher is required.
2. Secondly, [download][pg_download_url] and install **PostgreSQL**. Version `10` or higher is required.

With both software installed create a `.env` file within the **src/util/** directory and past in following code.
```env
USER='your-username'
PASSWORD='your-password'
HOST='database-host'
PORT='database-port'
DBNAME='database-name'
```

Now run the following commands via the terminal, from your project root directory, or in this case repo root directory.
```bash
python3 -m venv venv              # create a venv
. venv/bin/activate               # activate venv
pip install -r requirements.txt   # install requirements
```
The setup is now finished and you can move onwards 🚀.

## 📖 Project wiki
Explore all theoretical and techinical aspects of each topic in **On-Premise ETL** by reading the project [Wiki][repo_wiki_url].

## 🔧 Usage
Usage description.

## ⭐️ Project assistance
If you want to say **thank you** or/and support a lone developers journey:

- Add a [GitHub Star][repo_url] to the project.
- Reach out to [Blk Theta][author].

## ⚠️ License
[`On-Premise ETL`][repo_url] is free and open-source software licensed under the [MIT License][repo_license_url]. All designs were created by [Blk Theta][author] and distributed under Creative Commons license (CC BY-NC-SA 4.0 International).

<!--Python-->
[py_version_img]: https://img.shields.io/badge/Python-3.11.5-yellow?style=for-the-badge&logo=none
[py_style_guide_img]: https://img.shields.io/badge/Style_guide-PEP8-blue?style=for-the-badge&logo=none
[py_code_coverage_img]: https://img.shields.io/badge/Code_coverage-NA-success?style=for-the-badge&logo=none

<!-- Repository -->
[repo_url]: https://github.com/blktheta/on-premise-etl
[repo_banner_url]: https://upload.wikimedia.org/wikipedia/commons/7/7a/Waterhouse-Diogenes.jpg
[repo_banner_img]: https://github.com/blktheta/on-premise-etl/blob/main/media/diogenes-waterhouse.png
[repo_wiki_url]: https://github.com/blktheta/on-premise-etl/wiki
[repo_wiki_img]: https://img.shields.io/badge/docs-wiki_page-lightgrey?style=for-the-badge&logo=none
[repo_license_url]: https://github.com/blktheta/on-premise-etl/blob/main/LICENSE.md
[repo_license_img]: https://img.shields.io/badge/license-MIT-red?style=for-the-badge&logo=none

<!-- Author -->
[author]: https://github.com/blktheta

<!-- Readme links -->
[py_download_url]: https://www.python.org/downloads/
[pg_download_url]: https://www.postgresql.org/download/
