[![On-Premise ETL][repo_banner_img]][repo_url]

> Crop: "Diogenes", John William Waterhouse, *circa* 1882, oil on canvas. [Image source.][repo_banner_url]

# On-Premise ETL

[![Python version][py_version_img]][repo_url]
[![Python style guide][py_style_guide_img]][repo_url]
[![Python code coverage][py_code_coverage_img]][repo_url]
[![Repo wiki][repo_wiki_img]][repo_wiki_url]
[![Repo license][repo_license_img]][repo_license_url]

A basic On-Premise ETL pipeline showcasing Python/SQL best practices and fundamental knowledge on dimensional modeling.

The project currently make use of a small dataset in order showcase the necessary steps taken when preparing data for being stored as fact tables within a data warehouse.

## ⚡️ Getting started
1. First, [download][py_download_url] and install **Python**. Version `3.7` or higher is required.
2. Secondly, [download][pg_download_url] and install **PostgreSQL**. Version `10` or higher is required.

With both software installed create a `.env` file within the **src/util/** directory and paste in following code. Make sure to remove the templated text with your own configuration.
```env
USER='your-username'
PASSWORD='your-password'
HOST='database-host'
PORT='database-port'
DBNAME='database-name'
```

Now run the following commands via the terminal, from your project root directory, or in this case repo root directory. The snippet below creates a Python `venv`, activates it, and installs the Python dependencies required to run this project.
```bash
python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt
```
The setup is now finished and you can now move onwards 🚀.

## 📖 Project wiki
Explore all theoretical and techinical aspects of each topic in **On-Premise ETL** by reading the project [Wiki][repo_wiki_url].

## 🔡 Dimensional modeling
Dimensional modeling supports business users to query data in a data warehouse system and is oriented to improve the query perfomance and ease of use.

The project is built based on star schema with fact tables at the center surrounded by a number of dimension tables. The following four-step process was used in determining the design of the dimension and fact tables:
1. **Choosing business process to a model** – The first step is to decide what business process to model by gathering and understanding business needs and available data.
2. **Declare the grain** - The second step is to describe exactly what a fact table record represents.
3. **Choose the dimensions** – The third step is to determine dimensions for the fact table.
4. **Identify facts** – The forth step is to identify carefully which facts will appear in the fact table.

The following images below showcase the transformation of the dataset from an OLTP or source source system to OLAP or data warehouse.
<p align="center">Entity relationship diagram showcasing the business of a film rental store.</p>
<p align="center"><img src="https://github.com/blktheta/on-premise-etl/blob/main/media/entityrelationship.png"></p>
<p align="center">Transactional and accumulating fact tables showcasing how measurements are recorded.</p>
<p align="center"><img src="https://github.com/blktheta/on-premise-etl/blob/main/media/starschema.png"></p>

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
[oltp_img]: https://github.com/blktheta/on-premise-etl/blob/main/media/entityrelationship.png
[olap_img]: https://github.com/blktheta/on-premise-etl/blob/main/media/starschema.png

